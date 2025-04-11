import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:verily_client/verily_client.dart';

import 'package:verily/main.dart'; // Assuming client is accessible here

// Required for code generation
part 'action_providers.g.dart';

/// Provider to fetch available actions.
@riverpod
Future<List<Action>> availableActions(AvailableActionsRef ref) async {
  // Access the Serverpod client
  final client = ref.watch(serverpodClientProvider);
  // Call the hypothetical endpoint
  // TODO: Replace with actual endpoint call if different
  return client.action.getAvailableActions();
}

/// Provider to fetch actions the user has accepted.
@riverpod
Future<List<Action>> acceptedActions(AcceptedActionsRef ref) async {
  final client = ref.watch(serverpodClientProvider);
  // TODO: Replace with actual endpoint call if different
  return client.action.getAcceptedActions();
}

/// Provider to fetch local actions (e.g., based on location).
@riverpod
Future<List<Action>> localActions(LocalActionsRef ref) async {
  final client = ref.watch(serverpodClientProvider);
  // TODO: Replace with actual endpoint call if different
  // This might require location data to be passed
  return client.action.getLocalActions();
}
