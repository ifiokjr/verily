import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitAction() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with action creation
      final name = _nameController.text;
      final description = _descriptionController.text;

      // TODO: Call Riverpod provider/repository to save the action
      // e.g., ref.read(actionRepositoryProvider).createAction(name: name, description: description);

      print('Action Name: $name');
      print('Action Description: $description');

      // Navigate back or show success message
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
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
              onPressed: _submitAction,
              child: const Text('Save'),
              // Applying Apple HIG: Text button for confirmation actions in nav bar.
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
                    onPressed: _submitAction,
                    child: const Text('Save Action'),
                    // Applying Apple HIG: Primary button for main form submission.
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
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
