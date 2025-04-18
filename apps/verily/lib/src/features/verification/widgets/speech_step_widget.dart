import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../providers/verification_flow_provider.dart';

/// Widget to handle the speech recognition step.
/// Requires microphone and speech recognition permissions.
class SpeechStepWidget extends HookConsumerWidget {
  final Map<String, dynamic> parameters;
  final VerificationFlow notifier;

  const SpeechStepWidget({
    required this.parameters,
    required this.notifier,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // --- State Hooks ---
    final speechToText = useMemoized(() => SpeechToText());
    final isSpeechAvailable = useState<bool>(false);
    final isListening = useState<bool>(false);
    final lastWords = useState<String>('');
    final lastError = useState<String>('');
    final targetPhrase = useState<String?>(null);
    final reportedSuccess = useState<bool>(false); // Prevent multiple reports

    // --- Helper Functions ---

    /// Processes the final recognized words against the target phrase.
    void processFinalResult(String recognized, String? target) {
      if (target == null || target.isEmpty || reportedSuccess.value) return;

      // Normalize both strings for comparison (lowercase, trim whitespace)
      final normRecognized = recognized.trim().toLowerCase();
      final normTarget = target.trim().toLowerCase();

      debugPrint('Comparing: "$normRecognized" vs "$normTarget"');

      if (normRecognized == normTarget) {
        reportedSuccess.value = true;
        notifier.reportStepSuccess({
          'recognized_phrase': recognized,
          'target_phrase': target,
        });
      } else {
        // Set error for UI feedback, but don't report failure immediately
        // Let user try again by tapping the mic button
        lastError.value = 'Phrase did not match. Please try again.';
        lastWords.value = ''; // Clear last words for next attempt
      }
    }

    /// Initializes speech recognition.
    Future<void> initSpeech() async {
      try {
        final available = await speechToText.initialize(
          onError:
              (errorNotification) =>
                  lastError.value =
                      'Speech Error: ${errorNotification.errorMsg}',
          onStatus: (status) {
            // Check status changes (e.g., 'listening', 'notListening', 'done')
            debugPrint('Speech status: $status');
            isListening.value = speechToText.isListening;
            // Process final result when listening stops
            if (status == 'notListening' && !reportedSuccess.value) {
              // Call the function defined above
              processFinalResult(lastWords.value, targetPhrase.value);
            }
          },
          // debugLog: true, // Removed parameter
        );
        isSpeechAvailable.value = available;
        if (!available) {
          lastError.value = 'Speech recognition not available on this device.';
        }
      } catch (e) {
        lastError.value = 'Error initializing speech: ${e.toString()}';
        isSpeechAvailable.value = false;
      }
    }

    /// Starts listening for speech.
    void startListening() {
      if (!isSpeechAvailable.value || isListening.value) return;
      lastWords.value = '';
      lastError.value = '';
      // Consider platform-specific options if needed (partialResults, etc.)
      speechToText.listen(
        onResult: (SpeechRecognitionResult result) {
          lastWords.value = result.recognizedWords;
          // Optionally provide real-time feedback or check for match early
        },
        // listenFor: Duration(seconds: 30), // Optional duration
        // pauseFor: Duration(seconds: 5), // Optional pause detection
        localeId: 'en_US', // Adjust locale if needed
      );
      isListening.value = true;
    }

    /// Stops the speech recognition engine.
    void stopListening() {
      if (!isListening.value) return;
      speechToText.stop();
      isListening.value = false;
      // Final result processing happens in onStatus callback
    }

    // --- Effect Hooks ---
    /// Effect to initialize speech recognition and parse parameters on mount.
    useEffect(() {
      initSpeech();

      // Parse target phrase from parameters
      final phraseParam = parameters['phrase']?.toString();
      if (phraseParam == null || phraseParam.isEmpty) {
        lastError.value = 'Configuration Error: Target phrase not specified.';
        // Report configuration error as failure
        notifier.reportStepFailure(lastError.value);
      } else {
        targetPhrase.value = phraseParam;
      }
      return null; // No cleanup needed here for initSpeech
    }, [speechToText]); // Run once when the widget mounts

    // --- UI Build ---
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title
          Text(
            'Speech Recognition',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Instructions and Target Phrase
          if (targetPhrase.value != null)
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Please say clearly:',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '"${targetPhrase.value}"',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 32),

          // Display Recognized Words
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                lastWords.value.isEmpty
                    ? (isListening.value ? 'Listening...' : ' ')
                    : lastWords.value,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
              ),
            ),
          ),

          // Error Display
          if (lastError.value.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                lastError.value,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 16),

          // Microphone Button
          FloatingActionButton(
            onPressed:
                (!isSpeechAvailable.value || targetPhrase.value == null)
                    ? null // Disable if unavailable or no target phrase
                    : isListening.value
                    ? stopListening
                    : startListening,
            backgroundColor:
                isListening.value
                    ? Colors.red
                    : Theme.of(context).colorScheme.primary,
            tooltip: isListening.value ? 'Stop Listening' : 'Start Listening',
            child: Icon(
              isListening.value ? Icons.mic_off : Icons.mic,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isListening.value ? 'Tap to Stop' : 'Tap to Record',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),

          const SizedBox(height: 20), // Bottom padding
        ],
      ),
    );
  }
}
