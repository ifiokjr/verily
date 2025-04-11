import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verily_create/features/action_creation/presentation/pages/action_list_page.dart'; // Import provider
import 'package:verily_create/main.dart'; // Import client

/// A page for creating a new Verily Action.
class CreateActionPage extends ConsumerStatefulWidget {
  const CreateActionPage({super.key});

  @override
  ConsumerState<CreateActionPage> createState() => _CreateActionPageState();
}

class _CreateActionPageState extends ConsumerState<CreateActionPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false; // State to handle loading during submission

  // TODO: Add controllers/state for location, time constraints, strictOrder

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    // TODO: Dispose other controllers
    super.dispose();
  }

  Future<void> _submitAction() async {
    if (_isLoading) return; // Prevent double submission
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Form is valid, collect data
      final name = _nameController.text;
      final description = _descriptionController.text;
      // TODO: Get values from other form fields (locationId, etc.)
      final int? locationId = null;
      final DateTime? validFrom = null;
      final DateTime? validUntil = null;
      final int? maxCompletionTimeSeconds = null;
      final bool strictOrder = true; // Default for now

      try {
        // Call Serverpod endpoint via client
        final newAction = await client.action.createAction(
          name: name,
          description: description,
          locationId: locationId,
          validFrom: validFrom,
          validUntil: validUntil,
          maxCompletionTimeSeconds: maxCompletionTimeSeconds,
          strictOrder: strictOrder,
        );

        if (newAction != null) {
          // Success!
          ref.invalidate(myActionsProvider); // Refresh the action list
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Action "${newAction.name}" created!')),
          );
          if (Navigator.canPop(context)) {
            Navigator.pop(context); // Go back to the list
          }
        } else {
          // Handle unexpected null response from createAction
          _showErrorSnackbar(
            'Failed to create action. Server returned unexpected response.',
          );
        }
      } catch (e) {
        // Handle errors (e.g., network, server-side validation)
        print('Error creating action: $e');
        _showErrorSnackbar('Error creating action: ${e.toString()}');
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Action'),
        // Applying Apple HIG: Clear title, consistent back navigation.
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              // Disable button while loading
              onPressed: _isLoading ? null : _submitAction,
              child:
                  _isLoading
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Text('Save'),
            ),
          ),
        ],
      ),
      // Applying Apple HIG: Use Form for input grouping, clear labels, padding.
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Action Details',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Action Name',
                    hintText: 'e.g., Verify Office Check-in',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name for the action';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Describe what this action verifies',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // --- Placeholder for adding Action Steps ---
                Text(
                  'Action Steps',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: const Center(
                    child: Text(
                      'Adding action steps will be implemented here.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                // --- End Placeholder ---
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    // Disable button while loading
                    onPressed: _isLoading ? null : _submitAction,
                    // Applying Apple HIG: Primary button for main form submission.
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child:
                        _isLoading
                            ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                            : const Text('Save Action'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
