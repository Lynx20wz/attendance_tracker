import 'dart:developer' show log;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:attendance_tracker/viewmodels/students_viewmodel.dart';
import 'package:attendance_tracker/views/home_page.dart';
import 'theme.dart';

void main() => runApp(ProviderScope(child: const App()));

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      ref.read(studentsProvider.notifier).saveCache();
      log('Students saved');
    }
  }

  @override
  Widget build(final BuildContext context) => MaterialApp(
    title: 'Attendance Tracker',
    theme: AppTheme.darkTheme,
    home: const HomePage(),
  );
}
