import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:verily_create/features/action_creation/presentation/pages/action_list_page.dart'; // Import provider
import 'package:verily_create/main.dart'; // Import client
import 'package:verily_create/features/action_creation/presentation/pages/edit_action_page.dart'; // Import new edit page

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
  final _locationIdController = TextEditingController(); // Placeholder
  final _maxCompletionTimeController = TextEditingController();

  DateTime? _validFrom;
  DateTime? _validUntil;
  bool _isStrictOrder = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationIdController.dispose();
    _maxCompletionTimeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (isFromDate ? _validFrom : _validUntil) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _validFrom = picked;
        } else {
          _validUntil = picked;
        }
      });
    }
  }

  Future<void> _submitAction() async {
    if (_isLoading) return;
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final name = _nameController.text;
      final description = _descriptionController.text;
      final int? locationId = int.tryParse(_locationIdController.text);
      final int? maxCompletionTimeSeconds = int.tryParse(
        _maxCompletionTimeController.text,
      );

      // Basic validation for dates
      if (_validFrom != null &&
          _validUntil != null &&
          _validUntil!.isBefore(_validFrom!)) {
        _showErrorSnackbar(
          '"Valid Until" date cannot be before "Valid From" date.',
        );
        setState(() => _isLoading = false);
        return;
      }

      try {
        final newAction = await client.action.createAction(
          name: name,
          description: description,
          locationId: locationId,
          validFrom: _validFrom, // Already DateTime?
          validUntil: _validUntil, // Already DateTime?
          maxCompletionTimeSeconds: maxCompletionTimeSeconds,
          strictOrder: _isStrictOrder,
        );

        if (newAction != null && newAction.id != null) {
          ref.invalidate(myActionsProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Action "${newAction.name}" created!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => EditActionPage(actionId: newAction.id!),
            ),
          );
        } else {
          _showErrorSnackbar(
            'Failed to create action. Server returned unexpected response or null ID.',
          );
        }
      } catch (e) {
        print('Error creating action: $e');
        _showErrorSnackbar('Error creating action: ${e.toString()}');
      } finally {
        if (mounted && _isLoading) {
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
    final dateFormat = DateFormat.yMd(); // Date formatter

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Action'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // --- Action Details Section ---
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
                    if (value == null || value.isEmpty)
                      return 'Please enter a name';
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
                    if (value == null || value.isEmpty)
                      return 'Please enter a description';
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // --- Optional Settings Section ---
                Text(
                  'Optional Settings',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                // Location (Placeholder)
                TextFormField(
                  controller: _locationIdController,
                  decoration: const InputDecoration(
                    labelText: 'Location ID (Optional)',
                    hintText: 'Enter numeric ID of a pre-defined location',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  // No validator needed as it's optional, parsed with tryParse
                ),
                const SizedBox(height: 16),
                // Valid From / Until
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context, true),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Valid From (Optional)',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            _validFrom == null
                                ? 'Not Set'
                                : dateFormat.format(_validFrom!),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context, false),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Valid Until (Optional)',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            _validUntil == null
                                ? 'Not Set'
                                : dateFormat.format(_validUntil!),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Max Completion Time
                TextFormField(
                  controller: _maxCompletionTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Max Completion Time (seconds, Optional)',
                    hintText: 'e.g., 300 for 5 minutes',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        int.tryParse(value) == null) {
                      return 'Please enter a valid number of seconds';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                // Strict Order
                SwitchListTile(
                  title: const Text('Enforce Strict Step Order'),
                  subtitle: const Text(
                    'If enabled, steps must be completed sequentially.',
                  ),
                  value: _isStrictOrder,
                  onChanged: (bool value) {
                    setState(() {
                      _isStrictOrder = value;
                    });
                  },
                  contentPadding:
                      EdgeInsets.zero, // Use ListTile default padding
                ),
                const SizedBox(height: 24),

                // --- Action Steps Section (Placeholder) ---
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
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitAction,
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
