# Verily Product Requirements

This document outlines the product requirements for the Verily ecosystem, a platform for creating and verifying real-world actions.

## 1. Overall Vision

Verily is a platform that enables the creation and verification of real-world actions through mobile device sensors and on-device machine learning. It consists of two main applications: Verily Create for action creators and Verily for end-users performing the actions. The platform aims to provide a secure and reliable way to verify that specific actions have been performed in the real world.

## 2. Core Products

The Verily ecosystem consists of two main applications and a supporting backend:

### 2.1. `Verily Create` (Creator Application)

- **Purpose:** Web and mobile application for creating and managing verifiable actions.
- **Core Functionality:**
  - Create complex action sequences with multiple verification steps
  - Define action parameters (location, time limits, required tasks)
  - Set up webhook endpoints for action status notifications
  - Generate shareable links and QR codes for actions
  - View analytics and completion rates for created actions
- **Action Types:**
  - Location-based verification (GPS coordinates with radius)
  - Physical actions (press-ups, jumping, device rotation)
  - Social interactions (high-fives, group activities)
  - Visual verification (smile detection, pose matching)
  - Scanning (QR codes, NFC tags, barcodes)
  - Combinations of multiple action types
- **Action Configuration:**
  - Time limits for completion
  - Sequential vs random action selection
  - Required vs optional steps
  - Custom success criteria
  - Webhook configuration for status updates

### 2.2. `Verily` (End-User Application)

- **Purpose:** Mobile application (iOS/Android) for performing and verifying actions.
- **Core Functionality:**
  - QR code scanner for action initiation
  - Deep link support for direct action access
  - Step-by-step action guidance
  - Real-time verification feedback
  - Progress tracking for multi-step actions
- **User Flow:**
  1. Open action via QR scan or deep link
  2. If opened on desktop, display QR code for mobile app
  3. If app not installed, redirect to app store
  4. Present action requirements and instructions
  5. Guide through verification process
  6. Confirm completion and notify creator
- **Authentication Options:**
  - Anonymous usage with device fingerprinting
  - Optional account creation for action history
  - Social login integration
  - Phone number verification
  - Email verification

## 3. Backend Infrastructure

- **Technology Stack:**
  - Rust-based backend using SQLX
  - PostgreSQL database
  - Flutter web for creator portal
  - Flutter Rust Bridge for mobile-backend communication
- **Core Features:**
  - Action storage and management
  - User/Creator authentication
  - Webhook management and delivery
  - Analytics and reporting
  - API access for third-party integration
- **Verification Process:**
  1. Creator generates action through Verily Create
  2. System generates unique action URL/QR code
  3. End-user accesses action via Verily app
  4. App guides user through verification steps
  5. Backend validates completion
  6. Webhook notifications sent to creator
  - Start of verification
  - Step completion updates
  - Final verification status
  - Any failure states

## 4. Target Use Cases

- Treasure hunts and city-wide games
- Marketing campaign engagement verification
- Event attendance and participation tracking
- Fitness challenge completion verification
- Location-based rewards programs
- Team-building activities
- Educational scavenger hunts
- Customer loyalty programs

## 5. Security & Privacy

- End-to-end encryption for sensitive data
- Secure webhook communication
- Privacy-focused data collection
- Compliance with GDPR and similar regulations
- Protection against verification spoofing
- Rate limiting and abuse prevention

## 6. Future Considerations

- Marketplace for action templates
- Advanced analytics and insights
- Custom verification type creation
- API for third-party integrations
- White-label solutions
- Multi-language support
- Offline verification capabilities
- Cross-platform action sharing
