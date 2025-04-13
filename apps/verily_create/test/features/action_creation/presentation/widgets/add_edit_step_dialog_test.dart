import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:verily_client/verily_client.dart' as protocol;
import 'package:verily_client/src/protocol/client.dart'; // Import EndpointAction if necessary
import 'package:verily_create/main.dart'; // For client mock setup
import 'package:verily_create/features/action_creation/presentation/widgets/add_edit_step_dialog.dart';

// Mocks
class MockClient extends Mock implements protocol.Client {}

// Mock the client-side Endpoint class, assuming EndpointAction based on linter error
class MockActionEndpoint extends Mock implements EndpointAction {}

void main() {
  // Setup Mock Client
  late MockClient mockClient;
  late MockActionEndpoint mockActionEndpoint;

  setUp(() {
    mockClient = MockClient();
    mockActionEndpoint = MockActionEndpoint();
    // Stub the client getter to return the mock endpoint
    when(() => mockClient.action).thenReturn(mockActionEndpoint);
    // Override the client provider
    // Note: You might need a way to override the global `client` variable
    // if it's directly used. A common pattern is to inject it via a provider.
    // For simplicity here, we assume a mechanism to replace the global client
    // or that the widget under test receives the client via constructor/provider.
    // If `client` is a global variable defined in main.dart, true unit testing
    // becomes harder. Consider refactoring to use Riverpod for client injection.
    // For now, we'll proceed assuming the widget can access our mock.
    // A potential (but less ideal) approach:
    // client = mockClient; // Only if 'client' is accessible and mutable here.
  });

  // Helper to pump the widget
  Future<void> pumpDialog(
    WidgetTester tester, {
    required int actionId,
    protocol.ActionStep? existingStep,
  }) async {
    // Override the client provider for the test scope
    // We need a ProviderScope that overrides the actual client Provider
    // Let's assume there's a provider like:
    // final clientProvider = Provider<protocol.Client>((ref) => client);
    // If not, this override won't work directly.
    await tester.pumpWidget(
      ProviderScope(
        // Assuming 'clientProvider' exists and holds the global client instance
        // overrides: [clientProvider.overrideWithValue(mockClient)],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                // Button to launch the dialog
                return ElevatedButton(
                  onPressed: () {
                    showDialog<bool>(
                      context: context,
                      builder:
                          (_) => AddEditStepDialog(
                            actionId: actionId,
                            existingStep: existingStep,
                          ),
                    );
                  },
                  child: const Text('Show Dialog'),
                );
              },
            ),
          ),
        ),
      ),
    );

    // Tap the button to show the dialog
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle(); // Wait for dialog animation
  }

  testWidgets('AddEditStepDialog displays correctly for adding a new step', (
    WidgetTester tester,
  ) async {
    await pumpDialog(tester, actionId: 1);

    // Verify title
    expect(find.text('Add Action Step'), findsOneWidget);

    // Verify form fields exist
    expect(find.widgetWithText(TextFormField, 'Step Type'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Order'), findsOneWidget);
    expect(
      find.widgetWithText(TextFormField, 'Parameters (JSON)'),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(TextFormField, 'User Instruction (Optional)'),
      findsOneWidget,
    );

    // Verify buttons
    expect(find.widgetWithText(TextButton, 'Cancel'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Save Step'), findsOneWidget);
  });

  testWidgets(
    'AddEditStepDialog displays correctly for editing an existing step',
    (WidgetTester tester) async {
      final existingStep = protocol.ActionStep(
        id: 10,
        actionId: 1,
        type: 'location',
        parameters: '{"lat": 1.23, "lng": 4.56}',
        order: 5,
        instruction: 'Go to the park',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await pumpDialog(tester, actionId: 1, existingStep: existingStep);

      // Verify title
      expect(find.text('Edit Action Step'), findsOneWidget);

      // Verify fields are pre-filled
      expect(
        find.widgetWithText(TextFormField, existingStep.type),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(TextFormField, existingStep.order.toString()),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(TextFormField, existingStep.parameters),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(TextFormField, existingStep.instruction!),
        findsOneWidget,
      );

      // Verify buttons
      expect(find.widgetWithText(TextButton, 'Cancel'), findsOneWidget);
      expect(
        find.widgetWithText(ElevatedButton, 'Update Step'),
        findsOneWidget,
      );
    },
  );

  testWidgets('Shows validation error if Type field is empty', (
    WidgetTester tester,
  ) async {
    await pumpDialog(tester, actionId: 1);

    // Find the Save button and tap it
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save Step'));
    await tester.pump(); // Trigger validation

    // Verify error message for Type
    expect(find.text('Type is required'), findsOneWidget);
  });

  testWidgets('Shows validation error if Order field is empty or invalid', (
    WidgetTester tester,
  ) async {
    await pumpDialog(tester, actionId: 1);

    // Enter Type and Parameters to pass their validation
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Step Type'),
      'test_type',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Parameters (JSON)'),
      '{"valid": true}',
    );

    // Tap Save with Order empty
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save Step'));
    await tester.pump();
    expect(find.text('Order is required'), findsOneWidget);

    // Enter invalid Order
    await tester.enterText(find.widgetWithText(TextFormField, 'Order'), 'abc');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save Step'));
    await tester.pump();
    expect(find.text('Must be a number'), findsOneWidget);

    // Enter valid Order - error should disappear
    await tester.enterText(find.widgetWithText(TextFormField, 'Order'), '1');
    await tester.tap(
      find.widgetWithText(ElevatedButton, 'Save Step'),
    ); // Re-tap to re-validate
    await tester.pump();
    expect(find.text('Order is required'), findsNothing);
    expect(find.text('Must be a number'), findsNothing);
  });

  testWidgets(
    'Shows validation error if Parameters field is empty or invalid JSON',
    (WidgetTester tester) async {
      await pumpDialog(tester, actionId: 1);

      // Enter Type and Order to pass their validation
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Step Type'),
        'test_type',
      );
      await tester.enterText(find.widgetWithText(TextFormField, 'Order'), '1');

      // Tap Save with Parameters empty
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save Step'));
      await tester.pump();
      expect(find.text('Parameters are required'), findsOneWidget);

      // Enter invalid JSON
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Parameters (JSON)'),
        '{"invalid":',
      ); // Corrected quotes
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save Step'));
      await tester.pump();
      expect(find.text('Invalid JSON format'), findsOneWidget);

      // Enter valid JSON - error should disappear
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Parameters (JSON)'),
        '{"valid": true}',
      ); // Corrected quotes
      await tester.tap(
        find.widgetWithText(ElevatedButton, 'Save Step'),
      ); // Re-tap to re-validate
      await tester.pump();
      expect(find.text('Parameters are required'), findsNothing);
      expect(find.text('Invalid JSON format'), findsNothing);
    },
  );

  // TODO: Add tests for successful add/update interaction with mocked client
  // TODO: Add tests for error handling (e.g., client throwing exception)
}
