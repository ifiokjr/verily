import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:verily_client/verily_client.dart'
    as protocol; // Import client models
import 'package:verily_create/main.dart'; // Import client

// Provider to fetch the user's actions
final myActionsProvider = FutureProvider<List<protocol.Action>>((ref) async {
  try {
    return await client.action.getMyActions();
  } catch (e) {
    print('Error fetching actions: $e');
    rethrow;
  }
});

// Provider to fetch available locations
final availableLocationsProvider = FutureProvider<List<protocol.Location>>((
  ref,
) async {
  try {
    // Use the generated client to fetch locations
    return await client.location.getAvailableLocations();
  } catch (e) {
    print('Error fetching available locations: $e');
    // Return empty list on error or rethrow based on desired UI behavior
    return [];
  }
});

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
  final _maxCompletionTimeController = TextEditingController();

  DateTime? _validFrom;
  DateTime? _validUntil;
  bool _isStrictOrder = true;
  bool _isLoading = false;
  int? _selectedLocationId;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
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
      final availableLocations =
          ref.read(availableLocationsProvider).valueOrNull ?? [];
      if (availableLocations.isNotEmpty && _selectedLocationId == null) {
        _showErrorSnackbar('Please select a location.');
        return;
      }

      setState(() => _isLoading = true);

      final name = _nameController.text;
      final description = _descriptionController.text;
      final int? locationId = _selectedLocationId;
      final int? maxCompletionTimeSeconds = int.tryParse(
        _maxCompletionTimeController.text,
      );

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
          validFrom: _validFrom,
          validUntil: _validUntil,
          maxCompletionTimeSeconds: maxCompletionTimeSeconds,
          strictOrder: _isStrictOrder,
        );

        if (newAction != null && newAction.id != null) {
          ref.invalidate(myActionsProvider);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Action "${newAction.name}" created!')),
            );
            context.go('/actions/${newAction.id}/edit');
          }
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
    final dateFormat = DateFormat.yMd();
    final locationsAsyncValue = ref.watch(availableLocationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Action'),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to Actions',
          onPressed: () => context.go('/actions'),
        ),
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

                Text(
                  'Optional Settings',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),

                locationsAsyncValue.when(
                  data: (locations) {
                    if (locations.isEmpty) {
                      return const InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Location (Optional)',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                        ),
                        child: Text(
                          'No locations available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                    return DropdownButtonFormField<int?>(
                      value: _selectedLocationId,
                      decoration: const InputDecoration(
                        labelText: 'Location (Optional)',
                        border: OutlineInputBorder(),
                      ),
                      hint: const Text('Select a location'),
                      items:
                          locations.map((location) {
                            // Use address field for display, provide fallback if null
                            final displayText =
                                location.address?.isNotEmpty ?? false
                                    ? location.address!
                                    : 'Lat: ${location.latitude.toStringAsFixed(4)}, Lng: ${location.longitude.toStringAsFixed(4)} (ID: ${location.id})';
                            return DropdownMenuItem<int?>(
                              value: location.id,
                              child: Text(
                                displayText,
                                overflow:
                                    TextOverflow
                                        .ellipsis, // Prevent long addresses from breaking layout
                              ),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedLocationId = value;
                        });
                      },
                      // Validator is handled in _submitAction
                    );
                  },
                  loading:
                      () => const Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 16),
                          Text('Loading locations...'),
                        ],
                      ),
                  error:
                      (err, stack) => InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Location (Optional)',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                        ),
                        child: Text(
                          'Error loading locations',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                ),
                const SizedBox(height: 16),

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

                TextFormField(
                  controller: _maxCompletionTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Max Completion Time (Seconds, Optional)',
                    hintText: 'e.g., 300 (for 5 minutes)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return 'Please enter a positive number of seconds';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

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
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
