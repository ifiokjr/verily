import 'package:flutter/material.dart';

/// Placeholder screen for user profile.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('User Profile Screen - Content TBD')),
    );
  }
}
