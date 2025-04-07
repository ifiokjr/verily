import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/game_action.dart';

// Represents the current state of the game
class GameState {
  final int score;
  final int level;
  final List<GameAction> currentActions; // Actions to perform in this sequence
  final bool isGameOver;
  final Duration timeLeft; // Optional: Timer

  const GameState({
    this.score = 0,
    this.level = 1,
    this.currentActions = const [],
    this.isGameOver = false,
    this.timeLeft = const Duration(seconds: 10), // Example timer
  });

  GameState copyWith({
    int? score,
    int? level,
    List<GameAction>? currentActions,
    bool? isGameOver,
    Duration? timeLeft,
  }) {
    return GameState(
      score: score ?? this.score,
      level: level ?? this.level,
      currentActions: currentActions ?? this.currentActions,
      isGameOver: isGameOver ?? this.isGameOver,
      timeLeft: timeLeft ?? this.timeLeft,
    );
  }
}

// Provider for the game state
// Using StateNotifierProvider for more complex logic later
class GameNotifier extends StateNotifier<GameState> {
  GameNotifier() : super(const GameState());

  void startGame() {
    // TODO: Implement game start logic (reset state, generate actions)
    state = const GameState(); // Reset for now
    _generateNextActions();
  }

  void actionSuccess(GameAction action) {
    // TODO: Check if action was correct, update score, generate next
    if (!state.isGameOver && state.currentActions.isNotEmpty && state.currentActions.first == action) {
       // Correct action!
       final remainingActions = List<GameAction>.from(state.currentActions)..removeAt(0);
       final newScore = state.score + 10; // Example scoring

       if (remainingActions.isEmpty) {
          // Sequence complete, move to next level potentially
          print("Sequence Complete!");
          state = state.copyWith(score: newScore, currentActions: []);
          _generateNextActions(); // Generate next sequence
       } else {
          // Continue current sequence
          state = state.copyWith(score: newScore, currentActions: remainingActions);
       }
    } else {
       // Incorrect action or game over
       // TODO: Handle incorrect action (e.g., penalty, game over)
       print("Incorrect action or game over");
    }

  }

  void actionFailure() {
    // TODO: Handle failure (e.g., time out, incorrect action)
    state = state.copyWith(isGameOver: true);
    print("Game Over!");
  }

  void _generateNextActions() {
    // TODO: Implement logic to generate actions based on level/difficulty
    // For now, just generate one random action
    final List<GameAction> allActions = GameAction.values;
    final nextAction = allActions[DateTime.now().millisecond % allActions.length];
    print("Next Action: $nextAction");
    state = state.copyWith(currentActions: [nextAction]);
  }

  // TODO: Add timer logic if needed
}

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier();
});
