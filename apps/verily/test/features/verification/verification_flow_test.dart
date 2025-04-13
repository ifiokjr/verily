import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verily/src/features/verification/providers/verification_flow_provider.dart';
import 'package:verily/src/features/verification/screens/verification_screen.dart';
import 'package:verily/src/features/verification/state/verification_flow_state.dart';
import 'package:verily/src/features/verification/widgets/location_step_widget.dart';
import 'package:verily/src/features/verification/widgets/smile_step_widget.dart';
import 'package:verily/src/features/verification/widgets/speech_step_widget.dart';
import 'package:verily_client/verily_client.dart' as vc;

// Define a mock class for VerificationFlow
class MockVerificationFlow extends VerificationFlow {
  // Store the initial state separately if needed for comparison later
  VerificationFlowState? _initialStateOverride;

  @override
  VerificationFlowState build() {
    // Return the overridden initial state if provided, otherwise a default.
    return _initialStateOverride ??
        const VerificationFlowState(
          flowStatus: FlowStatus.inProgress, // Use inProgress as default
        );
  }

  // Method to explicitly set the state for the mock
  void setInitialState(VerificationFlowState state) {
    // Store the initial state and also set the current state
    _initialStateOverride = state;
    this.state = state;
  }

  // Override reportStepSuccess to *only* update the mock state for tests
  @override
  void reportStepSuccess(dynamic result) {
    if (state.action == null) {
      return; // Should not happen in valid test scenarios
    }
    // Use a local variable after the null check
    final action = state.action!;

    // Also check if steps list itself is null
    if (action.steps == null) {
      // Handle error or return, as steps are unexpectedly null
      reportStepFailure('Internal error: Action steps are missing.');
      return;
    }

    if (state.currentStepIndex >= action.steps!.length) {
      return; // Index out of bounds
    }

    final nextStepIndex = state.currentStepIndex + 1;
    final newStatuses = Map<int, StepStatus>.from(state.stepStatuses);
    newStatuses[state.currentStepIndex] = StepStatus.success;

    final newResults = Map<int, Map<String, dynamic>>.from(state.stepResults);
    // Cast the result before assigning, assuming it's always a Map here
    newResults[state.currentStepIndex] = result as Map<String, dynamic>;

    if (nextStepIndex >= action.steps!.length) {
      // Last step completed
      state = state.copyWith(
        flowStatus: FlowStatus.completed,
        stepStatuses: newStatuses,
        stepResults: newResults,
        currentStepIndex: nextStepIndex, // Keep index pointing past the end
        errorMessage: null,
      );
    } else {
      // Move to next step
      state = state.copyWith(
        currentStepIndex: nextStepIndex,
        stepStatuses: newStatuses,
        stepResults: newResults,
        errorMessage: null,
      );
    }
  }

  // Override reportStepFailure to *only* update the mock state for tests
  @override
  void reportStepFailure(String errorMessage) {
    if (state.action == null) return; // Should not happen

    final newStatuses = Map<int, StepStatus>.from(state.stepStatuses);
    newStatuses[state.currentStepIndex] = StepStatus.failure;

    state = state.copyWith(
      flowStatus: FlowStatus.failed,
      stepStatuses: newStatuses,
      errorMessage: errorMessage,
      // Keep currentStepIndex where it failed
    );
  }

  // Keep the initialize method, but ensure it uses the mock's state setting
  @override
  Future<void> initialize(int actionId) async {
    // In a real scenario, this fetches data.
    // In the mock, we assume the state is already set via setInitialState.
    // If _initialStateOverride is null, it means setInitialState wasn't called,
    // which implies the test wants the default initializing state from build().
    if (_initialStateOverride == null) {
      state = const VerificationFlowState(flowStatus: FlowStatus.inProgress);
    }
    // No actual async work needed in the mock's initialize
  }
}

// Helper function to create a pumpable test widget
Widget createVerificationScreen(int actionId) {
  return ProviderScope(
    child: MaterialApp(home: VerificationScreen(actionId: actionId)),
  );
}

// Helper to create a dummy Action with steps
vc.Action createDummyAction(int id, List<vc.ActionStep> steps) {
  return vc.Action(
    id: id,
    userInfoId: 1, // Use userInfoId instead of creatorId
    name: 'Test Action $id',
    description: 'A test action description.',
    steps: steps,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}

// Helper to create dummy ActionSteps
vc.ActionStep createDummyStep(int order, String type, String parametersJson) {
  return vc.ActionStep(
    id: order, // Use order as ID for simplicity in test
    actionId: 1, // Dummy action ID
    type: type,
    parameters: parametersJson,
    order: order,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Dummy action ID used for tests
  const testActionId = 1;

  // Variable to hold the mock notifier instance across tests
  MockVerificationFlow? mockNotifierInstance;

  group('Verification Flow Widget Tests', () {
    setUp(() {
      // Reset the mock instance before each test
      mockNotifierInstance = null;
    });

    // Test 1: Initial state shows loading/initializing
    testWidgets('shows initializing state initially', (tester) async {
      // We don't override here, just pump the default widget
      // The default state of the actual provider should be initializing
      await tester.pumpWidget(createVerificationScreen(testActionId));

      // Expect loading indicator or initializing text
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Initializing verification...'), findsOneWidget);
    });

    // Test 2: Displays the correct first step widget (e.g., Location)
    testWidgets('displays first step widget after initialization', (
      tester,
    ) async {
      final locationStep = createDummyStep(
        1,
        'location',
        '{"latitude": 10.0, "longitude": 20.0, "radius": 100.0}',
      );
      final smileStep = createDummyStep(2, 'smile', '{}');
      final testAction = createDummyAction(testActionId, [
        locationStep,
        smileStep,
      ]);

      // Define the expected state AFTER successful initialization
      final initialState = VerificationFlowState(
        flowStatus: FlowStatus.inProgress,
        action: testAction, // Action with steps loaded
        currentStepIndex: 0, // Pointing to the first step
        stepStatuses: {},
        stepResults: {},
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            verificationFlowProvider.overrideWith(() {
              final notifier = MockVerificationFlow();
              mockNotifierInstance = notifier;
              // Set the state *after* creating the instance
              Future.microtask(() => notifier.setInitialState(initialState));
              return notifier;
            }),
          ],
          child: MaterialApp(home: VerificationScreen(actionId: testActionId)),
        ),
      );

      // Pump again to ensure the UI reflects the overridden provider state
      await tester.pump();

      // Expect LocationStepWidget (the first step) to be displayed
      expect(find.byType(LocationStepWidget), findsOneWidget);
      // Ensure other steps are not present initially
      expect(find.byType(SmileStepWidget), findsNothing);
      expect(find.byType(SpeechStepWidget), findsNothing);
      // Check if the title reflects the action name
      expect(find.text('Verifying: ${testAction.name}'), findsOneWidget);
    });

    // Test 3: Displays SmileStepWidget for the second step
    testWidgets('displays second step widget (Smile)', (tester) async {
      final locationStep = createDummyStep(
        1,
        'location',
        '{"latitude": 10.0, "longitude": 20.0, "radius": 100.0}',
      );
      final smileStep = createDummyStep(2, 'smile', '{}');
      final speechStep = createDummyStep(3, 'speech', '{"phrase": "Hello"}');
      final testAction = createDummyAction(testActionId, [
        locationStep,
        smileStep,
        speechStep,
      ]);

      // Define the state representing the second step being active
      final stateForSecondStep = VerificationFlowState(
        flowStatus: FlowStatus.inProgress,
        action: testAction,
        currentStepIndex: 1, // Pointing to the second step (smile)
        stepStatuses: {0: StepStatus.success}, // Assume first step succeeded
        stepResults: {0: {}}, // Dummy result for first step
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            verificationFlowProvider.overrideWith(() {
              final notifier = MockVerificationFlow();
              mockNotifierInstance = notifier;
              Future.microtask(
                () => notifier.setInitialState(stateForSecondStep),
              );
              return notifier;
            }),
          ],
          child: MaterialApp(home: VerificationScreen(actionId: testActionId)),
        ),
      );

      await tester.pump();

      // Expect SmileStepWidget to be displayed
      expect(find.byType(SmileStepWidget), findsOneWidget);
      // Ensure other steps are not present
      expect(find.byType(LocationStepWidget), findsNothing);
      expect(find.byType(SpeechStepWidget), findsNothing);
      // Check title again
      expect(find.text('Verifying: ${testAction.name}'), findsOneWidget);
    });

    // Test 4: Displays SpeechStepWidget for the third step
    testWidgets('displays third step widget (Speech)', (tester) async {
      final locationStep = createDummyStep(
        1,
        'location',
        '{"latitude": 10.0, "longitude": 20.0, "radius": 100.0}',
      );
      final smileStep = createDummyStep(2, 'smile', '{}');
      final speechStep = createDummyStep(3, 'speech', '{"phrase": "Hello"}');
      final testAction = createDummyAction(testActionId, [
        locationStep,
        smileStep,
        speechStep,
      ]);

      // Define the state representing the third step being active
      final stateForThirdStep = VerificationFlowState(
        flowStatus: FlowStatus.inProgress,
        action: testAction,
        currentStepIndex: 2, // Pointing to the third step (speech)
        stepStatuses: {0: StepStatus.success, 1: StepStatus.success},
        stepResults: {0: {}, 1: {}}, // Dummy results
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            verificationFlowProvider.overrideWith(() {
              final notifier = MockVerificationFlow();
              mockNotifierInstance = notifier;
              Future.microtask(
                () => notifier.setInitialState(stateForThirdStep),
              );
              return notifier;
            }),
          ],
          child: MaterialApp(home: VerificationScreen(actionId: testActionId)),
        ),
      );

      await tester.pump();

      // Expect SpeechStepWidget to be displayed
      expect(find.byType(SpeechStepWidget), findsOneWidget);
      // Ensure other steps are not present
      expect(find.byType(LocationStepWidget), findsNothing);
      expect(find.byType(SmileStepWidget), findsNothing);
      // Check title again
      expect(find.text('Verifying: ${testAction.name}'), findsOneWidget);
    });

    // Test 5: Successfully completing Location step transitions to Smile step
    testWidgets('completing location step transitions to smile step', (
      tester,
    ) async {
      final locationStep = createDummyStep(
        1,
        'location',
        '{"latitude": 10.0, "longitude": 20.0, "radius": 100.0}',
      );
      final smileStep = createDummyStep(2, 'smile', '{}');
      final testAction = createDummyAction(testActionId, [
        locationStep,
        smileStep,
      ]);

      // Initial state: Location step is active
      final initialState = VerificationFlowState(
        flowStatus: FlowStatus.inProgress,
        action: testAction,
        currentStepIndex: 0,
        stepStatuses: {},
        stepResults: {},
      );

      // Use ProviderScope override
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            verificationFlowProvider.overrideWith(() {
              final notifier = MockVerificationFlow();
              // Set initial state directly in the mock instance
              notifier.setInitialState(initialState);
              return notifier;
            }),
          ],
          child: MaterialApp(home: VerificationScreen(actionId: testActionId)),
        ),
      );

      await tester.pump(); // Initial build

      // Verify LocationStepWidget is initially shown
      expect(find.byType(LocationStepWidget), findsOneWidget);
      expect(find.byType(SmileStepWidget), findsNothing);

      // --- Retrieve notifier from container ---
      final element = tester.element(find.byType(VerificationScreen));
      final container = ProviderScope.containerOf(element);
      final notifier =
          container.read(verificationFlowProvider.notifier)
              as MockVerificationFlow;
      // ---------------------------------------

      // Simulate successful completion using the retrieved notifier
      await tester.runAsync(() async {
        notifier.reportStepSuccess({'simulated': 'location success'});
      });

      // Add a minimal delay to ensure microtasks complete
      await Future.delayed(Duration.zero);

      // Pump the widget tree to reflect the state change and settle
      await tester.pumpAndSettle();

      // Verify that SmileStepWidget is now shown
      expect(find.byType(LocationStepWidget), findsNothing);
      expect(find.byType(SmileStepWidget), findsOneWidget);

      // Verify the provider state updated correctly using the same container
      final currentState = container.read(verificationFlowProvider);
      expect(currentState.currentStepIndex, 1);
      expect(currentState.stepStatuses[0], StepStatus.success);
    });

    // Test 6: Successfully completing Smile step transitions to Speech step
    testWidgets('completing smile step transitions to speech step', (
      tester,
    ) async {
      final locationStep = createDummyStep(
        1,
        'location',
        '{"latitude": 10.0, "longitude": 20.0, "radius": 100.0}',
      );
      final smileStep = createDummyStep(2, 'smile', '{}');
      final speechStep = createDummyStep(3, 'speech', '{"phrase": "Hello"}');
      final testAction = createDummyAction(testActionId, [
        locationStep,
        smileStep,
        speechStep,
      ]);

      // Initial state: Smile step is active (index 1), Location succeeded
      final initialState = VerificationFlowState(
        flowStatus: FlowStatus.inProgress,
        action: testAction,
        currentStepIndex: 1,
        stepStatuses: {0: StepStatus.success},
        stepResults: {0: {}}, // Dummy result for location
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            verificationFlowProvider.overrideWith(() {
              final notifier = MockVerificationFlow();
              notifier.setInitialState(initialState);
              return notifier;
            }),
          ],
          child: MaterialApp(home: VerificationScreen(actionId: testActionId)),
        ),
      );

      await tester.pump(); // Initial build

      // Verify SmileStepWidget is initially shown
      expect(find.byType(SmileStepWidget), findsOneWidget);
      expect(find.byType(LocationStepWidget), findsNothing);
      expect(find.byType(SpeechStepWidget), findsNothing);

      // --- Retrieve notifier from container ---
      final element = tester.element(find.byType(VerificationScreen));
      final container = ProviderScope.containerOf(element);
      final notifier =
          container.read(verificationFlowProvider.notifier)
              as MockVerificationFlow;
      // ---------------------------------------

      // Simulate successful completion of the smile step
      await tester.runAsync(() async {
        notifier.reportStepSuccess({'simulated': 'smile success'});
      });

      // Add a minimal delay
      await Future.delayed(Duration.zero);

      // Pump the widget tree to reflect the state change and settle
      await tester.pumpAndSettle();

      // Verify that SpeechStepWidget is now shown
      expect(find.byType(SmileStepWidget), findsNothing);
      expect(find.byType(SpeechStepWidget), findsOneWidget);

      // Verify the provider state updated correctly using the container
      final currentState = container.read(verificationFlowProvider);
      expect(currentState.currentStepIndex, 2);
      expect(currentState.stepStatuses[0], StepStatus.success);
      expect(currentState.stepStatuses[1], StepStatus.success);
    });

    // Test 7: Successfully completing final Speech step transitions to completed state
    testWidgets('completing speech step transitions to completed state', (
      tester,
    ) async {
      final locationStep = createDummyStep(
        1,
        'location',
        '{"latitude": 10.0, "longitude": 20.0, "radius": 100.0}',
      );
      final smileStep = createDummyStep(2, 'smile', '{}');
      final speechStep = createDummyStep(3, 'speech', '{"phrase": "Hello"}');
      final testAction = createDummyAction(testActionId, [
        locationStep,
        smileStep,
        speechStep,
      ]);

      // Initial state: Speech step is active (index 2), previous succeeded
      final initialState = VerificationFlowState(
        flowStatus: FlowStatus.inProgress,
        action: testAction,
        currentStepIndex: 2,
        stepStatuses: {0: StepStatus.success, 1: StepStatus.success},
        stepResults: {0: {}, 1: {}}, // Dummy results
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            verificationFlowProvider.overrideWith(() {
              final notifier = MockVerificationFlow();
              notifier.setInitialState(initialState);
              return notifier;
            }),
          ],
          child: MaterialApp(home: VerificationScreen(actionId: testActionId)),
        ),
      );

      await tester.pump(); // Initial build

      // Verify SpeechStepWidget is initially shown
      expect(find.byType(SpeechStepWidget), findsOneWidget);
      expect(find.byType(LocationStepWidget), findsNothing);
      expect(find.byType(SmileStepWidget), findsNothing);

      // --- Retrieve notifier from container ---
      final element = tester.element(find.byType(VerificationScreen));
      final container = ProviderScope.containerOf(element);
      final notifier =
          container.read(verificationFlowProvider.notifier)
              as MockVerificationFlow;
      // ---------------------------------------

      // Simulate successful completion of the speech step
      await tester.runAsync(() async {
        notifier.reportStepSuccess({'simulated': 'speech success'});
      });

      // Add a minimal delay
      await Future.delayed(Duration.zero);

      // Pump the widget tree to reflect the state change and settle
      await tester.pumpAndSettle();

      // Verify that no step widgets are shown anymore
      expect(find.byType(LocationStepWidget), findsNothing);
      expect(find.byType(SmileStepWidget), findsNothing);
      expect(find.byType(SpeechStepWidget), findsNothing);

      // Verify that the completion UI is shown
      expect(find.text('Verification Complete!'), findsOneWidget);

      // Verify the provider state updated correctly using the container
      final currentState = container.read(verificationFlowProvider);
      expect(currentState.flowStatus, FlowStatus.completed);
      expect(currentState.stepStatuses[0], StepStatus.success);
      expect(currentState.stepStatuses[1], StepStatus.success);
      expect(currentState.stepStatuses[2], StepStatus.success);
    });

    // Test 8: Step failure transitions flow to failed state
    testWidgets('step failure transitions to failed state', (tester) async {
      final locationStep = createDummyStep(
        1,
        'location',
        '{"latitude": 10.0, "longitude": 20.0, "radius": 100.0}',
      );
      final smileStep = createDummyStep(2, 'smile', '{}');
      final testAction = createDummyAction(testActionId, [
        locationStep,
        smileStep,
      ]);

      // Initial state: Location step is active
      final initialState = VerificationFlowState(
        flowStatus: FlowStatus.inProgress,
        action: testAction,
        currentStepIndex: 0,
        stepStatuses: {},
        stepResults: {},
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            verificationFlowProvider.overrideWith(() {
              final notifier = MockVerificationFlow();
              notifier.setInitialState(initialState);
              return notifier;
            }),
          ],
          child: MaterialApp(home: VerificationScreen(actionId: testActionId)),
        ),
      );

      await tester.pump(); // Initial build

      // Verify LocationStepWidget is initially shown
      expect(find.byType(LocationStepWidget), findsOneWidget);
      expect(find.byType(SmileStepWidget), findsNothing);

      // --- Retrieve notifier from container ---
      final element = tester.element(find.byType(VerificationScreen));
      final container = ProviderScope.containerOf(element);
      final notifier =
          container.read(verificationFlowProvider.notifier)
              as MockVerificationFlow;
      // ---------------------------------------

      // Simulate failure of the location step
      const failureMessage = 'Simulated location failure';
      await tester.runAsync(() async {
        notifier.reportStepFailure(failureMessage);
      });

      // Add a minimal delay
      await Future.delayed(Duration.zero);

      // Pump the widget tree to reflect the state change and settle
      await tester.pumpAndSettle();

      // Verify that no step widgets are shown anymore
      expect(find.byType(LocationStepWidget), findsNothing);
      expect(find.byType(SmileStepWidget), findsNothing);
      expect(find.byType(SpeechStepWidget), findsNothing);

      // Verify that the failure UI is shown
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Verification Failed'), findsOneWidget); // No colon
      expect(find.text(failureMessage), findsOneWidget);
      expect(
        find.widgetWithText(ElevatedButton, 'Try Again Later'),
        findsOneWidget,
      );

      // Verify the provider state updated correctly using the container
      final currentState = container.read(verificationFlowProvider);
      expect(currentState.flowStatus, FlowStatus.failed);
      expect(currentState.errorMessage, failureMessage);
    });

    // Test 9: Invalid step parameters transitions to failed state
    testWidgets(
      'handling invalid step parameters transitions to failed state',
      (tester) async {
        // Create an action, but we'll simulate the parameters were invalid
        final locationStep = createDummyStep(
          1,
          'location',
          'this is not valid json', // Invalid parameters
        );
        final testAction = createDummyAction(testActionId, [locationStep]);

        // Define the state as if initialization detected invalid parameters
        const errorMessage = 'Invalid parameters for step 1';
        final initialState = VerificationFlowState(
          flowStatus: FlowStatus.failed,
          action: testAction, // Include the action for context, even if failed
          currentStepIndex: 0,
          stepStatuses: {},
          stepResults: {},
          errorMessage: errorMessage,
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              verificationFlowProvider.overrideWith(() {
                final notifier = MockVerificationFlow();
                mockNotifierInstance = notifier;
                Future.microtask(() => notifier.setInitialState(initialState));
                return notifier;
              }),
            ],
            child: MaterialApp(
              home: VerificationScreen(actionId: testActionId),
            ),
          ),
        );

        await tester.pump(); // Reflect the overridden state

        // Verify that no step widgets are shown
        expect(find.byType(LocationStepWidget), findsNothing);
        expect(find.byType(SmileStepWidget), findsNothing);
        expect(find.byType(SpeechStepWidget), findsNothing);

        // Verify that the failure UI is shown with the specific error
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('Verification Failed'), findsOneWidget); // No colon
        expect(find.text(errorMessage), findsOneWidget);
        expect(
          find.widgetWithText(ElevatedButton, 'Try Again Later'),
          findsOneWidget,
        );

        // Verify the provider state matches the initial override
        // We need to get the container again to read the current state
        final container = ProviderScope.containerOf(
          tester.element(find.byType(VerificationScreen)),
        );
        final currentState = container.read(verificationFlowProvider);
        expect(currentState.flowStatus, FlowStatus.failed);
        expect(currentState.errorMessage, errorMessage);
      },
    );

    // Test 10: Shows permission denial UI when permission is denied (requires mocking)
    // TODO: Implement platform channel mocking for permission_handler to make this test pass.
    // testWidgets('shows permission denial UI', (tester) async {
    //   final locationStep = createDummyStep(
    //     1,
    //     'location',
    //     '{"latitude": 10.0, "longitude": 20.0, "radius": 100.0}',
    //   );
    //   final testAction = createDummyAction(testActionId, [locationStep]);

    //   // Initial state: Location step is active
    //   final initialState = VerificationFlowState(
    //     flowStatus: FlowStatus.inProgress,
    //     action: testAction,
    //     currentStepIndex: 0,
    //     stepStatuses: {},
    //     stepResults: {},
    //   );

    //   // --- MOCKING SETUP NEEDED HERE ---
    //   // Example (pseudo-code, requires actual mocking implementation):
    //   // TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
    //   //     .setMockMethodCallHandler(
    //   //   permissionHandlerChannel, // Channel for permission_handler
    //   //   (MethodCall methodCall) async {
    //   //     if (methodCall.method == 'requestPermissions' &&
    //   //         methodCall.arguments.contains(Permission.location.value)) {
    //   //       // Simulate denied status (integer value might vary)
    //   //       return {Permission.location.value: 1 /* denied */};
    //   //     }
    //   //     return null;
    //   //   },
    //   // );
    //   // --------------------------------

    //   await tester.pumpWidget(
    //     ProviderScope(
    //       overrides: [
    //         verificationFlowProvider.overrideWith(() {
    //           final notifier = MockVerificationFlow();
    //           mockNotifierInstance = notifier;
    //           Future.microtask(() => notifier.setInitialState(initialState));
    //           return notifier;
    //         }),
    //       ],
    //       child: MaterialApp(home: VerificationScreen(actionId: testActionId)),
    //     ),
    //   );

    //   // Pump potentially multiple times to allow widget to react to permission status
    //   await tester.pump();
    //   // await tester.pump(); // May need more pumps depending on implementation

    //   // Verify LocationStepWidget is present (it should be, asking for permission)
    //   expect(find.byType(LocationStepWidget), findsOneWidget);

    //   // Verify that the permission denial UI is shown within LocationStepWidget
    //   // NOTE: This assumes LocationStepWidget OR VerificationScreen shows this
    //   // NOTE 2: Without mocking, the specific permission denial UI might not be rendered.
    //   // These checks might fail until mocking is implemented.
    //   expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    //   expect(find.text('Permissions Required'), findsOneWidget);
    //   // We can't easily check the specific error message without triggering it
    //   // expect(find.textContaining('permissions denied'), findsOneWidget);
    //   expect(
    //     find.widgetWithText(ElevatedButton, 'Open App Settings'),
    //     findsOneWidget,
    //   );
    //   expect(find.widgetWithText(TextButton, 'Cancel'), findsOneWidget);

    //   // Optional: Verify the overall flow state hasn't changed unexpectedly
    //   final container = ProviderScope.containerOf(
    //     tester.element(find.byType(VerificationScreen)),
    //   );
    //   final currentState = container.read(verificationFlowProvider);
    //   expect(
    //     currentState.flowStatus,
    //     FlowStatus.inProgress,
    //   ); // Should still be in progress
    //   expect(currentState.currentStepIndex, 0);
    // });

    // TODO: Implement actual permission mocking for Test 10
  });
}
