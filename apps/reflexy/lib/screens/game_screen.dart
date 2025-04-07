import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GameScreen extends HookConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Implement game logic and UI
    return Scaffold(
      appBar: AppBar(
        title: const Text('Level 1'), // Example title
        // Add score, timer etc.
      ),
      body: const Center(
        child: Text('Game actions appear here!'),
      ),
    );
  }
}
