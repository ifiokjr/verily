import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verily_client/verily_client.dart' as vc;

// Define dummy actions and steps
final _now = DateTime.now();

// --- Dummy Steps - Assuming ActionStep has stepType and details fields ---
final _dummyStep1_1 = vc.ActionStep(
  id: 1,
  actionId: 1,
  order: 1,
  stepType: 'location', // Assumed field
  details: {
    'latitude': 34.0522,
    'longitude': -118.2437,
    'radius': 50.0,
  }, // Assumed field
  createdAt: _now,
  updatedAt: _now,
);
final _dummyStep1_2 = vc.ActionStep(
  id: 2,
  actionId: 1,
  order: 2,
  stepType: 'smile', // Assumed field
  details: {}, // Assumed field
  createdAt: _now,
  updatedAt: _now,
);
final _dummyStep2_1 = vc.ActionStep(
  id: 3,
  actionId: 2,
  order: 1,
  stepType: 'location', // Assumed field
  details: {
    'latitude': 37.7749,
    'longitude': -122.4194,
    'radius': 100.0,
  }, // Assumed field
  createdAt: _now,
  updatedAt: _now,
);
final _dummyStep3_1 = vc.ActionStep(
  id: 4,
  actionId: 3,
  order: 1,
  stepType: 'speech', // Assumed field
  details: {'phrase': 'Solana is amazing!'}, // Assumed field
  createdAt: _now,
  updatedAt: _now,
);
final _dummyStep4_1 = vc.ActionStep(
  id: 5,
  actionId: 4,
  order: 1,
  stepType: 'location', // Assumed field
  details: {
    'latitude': 40.7128,
    'longitude': -74.0060,
    'radius': 30.0,
  }, // Assumed field
  createdAt: _now,
  updatedAt: _now,
);

// --- Dummy Actions (with steps) - Assuming Action has a List<ActionStep>? steps field ---
final _dummyAction1 = vc.Action(
  id: 1,
  userInfoId: 1,
  name: 'Morning Check-in',
  description: 'Verify your location and smile.',
  steps: [_dummyStep1_1, _dummyStep1_2], // Assumed field
  createdAt: _now,
  updatedAt: _now,
);
final _dummyAction2 = vc.Action(
  id: 2,
  userInfoId: 1,
  name: 'Local Coffee Shop',
  description: 'Visit the nearby coffee shop.',
  steps: [_dummyStep2_1], // Assumed field
  createdAt: _now,
  updatedAt: _now,
);
final _dummyAction3 = vc.Action(
  id: 3,
  userInfoId: 1,
  name: 'Daily Affirmation',
  description: 'Say \'Solana is amazing!\'',
  steps: [_dummyStep3_1], // Assumed field
  createdAt: _now,
  updatedAt: _now,
);
final _dummyAction4 = vc.Action(
  id: 4,
  userInfoId: 1,
  name: 'Evening Wind Down',
  description: 'Confirm you are home.',
  steps: [_dummyStep4_1], // Assumed field
  createdAt: _now,
  updatedAt: _now,
);

// Combine all dummy actions into a single list for easier lookup
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
final actionDetailProvider = Provider.family<vc.Action?, int>((ref, actionId) {
  try {
    return _allDummyActions.firstWhere((action) => action.id == actionId);
  } catch (e) {
    print('Error finding action with ID $actionId: $e');
    return null;
  }
});
