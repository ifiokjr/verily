import 'dart:convert'; // Import for jsonEncode

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verily_client/verily_client.dart' as vc;

// Define dummy actions and steps
final _now = DateTime.now();

// --- Dummy Steps - Using correct fields: type, parameters (as JSON String) ---
final _dummyStep1_1 = vc.ActionStep(
  id: 1,
  actionId: 1,
  order: 1,
  type: 'location',
  parameters: jsonEncode({
    // Encode parameters map to JSON string
    'latitude': 34.0522,
    'longitude': -118.2437,
    'radius': 50.0,
  }),
  createdAt: _now,
  updatedAt: _now,
);
final _dummyStep1_2 = vc.ActionStep(
  id: 2,
  actionId: 1,
  order: 2,
  type: 'smile',
  parameters: jsonEncode({}), // Encode empty map
  createdAt: _now,
  updatedAt: _now,
);
final _dummyStep2_1 = vc.ActionStep(
  id: 3,
  actionId: 2,
  order: 1,
  type: 'location',
  parameters: jsonEncode({
    // Encode parameters map to JSON string
    'latitude': 37.7749,
    'longitude': -122.4194,
    'radius': 100.0,
  }),
  createdAt: _now,
  updatedAt: _now,
);
final _dummyStep3_1 = vc.ActionStep(
  id: 4,
  actionId: 3,
  order: 1,
  type: 'speech',
  parameters: jsonEncode({
    'phrase': 'Encode is amazing!',
  }), // Encode parameters map
  createdAt: _now,
  updatedAt: _now,
);
final _dummyStep4_1 = vc.ActionStep(
  id: 5,
  actionId: 4,
  order: 1,
  type: 'location',
  parameters: jsonEncode({
    // Encode parameters map to JSON string
    'latitude': 40.7128,
    'longitude': -74.0060,
    'radius': 30.0,
  }),
  createdAt: _now,
  updatedAt: _now,
);

// Combine all dummy steps into a map for easy lookup by actionId
final _allDummySteps = <int, List<vc.ActionStep>>{
  1: [_dummyStep1_1, _dummyStep1_2],
  2: [_dummyStep2_1],
  3: [_dummyStep3_1],
  4: [_dummyStep4_1],
};

// --- Dummy Actions (without steps in constructor) ---
final _dummyAction1 = vc.Action(
  id: 1,
  userInfoId: 1,
  name: 'Morning Check-in',
  description: 'Verify your location and smile.',
  createdAt: _now,
  updatedAt: _now,
);
final _dummyAction2 = vc.Action(
  id: 2,
  userInfoId: 1,
  name: 'Local Coffee Shop',
  description: 'Visit the nearby coffee shop.',
  createdAt: _now,
  updatedAt: _now,
);
final _dummyAction3 = vc.Action(
  id: 3,
  userInfoId: 1,
  name: 'Daily Affirmation',
  description: 'Say \'Encode is amazing!\'',
  createdAt: _now,
  updatedAt: _now,
);
final _dummyAction4 = vc.Action(
  id: 4,
  userInfoId: 1,
  name: 'Evening Wind Down',
  description: 'Confirm you are home.',
  createdAt: _now,
  updatedAt: _now,
);

// Combine all dummy actions into a list for easier lookup
final _allDummyActions = [
  _dummyAction1,
  _dummyAction2,
  _dummyAction3,
  _dummyAction4,
];

/// Provider for available actions (dummy data).
final availableActionsProvider = Provider<List<vc.Action>>((ref) {
  return [_dummyAction1, _dummyAction3];
});

/// Provider for accepted actions (dummy data).
final acceptedActionsProvider = Provider<List<vc.Action>>((ref) {
  return [_dummyAction4];
});

/// Provider for local actions (dummy data).
final localActionsProvider = Provider<List<vc.Action>>((ref) {
  return [_dummyAction2];
});

/// Provider to get a specific action by its ID (from dummy data).
/// Also attaches the corresponding steps.
final actionDetailProvider = Provider.family<vc.Action?, int>((ref, actionId) {
  try {
    // Find the action in the dummy list.
    final action = _allDummyActions.firstWhere((a) => a.id == actionId);

    // Find the corresponding steps from the dummy steps map.
    final steps = _allDummySteps[actionId] ?? [];

    // Create a new Action instance with steps attached.
    // IMPORTANT: This assumes the generated Action class has a `copyWith` method
    // and a settable `steps` field, OR that you are okay modifying the original
    // dummy instance (less safe). Using copyWith is preferred.
    // If `copyWith` is not available or `steps` is not settable, this approach
    // needs adjustment (e.g., return a custom class combining Action and Steps).
    return action.copyWith(steps: steps); // Assuming copyWith exists
  } catch (e) {
    print('Error finding action with ID $actionId: $e');
    return null;
  }
});
