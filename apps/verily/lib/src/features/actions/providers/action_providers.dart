import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verily_client/verily_client.dart' as vc;

// Define dummy actions
final _now = DateTime.now();
final _dummyAction1 = vc.Action(
  id: 1,
  userInfoId: 1, // Dummy user ID
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
  description: 'Say \'Solana is amazing!\'',
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

/// Provider for available actions (dummy data).
final availableActionsProvider = Provider<List<vc.Action>>((ref) {
  // Simulate fetching available actions
  return [_dummyAction1, _dummyAction3];
});

/// Provider for accepted actions (dummy data).
final acceptedActionsProvider = Provider<List<vc.Action>>((ref) {
  // Simulate fetching accepted actions
  return [_dummyAction4];
});

/// Provider for local actions (dummy data).
final localActionsProvider = Provider<List<vc.Action>>((ref) {
  // Simulate fetching local actions
  return [_dummyAction2];
});
