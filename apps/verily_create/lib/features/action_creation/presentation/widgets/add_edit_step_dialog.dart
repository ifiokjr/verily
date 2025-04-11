import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verily_client/verily_client.dart' as protocol;
import 'package:verily_create/main.dart'; // Import client
import 'package:verily_create/features/action_creation/presentation/pages/edit_action_page.dart'; // Import provider

// Dialog widget for adding/editing an action step
class AddEditStepDialog extends ConsumerStatefulWidget {
  final int actionId;
  // final protocol.ActionStep? existingStep; // TODO: Add for editing

  const AddEditStepDialog({
    required this.actionId,
    // this.existingStep,
    super.key,
  });

  @override
  ConsumerState<AddEditStepDialog> createState() => _AddEditStepDialogState();
}

class _AddEditStepDialogState extends ConsumerState<AddEditStepDialog> {
  final _formKey = GlobalKey<FormState>();
  final _typeController = TextEditingController();
  final _paramsController = TextEditingController();
  final _orderController = TextEditingController();
  final _instructionController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // TODO: Initialize fields if editing existingStep
  }

  @override
  void dispose() {
    _typeController.dispose();
    _paramsController.dispose();
    _orderController.dispose();
    _instructionController.dispose();
    super.dispose();
  }

  Future<void> _saveStep() async {
    if (_isLoading) return;
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final type = _typeController.text;
      final parameters = _paramsController.text;
      final order = int.tryParse(_orderController.text);
      final instruction = _instructionController.text;

      if (order == null) {
        _showErrorSnackbar('Order must be a valid number.');
        setState(() => _isLoading = false);
        return;
      }

      // Create the new ActionStep object
      final newStep = protocol.ActionStep(
        actionId: widget.actionId,
        type: type,
        parameters: parameters,
        order: order,
        instruction: instruction.isNotEmpty ? instruction : null,
        // createdAt/updatedAt are set by the server endpoint
        createdAt: DateTime.now(), // Dummy value, server will overwrite
        updatedAt: DateTime.now(), // Dummy value, server will overwrite
      );

      try {
        // TODO: Call updateActionStep if editing
        final createdStep = await client.action.addActionStep(newStep);

        if (createdStep != null) {
          ref.invalidate(
            actionDetailsProvider(widget.actionId),
          ); // Refresh details
          Navigator.of(context).pop(true); // Pop dialog, indicate success
        } else {
          _showErrorSnackbar('Failed to add step. Server returned null.');
          if (mounted) setState(() => _isLoading = false);
        }
      } catch (e) {
        print('Error adding step: $e');
        _showErrorSnackbar('Error adding step: ${e.toString()}');
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackbar(String message) {
    // Check if the widget is still in the tree
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Action Step'), // TODO: Change title for editing
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(
                  labelText: 'Step Type',
                  hintText: 'e.g., location, face_detection',
                ),
                validator:
                    (v) => v == null || v.isEmpty ? 'Type is required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _orderController,
                decoration: const InputDecoration(
                  labelText: 'Order',
                  hintText: 'Execution sequence number',
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Order is required';
                  if (int.tryParse(v) == null) return 'Must be a number';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _paramsController,
                decoration: const InputDecoration(
                  labelText: 'Parameters (JSON)',
                  hintText: '{\"key\": \"value\"}',
                ),
                maxLines: 3,
                validator:
                    (v) =>
                        v == null || v.isEmpty
                            ? 'Parameters are required'
                            : null,
                // TODO: Add JSON validation?
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _instructionController,
                decoration: const InputDecoration(
                  labelText: 'User Instruction (Optional)',
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveStep,
          child:
              _isLoading
                  ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : const Text('Save Step'), // TODO: Change text for editing
        ),
      ],
    );
  }
}
