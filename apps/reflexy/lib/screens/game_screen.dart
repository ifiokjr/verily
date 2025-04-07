import 'dart:async'; // Needed for StreamSubscription & Timer
import 'dart:math'; // Needed for confetti Path
import 'package:confetti/confetti.dart'; // Import confetti
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verily_device_motion/verily_device_motion.dart';

import '../models/game_action.dart';
import '../providers/game_provider.dart';

// --- Custom Hook for Motion Detector Service ---
// This hook encapsulates the creation and disposal of the MotionDetectorService.
// By using a hook, we ensure the service is created only once when the widget
// mounts and properly disposed of when the widget unmounts, preventing leaks.
MotionDetectorService useMotionDetector({
  // Default sensitivity values match those in the MotionDetectorService itself.
  // These could be customized if needed when the hook is called.
  double initialDropSensitivity = 2.0,
  double initialYawSensitivity = 0.75,
  double initialRollSensitivity = 0.75,
}) {
  // `useRef` holds a mutable reference to the service that persists across rebuilds.
  // It's initialized to null and created inside `useEffect`.
  final detectorRef = useRef<MotionDetectorService?>(null);

  // `useEffect` runs side effects. With an empty dependency list (`[]`), it runs
  // only once when the hook mounts (creating the service) and its cleanup
  // function runs when the hook unmounts (disposing the service).
  useEffect(() {
    // Create the service instance.
    print(
      '[MotionDetector Hook - GameScreen] Creating detector instance ONCE...',
    );
    detectorRef.value = MotionDetectorService(
      dropSensitivity: initialDropSensitivity,
      yawSensitivity: initialYawSensitivity,
      rollSensitivity: initialRollSensitivity,
      // Explicitly setting cooldown here, though it matches the service default.
      detectionResetDelay: const Duration(seconds: 1),
    );
    // Start listening for sensor events.
    detectorRef.value!.startListening();
    print('[MotionDetector Hook - GameScreen] Initialized');

    // Return a cleanup function. This is called when the widget is removed
    // from the tree (unmounted).
    return () {
      print(
        '[MotionDetector Hook - GameScreen] Disposing detector instance...',
      );
      // Cancel sensor subscriptions and release resources.
      detectorRef.value?.dispose();
      detectorRef.value = null;
    };
  }, const []); // Empty list means run only on mount/unmount.

  // The service is guaranteed to be non-null after the first build.
  return detectorRef.value!;
}
// --- End Motion Detector Hook ---

/// GameScreen: The main screen for the Reflexy game.
///
/// Uses `HookConsumerWidget` to combine Flutter Hooks for managing local state
/// (like animations, timers, controllers) and Riverpod for accessing global
/// application state (like the game state).
class GameScreen extends HookConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- State Access ---
    // Watch the game state provider. This widget will rebuild when GameState changes.
    final gameState = ref.watch(gameProvider);
    // Read the notifier to call methods like startGame, actionSuccess, etc.
    // `read` is used here because we don't need to rebuild when the notifier itself changes.
    final gameNotifier = ref.read(gameProvider.notifier);
    // Get the motion detector instance using our custom hook.
    final motionDetector = useMotionDetector();
    // Create and manage the confetti controller using `useMemoized` to create it
    // once and `useEffect` (below) to dispose of it.
    final confettiController = useMemoized(
      () => ConfettiController(duration: const Duration(milliseconds: 500)),
      [],
    );

    // --- State for Timer Display ---
    final displayedSeconds = useState<int>(gameState.actionTimeLimit.inSeconds);

    // --- State for Red Flash Effect ---
    // Controls the visibility of the red flash overlay for incorrect actions.
    final showRedFlash = useState(false);

    // --- Side Effects (Hooks) ---

    // Dispose Confetti Controller
    // This `useEffect` hook ensures the confetti controller is disposed when
    // the widget is removed from the tree.
    useEffect(
      () {
        // The function returned by the effect is the cleanup function.
        return confettiController.dispose;
      },
      [confettiController],
    ); // Re-run dispose logic if controller instance changes (it shouldn't).

    // Start Game on First Build
    // This `useEffect` runs once after the first build to initialize the game.
    useEffect(() {
      // `Future.microtask` delays the call slightly, ensuring the first build
      // is complete before modifying the state.
      Future.microtask(() => gameNotifier.startGame());
      // No cleanup needed, so return null.
      return null;
    }, const []); // Empty list means run only once.

    // Local Timer Logic for Countdown UI
    // This `useEffect` manages a periodic timer to update the countdown display.
    useEffect(
      () {
        Timer? periodicTimer;

        // Helper function to start/restart the UI timer.
        void startUiTimer() {
          periodicTimer?.cancel(); // Cancel any existing timer.

          // Only start if the game is running and an action is active.
          if (!gameState.isGameOver && gameState.actionStartTime != null) {
            print("[GameScreen Timer] Starting UI Timer.");
            // Create a timer that fires every second.
            periodicTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
              // Inside the timer, read the LATEST game state to get accurate remaining time.
              final currentRemaining = ref.read(gameProvider).remainingTime;
              final remainingSec = currentRemaining.inSeconds;
              // Update the local state (`displayedSeconds`) to trigger UI refresh.
              displayedSeconds.value = remainingSec;

              // Stop the timer if time runs out or game ends.
              if (remainingSec <= 0 || ref.read(gameProvider).isGameOver) {
                print(
                  "[GameScreen Timer] Stopping UI Timer (Time up or Game Over).",
                );
                timer.cancel();
                periodicTimer = null;
              }
            });
            // Set the initial display value immediately.
            displayedSeconds.value = gameState.remainingTime.inSeconds;
          } else {
            // If game is over or no action, reset the display.
            print(
              "[GameScreen Timer] Not starting UI Timer (Game Over or no action). Resetting display.",
            );
            displayedSeconds.value = gameState.actionTimeLimit.inSeconds;
          }
        }

        // Start the timer initially and whenever actionStartTime or isGameOver changes.
        startUiTimer();

        // Cleanup function: Cancel the timer if the effect re-runs or widget disposes.
        return () {
          print("[GameScreen Timer] Cleaning up UI Timer.");
          periodicTimer?.cancel();
        };
      },
      [
        // Dependency array: This effect re-runs if `actionStartTime` or `isGameOver` changes.
        gameState.actionStartTime,
        gameState.isGameOver,
      ],
    );

    // Auto-hide Red Flash Effect
    // This effect runs whenever `showRedFlash.value` changes.
    useEffect(() {
      // If the flash is set to show...
      if (showRedFlash.value) {
        // ...start a short timer to hide it again.
        final timer = Timer(const Duration(milliseconds: 200), () {
          // Check if it's still true before setting to false, in case
          // multiple errors happened quickly.
          if (showRedFlash.value) {
            print("[GameScreen Flash] Hiding red flash.");
            showRedFlash.value = false;
          }
        });
        // Cleanup: cancel the timer if the effect re-runs before it fires.
        return timer.cancel;
      }
      // No cleanup needed if flash wasn't shown.
      return null;
    }, [showRedFlash.value]); // Dependency: run when flash state changes.

    // Motion Event Listener & Action Handling
    useEffect(
      () {
        print("[GameScreen Listener] Subscribing to motion detector...");
        final StreamSubscription<MotionEvent>
        subscription = motionDetector.motionEvents.listen(
          (event) {
            print(
              "[GameScreen Listener] Received motion event: ${event.type}, Direction: ${event.direction}",
            );
            final currentRequiredActions =
                ref.read(gameProvider).currentActions;
            if (currentRequiredActions.isEmpty) {
              print(
                "[GameScreen Listener] No action currently required. Ignoring event.",
              );
              return;
            }
            final requiredAction = currentRequiredActions.first;
            bool actionMatched = false;
            bool motionDetected = false; // Track if a relevant motion occurred

            // --- Handle Drop ---
            if (event.type == MotionEventType.drop) {
              motionDetected = true;
              if (requiredAction == GameAction.drop) {
                  print("[GameScreen Listener] Drop detected and required! Triggering success.");
                  actionMatched = true;
              }
            }
            // --- Handle Roll ---
            else if (event.type == MotionEventType.roll) {
              motionDetected = true;
              if (requiredAction == GameAction.rotateLeft && event.direction == RotationDirection.counterClockwise) {
                print("[GameScreen Listener] Roll Left (CCW) detected and required! Triggering success.");
                actionMatched = true;
              } else if (requiredAction == GameAction.rotateRight && event.direction == RotationDirection.clockwise) {
                print("[GameScreen Listener] Roll Right (CW) detected and required! Triggering success.");
                actionMatched = true;
              } else {
                 print("[GameScreen Listener] Roll detected (${event.direction}), but required action was $requiredAction. Ignoring.");
              }
            }
            // --- Handle Yaw (Spin) ---
            else if (event.type == MotionEventType.yaw) {
              motionDetected = true;
               if (requiredAction == GameAction.rotateAntiClockwise && event.direction == RotationDirection.counterClockwise) {
                print("[GameScreen Listener] Spin Left (Yaw CCW) detected and required! Triggering success.");
                actionMatched = true;
              } else if (requiredAction == GameAction.rotateClockwise && event.direction == RotationDirection.clockwise) {
                print("[GameScreen Listener] Spin Right (Yaw CW) detected and required! Triggering success.");
                actionMatched = true;
              } else {
                 print("[GameScreen Listener] Yaw detected (${event.direction}), but required action was $requiredAction. Ignoring.");
              }
            }

            // --- Process Result ---
            if (actionMatched) {
              gameNotifier.actionSuccess(requiredAction);
              confettiController.play();
            } else if (motionDetected) {
              // A relevant motion was detected, but it didn't match the required action.
              print("[GameScreen Listener] Incorrect motion detected! Triggering red flash.");
              showRedFlash.value = true; // Trigger the flash
            } else {
              // Optional: Log unhandled event types if needed
               print("[GameScreen Listener] Received unhandled/ignored event type: ${event.type}");
            }
          },
          onError:
              (e) => print("[GameScreen Listener] Motion Stream Error: $e"),
          onDone: () => print("[GameScreen Listener] Motion Stream Done."),
        );

        // Cleanup function
        return () {
          print("[GameScreen Listener] Cancelling motion subscription...");
          subscription.cancel();
        };
      },
      [
        // Dependency array: Resubscribe if these instances change.
        // Necessary to ensure the listener uses the latest notifier/controller.
        motionDetector, // The service instance.
        gameNotifier, // The game logic handler.
        confettiController, // The confetti animation controller.
        // Note: gameState.currentActions removed as reading latest inside listener is safer.
      ],
    );

    // --- UI Structure ---
    return Scaffold(
      appBar: AppBar(
        // Display current level and score.
        title: Text('Level ${gameState.level} - Score: ${gameState.score}'),
      ),
      // Stack allows overlaying widgets, here used for the confetti effect.
      body: Stack(
        alignment: Alignment.center, // Center align stack children
        children: [
          // Main content area, centered.
          Center(
            // Conditionally display game area or game over screen.
            child:
                gameState.isGameOver
                    ? _buildGameOver(context, gameState.score, gameNotifier)
                    : _buildGameArea(
                      context,
                      gameState,
                      displayedSeconds.value,
                    ),
          ),
          // --- Red Flash Overlay ---
          // This AnimatedOpacity widget controls the flash effect.
          Positioned.fill( // Make it cover the entire screen
             child: IgnorePointer( // Prevent flash from blocking interactions
                ignoring: !showRedFlash.value,
                child: AnimatedOpacity(
                  opacity: showRedFlash.value ? 1.0 : 0.0, // Control visibility
                  duration: const Duration(milliseconds: 100), // Fade in/out duration
                  curve: Curves.easeInOut, // Smooth transition
                  child: Container(
                     // Semi-transparent red color for the flash
                     color: Colors.red.withOpacity(0.4),
                   ),
                ),
              ),
           ),
          // --- Confetti Overlay ---
          // Align confetti to top center for success celebration.
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality:
                  BlastDirectionality.explosive, // Fun explosion effect.
              shouldLoop: false, // Play animation only once per trigger.
              numberOfParticles: 20,
              gravity: 0.1,
              emissionFrequency: 0.05,
              // createParticlePath: drawStar, // Uncomment for custom star particles.
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the main game area showing the timer and action prompt.
  Widget _buildGameArea(
    BuildContext context,
    GameState gameState,
    int displayedSeconds,
  ) {
    final textTheme = Theme.of(context).textTheme;
    // Get the action to perform (if any).
    final currentAction = gameState.currentActions.firstOrNull;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Display Timer only if an action is active and game is not over.
        if (currentAction != null && !gameState.isGameOver)
          Text(
            '${displayedSeconds}s', // Show remaining seconds.
            style: textTheme.headlineLarge?.copyWith(
              color: Colors.orangeAccent,
            ),
          ),
        const SizedBox(height: 20),
        Text('Perform Action:', style: textTheme.headlineMedium),
        const SizedBox(height: 40),
        // AnimatedSwitcher handles smooth transitions between actions.
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300), // Fade duration.
          transitionBuilder: (Widget child, Animation<double> animation) {
            // Use FadeTransition for the in/out effect.
            return FadeTransition(opacity: animation, child: child);
          },
          // The child widget (Icon or Text displaying the action).
          child: _buildActionWidget(
            context,
            currentAction,
            gameState.actionStartTime,
          ),
        ),
      ],
    );
  }

  /// Helper function to build the widget representing the current action.
  /// Displays an Icon and Text label for specific actions, Text otherwise.
  Widget _buildActionWidget(
    BuildContext context,
    GameAction? action,
    DateTime? keyTime,
  ) {
    final textTheme = Theme.of(context).textTheme;
    // Slightly smaller icon size when text is also present
    final iconSize = (textTheme.displayLarge?.fontSize ?? 64.0) * 0.8;
    final labelStyle = textTheme.titleMedium; // Style for the text label

    // Use the action start time as the key for the AnimatedSwitcher child.
    final key = ValueKey<DateTime?>(keyTime);

    // Helper to build Column with Icon and Text
    Widget buildIconWithLabel(IconData iconData, String label) {
      return Column(
        key: key, // Assign key to the top-level widget in the Column
        mainAxisSize: MainAxisSize.min, // Keep column height tight
        children: [
          Icon(
            iconData,
            size: iconSize,
            color: Theme.of(context).iconTheme.color, // Use theme color
          ),
          const SizedBox(height: 8), // Space between icon and text
          Text(label, style: labelStyle, textAlign: TextAlign.center),
        ],
      );
    }

    switch (action) {
      case GameAction.rotateLeft:
        // Using arrow_circle_left_outlined for ROLL
        return buildIconWithLabel(
          Icons.arrow_circle_left_outlined,
          'Rotate Left',
        );
      case GameAction.rotateRight:
        // Using arrow_circle_right_outlined for ROLL
        return buildIconWithLabel(
          Icons.arrow_circle_right_outlined,
          'Rotate Right',
        );
      case GameAction.drop:
        // Using arrow_circle_down_outlined for drop action
        return buildIconWithLabel(Icons.arrow_circle_down_outlined, 'Drop');
      case GameAction.rotateAntiClockwise:
        // Using rotate_left for YAW CCW
        return buildIconWithLabel(Icons.rotate_left, 'Rotate Anti-Clockwise');
      case GameAction.rotateClockwise:
        // Using rotate_right for YAW CW
        return buildIconWithLabel(Icons.rotate_right, 'Rotate Clockwise');
      // Add cases for other future icon-based actions here
      default:
        // Default to Text for null or other text-only actions
        return Text(
          key: key,
          action?.name ?? '...', // Display action name or '...'
          style: textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        );
    }
  }

  /// Builds the game over screen displaying the final score and a restart button.
  Widget _buildGameOver(
    BuildContext context,
    int finalScore,
    GameNotifier gameNotifier,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Game Over!', style: textTheme.displayMedium),
        const SizedBox(height: 20),
        Text('Final Score: $finalScore', style: textTheme.headlineSmall),
        const SizedBox(height: 40),
        ElevatedButton(
          // Call startGame on the notifier to reset the game state.
          onPressed: () => gameNotifier.startGame(),
          child: const Text('Play Again?'),
        ),
      ],
    );
  }
}

/// Optional: Example function to draw a star shape for confetti particles.
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
    path.lineTo(
      halfWidth + externalRadius * cos(step),
      halfWidth + externalRadius * sin(step),
    );
    path.lineTo(
      halfWidth + internalRadius * cos(step + degToRad(halfDegreesPerPoint)),
      halfWidth + internalRadius * sin(step + degToRad(halfDegreesPerPoint)),
    );
  }
  path.close();
  return path;
}
