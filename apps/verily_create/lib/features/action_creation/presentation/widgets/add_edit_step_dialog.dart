import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verily_client/verily_client.dart' as protocol;
import 'package:verily_create/main.dart'; // Import client
// Import provider
import 'dart:convert'; // For JSON validation

// Dialog widget for adding/editing an action step
class AddEditStepDialog extends ConsumerStatefulWidget {
  final int actionId;
  final protocol.ActionStep? existingStep; // ADDED for editing

  const AddEditStepDialog({
    required this.actionId,
    this.existingStep,
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

  // Determine if we are editing based on the presence of existingStep
  bool get _isEditing => widget.existingStep != null;

  @override
  void initState() {
    super.initState();
    // Initialize fields if editing existingStep
    if (_isEditing) {
      _typeController.text = widget.existingStep!.type;
      _paramsController.text = widget.existingStep!.parameters;
      _orderController.text = widget.existingStep!.order.toString();
      _instructionController.text = widget.existingStep!.instruction ?? '';
    }
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

      // Validate JSON parameters
      try {
        jsonDecode(parameters); // Try parsing
      } catch (e) {
        _showErrorSnackbar('Parameters field must contain valid JSON.');
        setState(() => _isLoading = false);
        return;
      }

      // Create or Update the ActionStep object
      final stepData = protocol.ActionStep(
        id:
            _isEditing
                ? widget.existingStep!.id
                : null, // Include ID if editing
        actionId: widget.actionId,
        type: type,
        parameters: parameters,
        order: order,
        instruction: instruction.isNotEmpty ? instruction : null,
        // Timestamps will be handled by the server
        createdAt:
            _isEditing
                ? widget.existingStep!.createdAt
                : DateTime.now(), // Keep original or dummy
        updatedAt: DateTime.now(), // Server will overwrite
      );

      try {
        protocol.ActionStep? resultStep;
        if (_isEditing) {
          // Call updateActionStep if editing
          resultStep = await client.action.updateActionStep(stepData);
        } else {
          // Call addActionStep if creating
          resultStep = await client.action.addActionStep(stepData);
        }

        if (resultStep != null) {
          // Invalidate provider is handled by the calling page (EditActionPage)
          // ref.invalidate(actionDetailsProvider(widget.actionId));
          Navigator.of(context).pop(true); // Pop dialog, indicate success
        } else {
          _showErrorSnackbar(
            'Failed to ${_isEditing ? 'update' : 'add'} step. Server returned null.',
          );
          if (mounted) setState(() => _isLoading = false);
        }
      } catch (e) {
        print('Error ${_isEditing ? 'updating' : 'adding'} step: $e');
        _showErrorSnackbar(
          'Error ${_isEditing ? 'updating' : 'adding'} step: ${e.toString()}',
        );
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackbar(String message) {
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
      title: Text(
        _isEditing ? 'Edit Action Step' : 'Add Action Step',
      ), // Dynamic title
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
                  hintText: '{"key": "value"}',
                ),
                maxLines: 3,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Parameters are required';
                  }
                  try {
                    jsonDecode(v); // Basic JSON format check
                    return null;
                  } catch (e) {
                    return 'Invalid JSON format';
                  }
                },
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
          onPressed:
              _isLoading
                  ? null
                  : () => Navigator.of(
                    context,
                  ).pop(false), // Indicate no save on cancel
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
                  : Text(
                    _isEditing ? 'Update Step' : 'Save Step',
                  ), // Dynamic button text
        ),
      ],
    );
  }
}
