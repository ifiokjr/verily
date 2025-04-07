import 'dart:async';
import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/game_action.dart';

// Represents the current state of the game
class GameState {
  final int score;
  final int level;
  final List<GameAction> currentActions; // Actions to perform in this sequence
  final bool isGameOver;
  final DateTime? actionStartTime; // When the current action(s) were presented
  final Duration actionTimeLimit; // Max time allowed per action/sequence

  const GameState({
    this.score = 0,
    this.level = 1,
    this.currentActions = const [],
    this.isGameOver = false,
    this.actionStartTime,
    this.actionTimeLimit = const Duration(seconds: 5), // Initial 5 second limit
  });

  GameState copyWith({
    int? score,
    int? level,
    List<GameAction>? currentActions,
    bool? isGameOver,
    // Allow explicitly setting start time to null when game is over or between actions
    DateTime? actionStartTime,
    bool clearActionStartTime = false,
    Duration? actionTimeLimit,
  }) {
    return GameState(
      score: score ?? this.score,
      level: level ?? this.level,
      currentActions: currentActions ?? this.currentActions,
      isGameOver: isGameOver ?? this.isGameOver,
      actionStartTime: clearActionStartTime ? null : actionStartTime ?? this.actionStartTime,
      actionTimeLimit: actionTimeLimit ?? this.actionTimeLimit,
    );
  }

  // Helper to get remaining time
  Duration get remainingTime {
    if (isGameOver || actionStartTime == null) {
      return Duration.zero;
    }
    final elapsed = DateTime.now().difference(actionStartTime!);
    final remaining = actionTimeLimit - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }
}

// Provider for the game state
// Using StateNotifierProvider for more complex logic later
class GameNotifier extends StateNotifier<GameState> {
  GameNotifier() : super(const GameState());

  Timer? _actionTimer;

  void startGame() {
    print("[GameNotifier] Starting game...");
    state = const GameState(); // Reset state completely
    _generateNextActions();
  }

  void actionSuccess(GameAction action) {
    print("[GameNotifier] Received action: $action. Required: ${state.currentActions.firstOrNull}");
    _cancelActionTimer(); // Action performed, cancel timer

    if (state.isGameOver) return; // Ignore if already game over

    if (state.currentActions.isNotEmpty && state.currentActions.first == action) {
      print("[GameNotifier] Correct action! Score: ${state.score + 1}");
      // TODO: Handle multi-action sequences later
      state = state.copyWith(
        score: state.score + 1,
        // level: state.level + (state.score + 1) % 5 == 0 ? 1 : 0, // Increment level every 5 points
        currentActions: [], // Clear current action
        clearActionStartTime: true,
      );
      _generateNextActions(); // Get the next action
    } else {
      print("[GameNotifier] Incorrect action or no action required.");
      actionFailure(); // Treat as failure if action is wrong or unexpected
    }
  }

  void actionFailure() {
    print("[GameNotifier] Action failed! Game Over.");
    _cancelActionTimer();
    if (!state.isGameOver) { // Prevent setting state if already game over
      state = state.copyWith(isGameOver: true, clearActionStartTime: true);
    }
  }

  void _generateNextActions() {
    print("[GameNotifier] Generating next action(s)...");
    // Randomly select the next action type
    final random = Random();
    // Now includes 5 actions: drop, rotateL/R, spinL/R
    final actionTypeIndex = random.nextInt(5);

    GameAction nextAction;
    switch (actionTypeIndex) {
      case 0:
        nextAction = GameAction.drop;
        break;
      case 1:
        nextAction = GameAction.rotateLeft; // Roll CCW
        break;
      case 2:
        nextAction = GameAction.rotateRight; // Roll CW
        break;
      case 3:
        nextAction = GameAction.spinLeft; // Yaw CCW
        break;
      case 4:
        nextAction = GameAction.spinRight; // Yaw CW
        break;
      default: // Should not happen
        nextAction = GameAction.drop;
    }

    print("[GameNotifier] Next action required: $nextAction");

    state = state.copyWith(
      currentActions: [nextAction],
      isGameOver: false,
      actionStartTime: DateTime.now(), // Set start time for the new action
    );
    _startActionTimer(); // Start timer for the new action
  }

  // --- Timer Logic ---
  void _startActionTimer() {
    _cancelActionTimer(); // Cancel any existing timer first
    if (state.isGameOver) return; // Don't start timer if game is over

    print("[GameNotifier] Starting action timer for ${state.actionTimeLimit.inSeconds} seconds.");
    _actionTimer = Timer(state.actionTimeLimit, () {
      print("[GameNotifier] Timer finished! Time's up.");
      // Check if the game state hasn't changed (e.g., action succeeded just before timer fired)
      // and ensure the game isn't already over.
      if (!state.isGameOver && state.actionStartTime != null) {
        actionFailure();
      }
    });
  }

  void _cancelActionTimer() {
    if (_actionTimer?.isActive ?? false) {
       print("[GameNotifier] Cancelling active action timer.");
      _actionTimer!.cancel();
    }
    _actionTimer = null;
  }

  // Ensure timer is cancelled when the notifier is disposed
  @override
  void dispose() {
    _cancelActionTimer();
    super.dispose();
  }
}

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier();
});
