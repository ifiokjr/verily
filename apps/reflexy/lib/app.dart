import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'router.dart';
import 'theme.dart'; // Assuming a theme file will be created

class ReflexyApp extends ConsumerWidget {
  const ReflexyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: router,
      title: 'Reflexy Game',
      theme: AppTheme.lightTheme, // Define your theme
      darkTheme: AppTheme.darkTheme, // Optional dark theme
      themeMode: ThemeMode.system, // Or light/dark
      debugShowCheckedModeBanner: false,
      // Add localization delegates if needed later
      // localizationsDelegates: [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // supportedLocales: const [
      //   Locale('en', ''), // English, no country code
      // ],
    );
  }
}
