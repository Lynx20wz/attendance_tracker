import 'dart:developer' show log;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:attendance_tracker/routes.dart';
import 'package:attendance_tracker/theme.dart';
import 'package:attendance_tracker/viewmodels/students_viewmodel.dart';

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
    routes: {
      for (final route in AppRoutes.values) route.path: (_) => route.page,
    },
    title: 'Attendance Tracker',
    theme: AppTheme.darkTheme,
  );
}
