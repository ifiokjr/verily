import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Reflexy')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // TODO: Replace with a cool game logo/graphic
              Icon(
                Icons.touch_app_outlined,
                size: 100,
                color: colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Test Your Reflexes!',
                style: textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Follow the actions as fast as you can.',
                style: textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const Spacer(), // Pushes buttons down
              ElevatedButton(
                onPressed: () => context.goNamed(AppRoute.game.name),
                child: const Text('Start Game'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.goNamed(AppRoute.instructions.name),
                child: const Text('How to Play'),
              ),
              const SizedBox(height: 32), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}
