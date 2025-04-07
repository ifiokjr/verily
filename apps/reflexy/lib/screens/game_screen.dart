import 'dart:async'; // Needed for StreamSubscription & Timer
import 'dart:math'; // Needed for confetti Path
import 'package:confetti/confetti.dart'; // Import confetti
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_device_motion/verily_device_motion.dart';

import '../models/game_action.dart';
import '../providers/game_provider.dart';

// --- Copied/Adapted Motion Detector Hook ---
// Creates the service instance ONLY ONCE when the hook mounts.
MotionDetectorService useMotionDetector({
  // Using default sensitivities from the service for now
  double initialDropSensitivity = 2.0,
  double initialYawSensitivity = 0.75,
  double initialRollSensitivity = 0.75,
}) {
  final detectorRef = useRef<MotionDetectorService?>(null);

  useEffect(() {
    print('[MotionDetector Hook - GameScreen] Creating detector instance ONCE...');
    detectorRef.value = MotionDetectorService(
      dropSensitivity: initialDropSensitivity,
      yawSensitivity: initialYawSensitivity,
      rollSensitivity: initialRollSensitivity,
      detectionResetDelay: const Duration(seconds: 1), // Keep 1s cooldown
    );
    detectorRef.value!.startListening();
    print('[MotionDetector Hook - GameScreen] Initialized');

    return () {
      print('[MotionDetector Hook - GameScreen] Disposing detector instance...');
      detectorRef.value?.dispose();
      detectorRef.value = null;
    };
  }, const []); // EMPTY dependency array

  return detectorRef.value!;
}
// --- End Motion Detector Hook ---

class GameScreen extends HookConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final gameNotifier = ref.read(gameProvider.notifier);
    final motionDetector = useMotionDetector();
    final confettiController = useMemoized(() => ConfettiController(duration: const Duration(milliseconds: 500)), []);

    // --- State for Timer Display ---
    // Holds the remaining seconds to display, updated by a local timer.
    final displayedSeconds = useState<int>(gameState.actionTimeLimit.inSeconds);

    // --- Local Timer Logic for Countdown UI ---
    useEffect(() {
      Timer? periodicTimer;

      void startUiTimer() {
        // Cancel any previous timer
        periodicTimer?.cancel();

        // Only start if game is active and there's an action/start time
        if (!gameState.isGameOver && gameState.actionStartTime != null) {
          print("[GameScreen Timer] Starting UI Timer.");
          periodicTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
            // Read the *current* remaining time from the provider
            // Important: Read within the timer callback to get the latest state
            final currentRemaining = ref.read(gameProvider).remainingTime;
            final remainingSec = currentRemaining.inSeconds;
            displayedSeconds.value = remainingSec; // Update UI state

            // print("[GameScreen Timer] Tick: ${remainingSec}s"); // Optional debug log

            if (remainingSec <= 0 || ref.read(gameProvider).isGameOver) {
              print("[GameScreen Timer] Stopping UI Timer (Time up or Game Over).");
              timer.cancel();
              periodicTimer = null;
            }
          });
          // Initial update
          displayedSeconds.value = gameState.remainingTime.inSeconds;
        } else {
            print("[GameScreen Timer] Not starting UI Timer (Game Over or no action). Resetting display.");
            // Reset display if game over or no action
            displayedSeconds.value = gameState.actionTimeLimit.inSeconds;
        }
      }

      // Start timer when actionStartTime changes or game over status changes
      startUiTimer();

      // Cleanup function: Cancel timer when effect reruns or widget disposes
      return () {
        print("[GameScreen Timer] Cleaning up UI Timer.");
        periodicTimer?.cancel();
      };
    }, [gameState.actionStartTime, gameState.isGameOver]); // Rerun effect when these change

    // --- Other Hooks (Confetti, Start Game, Motion Listener) ---
    useEffect(() => confettiController.dispose, []); // Dispose controller
    useEffect(() {
      Future.microtask(() => gameNotifier.startGame());
      return null;
    }, const []);

    // Listener (no changes needed here for timer)
    useEffect(() {
      print("[GameScreen Listener] Subscribing to motion detector...");
      final StreamSubscription<MotionEvent> subscription = motionDetector.motionEvents.listen(
        (event) {
          print("[GameScreen Listener] Received motion event: ${event.type}");
          if (event.type == MotionEventType.drop) {
            print("[GameScreen Listener] Drop detected! Checking required action...");
            if (gameState.currentActions.isNotEmpty && gameState.currentActions.first == GameAction.drop) {
              print("[GameScreen Listener] Correct Drop! Triggering success & confetti.");
              gameNotifier.actionSuccess(GameAction.drop);
              confettiController.play(); // Play confetti on success!
            } else {
              print("[GameScreen Listener] Drop detected, but not the required action.");
              // gameNotifier.actionFailure();
            }
          }
          // TODO: Add handlers for other motion types and trigger confetti
        },
        onError: (e) => print("[GameScreen Listener] Motion Stream Error: $e"),
        onDone: () => print("[GameScreen Listener] Motion Stream Done."),
      );
      return () {
        print("[GameScreen Listener] Cancelling motion subscription...");
        subscription.cancel();
      };
    }, [motionDetector, gameNotifier, gameState.currentActions, confettiController]);

    return Scaffold(
      appBar: AppBar(
        title: Text('Level ${gameState.level} - Score: ${gameState.score}'),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Center(
            child: gameState.isGameOver
                ? _buildGameOver(context, gameState.score, gameNotifier)
                : _buildGameArea(context, gameState, displayedSeconds.value),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive, // Or other directions
              shouldLoop: false,
              numberOfParticles: 20, // Adjust number of particles
              gravity: 0.1,         // Adjust gravity
              emissionFrequency: 0.05, // Adjust frequency
              // createParticlePath: drawStar, // Optional: Custom particle shape
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameArea(BuildContext context, GameState gameState, int displayedSeconds) {
    final textTheme = Theme.of(context).textTheme;
    final currentAction = gameState.currentActions.firstOrNull;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Display Timer if action is active
        if (currentAction != null && !gameState.isGameOver)
          Text(
            '${displayedSeconds}s',
            style: textTheme.headlineLarge?.copyWith(color: Colors.orangeAccent),
          ),
        const SizedBox(height: 20),
        Text(
          'Perform Action:',
          style: textTheme.headlineMedium,
        ),
        const SizedBox(height: 40),
        // --- AnimatedSwitcher for Action Text ---
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300), // Animation duration
          transitionBuilder: (Widget child, Animation<double> animation) {
            // Use FadeTransition for smooth in/out
            return FadeTransition(opacity: animation, child: child);
          },
          child: Text(
            // Use the action start time as the key. This changes whenever
            // a new action is generated (even if it's the same type),
            // triggering the animation.
            key: ValueKey<DateTime?>(gameState.actionStartTime),
            currentAction?.name ?? '...', // Show '...' between actions or on game over
            style: textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center, // Center align text
          ),
        ),
      ],
    );
  }

  Widget _buildGameOver(BuildContext context, int finalScore, GameNotifier gameNotifier) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Game Over!', style: textTheme.displayMedium),
        const SizedBox(height: 20),
        Text('Final Score: $finalScore', style: textTheme.headlineSmall),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () => gameNotifier.startGame(),
          child: const Text('Play Again?'),
        )
      ],
    );
  }
}

/// Example Custom Path: A star shape for confetti
Path drawStar(Size size) {
  // Method to convert degree to radians
  double degToRad(double deg) => deg * (pi / 180.0);

  const numberOfPoints = 5;
  final halfWidth = size.width / 2;
  final externalRadius = halfWidth;
  final internalRadius = halfWidth / 2.5;
  final degreesPerPoint = 360 / numberOfPoints;
  final halfDegreesPerPoint = degreesPerPoint / 2;
  final path = Path();
  final fullAngle = degToRad(360);
  path.moveTo(size.width, halfWidth);

  for (double step = 0; step < fullAngle; step += degToRad(degreesPerPoint)) {
    path.lineTo(halfWidth + externalRadius * cos(step), halfWidth + externalRadius * sin(step));
    path.lineTo(halfWidth + internalRadius * cos(step + degToRad(halfDegreesPerPoint)), halfWidth + internalRadius * sin(step + degToRad(halfDegreesPerPoint)));
  }
  path.close();
  return path;
}
