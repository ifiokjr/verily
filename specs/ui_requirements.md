# Verily UI/UX Requirements

This document outlines the User Interface (UI) and User Experience (UX) guidelines for the Verily application and potentially the `Reflexy` demo game.

## 1. Core Philosophy: Apple Human Interface Guidelines (HIG)

- **Mandate:** The UI design _must_ strictly adhere to Apple's Human Interface Guidelines (HIG). The goal is a **sleek, modern, minimal, intuitive, and extremely easy-to-use** interface that feels native and premium on iOS, while still providing a consistent and high-quality experience on Android through Flutter's rendering capabilities.
- **Inspiration:** Aim for the polish, simplicity, and user-centricity associated with Apple's own applications. Think clarity, depth, and deference to content.

## 2. Visual Design

- **Platform:** Flutter
- **Style:** Modern, clean, minimalist.
- **Layout:**
  - Generous use of whitespace to improve readability and reduce clutter.
  - Clear visual hierarchy using typography, size, and color.
  - Logical flow and information architecture.
- **Color Palette:**
  - Primarily neutral or muted colors (whites, grays) as a base.
  - Limited, purposeful use of accent colors for branding, calls to action, and status indicators (e.g., success, failure, processing).
  - Ensure high contrast ratios for accessibility.
- **Typography:**
  - Clean, legible sans-serif fonts (e.g., SF Pro for Apple-like feel, Roboto, or similar high-quality font available via `google_fonts`).
  - Consistent font scaling and weights according to HIG recommendations.
- **Iconography:**
  - Use high-quality, clear, and universally understood icons (e.g., SF Symbols if possible via packages, or Material Icons styled minimally).
  - Ensure icons are pixel-perfect and appropriately sized.
- **Imagery/Visuals:**
  - If illustrations or graphics are used, they should match the modern, minimal aesthetic.
  - Camera previews should be clear and well-integrated into the UI.

## 3. Animations & Motion

- **Purpose:** Use animations to:
  - Provide feedback on user interactions.
  - Guide the user's focus.
  - Enhance the perception of performance.
  - Create smooth transitions between states or screens.
- **Style:**
  - Subtle and purposeful, not distracting.
  - **Prefer spring animations** for a natural, physics-based feel where appropriate (e.g., modal presentations, interactive elements).
  - Ensure all animations are smooth and performant (target 60+ FPS).
- **Examples:** Animated progress indicators, smooth screen transitions, feedback on successful/failed verification steps.

## 4. User Experience (UX)

- **Simplicity:** The verification process must be extremely straightforward and require minimal cognitive load from the user.
- **Clarity:**
  - **Instructions:** Provide crystal-clear, concise instructions for each required action. Use visuals (icons, simple diagrams) alongside text where helpful.
  - **Feedback:** Offer immediate and unambiguous real-time feedback during action performance (e.g., a meter filling up, checkmarks appearing, visual overlays on the camera feed indicating correct pose/position).
- **Navigation:** Intuitive and predictable navigation within the app.
- **Friction:** Minimize the number of steps and decisions required from the user to complete a verification flow.
- **Permissions:** Request necessary permissions (camera, location, etc.) contextually and clearly explain why they are needed.
- **Error Handling:** Provide helpful and clear error messages if an action fails or cannot be completed.

## 5. Responsiveness & Accessibility

- **Responsiveness:** Design layouts that adapt gracefully to different screen sizes and orientations (primarily mobile, but consider tablet form factors).
- **Accessibility:** Adhere to accessibility best practices:
  - Sufficient color contrast.
  - Support for dynamic font sizes.
  - Screen reader compatibility (Semantics widgets in Flutter).
  - Adequate touch target sizes.

## 6. Branding & Voice

- **UI Text:** Following the `general.mdc` rule, all user-facing text (instructions, button labels, titles, error messages) should be:
  - **Confident and Direct:** No fluff or jargon.
  - **Clear and Concise:** Easy to understand quickly.
  - **Sharp and Bold:** Reflects competence.
  - **Witty (Appropriately):** Inject personality where it fits without sacrificing clarity (e.g., success messages, Reflexy game text).
  - **Action-Oriented:** Especially for buttons and calls to action.
