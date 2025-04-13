import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:verily_client/verily_client.dart' as protocol;
import 'package:verily_create/features/action_creation/presentation/pages/create_action_page.dart'; // Import provider for locations
import 'package:verily_create/main.dart'; // Import client
import 'package:verily_create/features/action_creation/presentation/widgets/add_edit_step_dialog.dart';

// Provider to fetch details for a specific action
// Using family modifier to pass the actionId
final actionDetailsProvider = FutureProvider.family<protocol.Action?, int>((
  ref,
  actionId,
) async {
  try {
    // Access the globally initialized client
    return await client.action.getActionDetails(actionId);
  } catch (e) {
    print('Error fetching action details for $actionId: $e');
    rethrow; // Let the provider handle the error state
  }
});

/// A page for viewing and editing an existing Verily Action and its steps.
class EditActionPage extends ConsumerStatefulWidget {
  final int actionId;
  const EditActionPage({required this.actionId, super.key});

  @override
  ConsumerState<EditActionPage> createState() => _EditActionPageState();
}

class _EditActionPageState extends ConsumerState<EditActionPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _maxCompletionTimeController = TextEditingController();

  int? _selectedLocationId;
  DateTime? _validFrom;
  DateTime? _validUntil;
  bool _isStrictOrder = true;
  bool _isLoading = false; // For the main action update
  bool _isInitialized = false; // To track if controllers are initialized

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _maxCompletionTimeController.dispose();
    super.dispose();
  }

  /// Initializes form controllers and state from the fetched action data.
  /// Ensures this only runs once when data is first available.
  void _initializeFields(protocol.Action action) {
    if (!_isInitialized) {
      _nameController.text = action.name;
      _descriptionController.text = action.description ?? '';
      _maxCompletionTimeController.text =
          action.maxCompletionTimeSeconds?.toString() ?? '';
      _selectedLocationId = action.locationId;
      _validFrom = action.validFrom?.toLocal(); // Convert from UTC for picker
      _validUntil = action.validUntil?.toLocal(); // Convert from UTC for picker
      _isStrictOrder = action.strictOrder;
      _isInitialized = true;
    }
  }

  // Method to show the Add/Edit Step Dialog
  Future<void> _showAddEditStepDialog({protocol.ActionStep? step}) async {
    // Show the dialog and wait for it to potentially return a boolean (true if saved)
    final bool? didSave = await showDialog<bool>(
      context: context,
      builder:
          (context) => AddEditStepDialog(
            actionId: widget.actionId,
            existingStep: step, // Pass existing step for editing
          ),
    );

    // If the dialog indicated a save occurred, refresh the action details
    if (didSave == true) {
      ref.invalidate(actionDetailsProvider(widget.actionId));
    }
  }

  // Method to handle deleting a step
  Future<void> _deleteStep(protocol.ActionStep step) async {
    // Confirm deletion
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Step?'),
            content: Text(
              'Are you sure you want to delete Step ${step.order} (${step.type})? This cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // Cancel
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // Confirm
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirmDelete == true && step.id != null) {
      // Show loading indicator overlay
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
      try {
        final success = await client.action.deleteActionStep(step.id!);
        Navigator.of(context).pop(); // Dismiss loading indicator

        if (success) {
          ref.invalidate(actionDetailsProvider(widget.actionId));
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Step ${step.order} deleted.'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          if (mounted) {
            _showErrorSnackbar(
              'Failed to delete step. Action not found or not owner?',
            );
          }
        }
      } catch (e) {
        Navigator.of(context).pop(); // Dismiss loading indicator on error
        print('Error deleting step ${step.id}: $e');
        if (mounted) {
          _showErrorSnackbar('Error deleting step: ${e.toString()}');
        }
      }
    }
  }

  // --- Helper Methods ---
  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
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

  // --- Update Action Logic ---
  Future<void> _updateActionDetails() async {
    if (_isLoading) return;
    if (_formKey.currentState!.validate()) {
      // Ensure location consistency check (similar to create page)
      final availableLocations =
          ref.read(availableLocationsProvider).valueOrNull ?? [];
      if (availableLocations.isNotEmpty &&
          _selectedLocationId == null &&
          ref.read(actionDetailsProvider(widget.actionId)).value?.locationId !=
              null) {
        // This condition is tricky: if locations are available, and one *was* set previously, but now it's null
        // For now, let's allow unsetting. If a location MUST be selected if available, adjust this.
        // Alternatively, fetch locations *before* initializing fields to make the logic simpler.
      }

      // Date validation
      if (_validFrom != null &&
          _validUntil != null &&
          _validUntil!.isBefore(_validFrom!)) {
        _showErrorSnackbar(
          '"Valid Until" date cannot be before "Valid From" date.',
        );
        return;
      }

      setState(() => _isLoading = true);

      // Get the original action ID - IMPORTANT!
      final originalActionId =
          ref.read(actionDetailsProvider(widget.actionId)).value?.id;
      if (originalActionId == null) {
        _showErrorSnackbar(
          'Cannot update action: Original action ID not found.',
        );
        setState(() => _isLoading = false);
        return;
      }

      // Construct the updated Action object
      final updatedActionData = protocol.Action(
        id: originalActionId, // MUST include the ID for update
        userInfoId:
            ref
                .read(actionDetailsProvider(widget.actionId))
                .value!
                .userInfoId, // Preserve original owner
        name: _nameController.text,
        description: _descriptionController.text,
        locationId: _selectedLocationId,
        validFrom: _validFrom?.toUtc(), // Convert back to UTC for server
        validUntil: _validUntil?.toUtc(), // Convert back to UTC for server
        maxCompletionTimeSeconds: int.tryParse(
          _maxCompletionTimeController.text,
        ),
        strictOrder: _isStrictOrder,
        createdAt:
            ref
                .read(actionDetailsProvider(widget.actionId))
                .value!
                .createdAt, // Preserve original creation time
        updatedAt:
            DateTime.now()
                .toUtc(), // Serverpod ORM handles this, but good practice
        isDeleted:
            ref
                .read(actionDetailsProvider(widget.actionId))
                .value!
                .isDeleted, // Preserve delete status
        // Steps and Webhooks are not updated here
        steps: null,
        webhooks: null,
      );

      try {
        final result = await client.action.updateAction(updatedActionData);
        if (result != null) {
          ref.invalidate(
            actionDetailsProvider(widget.actionId),
          ); // Refresh details
          ref.invalidate(
            myActionsProvider,
          ); // Refresh list view if user goes back
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Action details updated!')),
            );
          }
        } else {
          _showErrorSnackbar(
            'Failed to update action details. Server returned null or update failed.',
          );
        }
      } catch (e) {
        print('Error updating action: $e');
        _showErrorSnackbar('Error updating action: ${e.toString()}');
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final actionDetailsAsync = ref.watch(
      actionDetailsProvider(widget.actionId),
    );
    final locationsAsyncValue = ref.watch(
      availableLocationsProvider,
    ); // Watch locations too
    final dateFormat = DateFormat.yMd(); // Date formatter

    return Scaffold(
      appBar: AppBar(
        title: actionDetailsAsync.when(
          data: (action) => Text(action?.name ?? 'Edit Action'),
          loading: () => const Text('Loading Action...'),
          error: (_, __) => const Text('Error Loading Action'),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/actions'),
        ),
        actions: [
          // Add Save button
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed:
                  _isLoading || !actionDetailsAsync.hasValue
                      ? null
                      : _updateActionDetails,
              child:
                  _isLoading
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Text('Update'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: actionDetailsAsync.when(
            data: (action) {
              if (action == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Action not found or access denied.'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.go('/actions'),
                        child: const Text('Return to Action List'),
                      ),
                    ],
                  ),
                );
              }
              // Initialize fields ONCE when data is loaded
              _initializeFields(action);
              // Pass action and location data to the build method
              return _buildEditForm(context, action, locationsAsyncValue);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error:
                (error, stackTrace) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error fetching action details: $error',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.go('/actions'),
                        child: const Text('Return to Action List'),
                      ),
                    ],
                  ),
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditForm(
    BuildContext context,
    protocol.Action action,
    AsyncValue<List<protocol.Location>> locationsAsyncValue,
  ) {
    final steps = action.steps ?? [];
    final dateFormat = DateFormat.yMd();

    return Form(
      key: _formKey, // Assign the key to the Form
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Action Details (Now Editable) ---
          Text('Action Details', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Action Name',
              border: OutlineInputBorder(),
            ),
            validator:
                (v) => v == null || v.isEmpty ? 'Name is required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            validator:
                (v) =>
                    v == null || v.isEmpty ? 'Description is required' : null,
          ),
          const SizedBox(height: 16),

          // Location Dropdown (using logic from CreateActionPage)
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
              // Ensure selected value exists in the list, otherwise set to null
              // This handles cases where the previously saved location might have been deleted
              final validSelectedId =
                  locations.any((loc) => loc.id == _selectedLocationId)
                      ? _selectedLocationId
                      : null;
              if (validSelectedId != _selectedLocationId) {
                // If the selection became invalid, update the state post-build
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    // Check mount status again in post-frame callback
                    setState(() {
                      _selectedLocationId = null;
                    });
                  }
                });
              }

              return DropdownButtonFormField<int?>(
                value: validSelectedId, // Use the validated ID
                decoration: const InputDecoration(
                  labelText: 'Location (Optional)',
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Select a location'),
                items:
                    locations.map((location) {
                      final displayText =
                          location.address?.isNotEmpty ?? false
                              ? location.address!
                              : 'Lat: ${location.latitude.toStringAsFixed(4)}, Lng: ${location.longitude.toStringAsFixed(4)} (ID: ${location.id})';
                      return DropdownMenuItem<int?>(
                        value: location.id,
                        child: Text(
                          displayText,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLocationId = value;
                  });
                },
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

          // Valid From / Until Date Pickers
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

          // Strict Order Switch
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
          const Divider(height: 32),

          // --- Action Steps Section ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Steps', style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                tooltip: 'Add Step',
                onPressed: () => _showAddEditStepDialog(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          steps.isEmpty
              ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: const Center(
                  child: Text(
                    'No steps added yet. Click + to add one.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
              : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: steps.length,
                itemBuilder: (context, index) {
                  final step = steps[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${step.order}')),
                      title: Text('Type: ${step.type}'),
                      subtitle: Text('Params: ${step.parameters}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            tooltip: 'Edit Step ${step.order}',
                            onPressed: () => _showAddEditStepDialog(step: step),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: Colors.redAccent,
                            ),
                            tooltip: 'Delete Step ${step.order}',
                            onPressed: () => _deleteStep(step),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        ],
      ),
    );
  }
}
