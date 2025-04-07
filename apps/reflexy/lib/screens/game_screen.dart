import 'dart:async'; // Needed for StreamSubscription
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

    // --- Confetti Controller Hook ---
    final confettiController = useMemoized(() => ConfettiController(duration: const Duration(milliseconds: 500)), []);
    useEffect(() => confettiController.dispose, []); // Dispose controller

    // Start Game on First Build
    useEffect(() {
      Future.microtask(() => gameNotifier.startGame());
      return null;
    }, const []);

    // Listen to Motion Events & Trigger Confetti
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
    }, [motionDetector, gameNotifier, gameState.currentActions, confettiController]); // Add confettiController

    return Scaffold(
      appBar: AppBar(
        title: Text('Level ${gameState.level} - Score: ${gameState.score}'),
      ),
      // --- Stack for Confetti Overlay ---
      body: Stack(
        alignment: Alignment.topCenter, // Align confetti to top center
        children: [
          // Main Game Area
          Center(
            child: gameState.isGameOver
                ? _buildGameOver(context, gameNotifier)
                : _buildGameArea(context, gameState),
          ),
          // Confetti Widget
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

  // Helper to build the main game area
  Widget _buildGameArea(BuildContext context, GameState gameState) {
    final textTheme = Theme.of(context).textTheme;
    final currentAction = gameState.currentActions.firstOrNull;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Perform Action:',
          style: textTheme.headlineMedium,
        ),
        const SizedBox(height: 40),
        // TODO: Replace Text with better visual representation (Icon/SVG/Emoji)
        Text(
          currentAction?.name ?? '...',
          style: textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        // TODO: Add Timer display if implemented
      ],
    );
  }

  // Helper to build the game over display
  Widget _buildGameOver(BuildContext context, GameNotifier gameNotifier) {
     final textTheme = Theme.of(context).textTheme;
     return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Text('Game Over!', style: textTheme.displayMedium),
           const SizedBox(height: 20),
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
