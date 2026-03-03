import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:presents/providers.dart';
import 'package:presents/screens/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme.dart';

/// --- APP ROOT ---
void main() => runApp(ProviderScope(child: const App()));

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      ref.read(studentsProvider.notifier).save();
      log('Students saved');
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Presents',
    theme: AppTheme.darkTheme,
    home: const HomePage(),
  );
}
