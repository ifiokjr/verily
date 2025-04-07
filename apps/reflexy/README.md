# Reflexy: The Reflex Action Game

This app is part of the Verily project, serving as both a demonstration and testing ground for the action verification capabilities.

## Gameplay

Reflexy challenges your ability to quickly recognize and perform various physical actions prompted on screen.

1. **Action Prompts:** The game displays actions using emojis, icons, or words (e.g., "Smile", "Rotate Left", "Touch Nose").
2. **Perform the Action:** Execute the prompted action as accurately as possible.
3. **Increasing Difficulty:** The game starts with single, simple actions. As you progress:
   - The time to react may decrease.
   - Sequences of multiple actions will appear, requiring you to remember and perform them in order.
4. **Scoring:** Points are awarded for correct and timely actions.

## Purpose

Beyond being a game, Reflexy serves several key purposes:

- **Testing `verily_device_motion`:** It provides a real-world scenario to test the drop, yaw, and roll detection features of the core package.
- **Testing ML Kit Integration:** It validates the use of `google_mlkit_face_detection` for actions like smiling, winking, blinking, and potentially others like head pose or eye tracking for touch verification.
- **Demonstrating SDK Usage:** Shows developers how to integrate the Verily action verification logic into a Flutter application.

## How to Play

1. **Start:** Launch the app and press "Start Game" on the home screen.
2. **Observe:** Pay close attention to the action prompt(s) displayed.
3. **React:** Perform the action(s) shown using your device's camera and motion sensors.
   - **Facial Actions:** Ensure your face is clearly visible to the camera (Smile, Wink, Blink, Tongue Out).
   - **Motion Actions:** Perform phone rotations or simulated drops as indicated.
   - **Touch Actions:** Physically touch the indicated part of your face/head (Nose, Ear, Eye, Forehead).
4. **Repeat:** Continue performing actions as they appear. Sequences will get longer and faster!

## Development Setup

1. Ensure you have Flutter installed (preferably via `fvm`).
2. Clone the main Verily repository.
3. Navigate to the app directory: `cd apps/reflexy`
4. Fetch dependencies: `flutter pub get`
5. Run the app: `flutter run` (ensure a device or simulator is connected/running).
