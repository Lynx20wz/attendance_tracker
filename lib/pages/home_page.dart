import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:attendance_tracker/routes.dart';
import 'package:attendance_tracker/viewmodels/students_viewmodel.dart';
import 'package:attendance_tracker/widgets/widgets.dart';

const cardGap = 8.0;

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: AppBar(
      title: TextButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.stats.path),
        child: const Text('List', style: TextStyle(fontSize: 24)),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.editor.path),
        icon: Icon(Icons.list_alt),
      ),
      actions: [
        IconButton(
          onPressed: () {
            ref.read(studentsProvider.notifier).resetStatus();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Center(
                  child: Text('Statuses reset', style: TextStyle(fontSize: 18)),
                ),
              ),
            );
          },
          icon: const Icon(Icons.replay_outlined, size: 24),
        ),
      ],
    ),
    body: ref
        .watch(studentsProvider)
        .when(
          loading: () => const CircularProgressIndicator(),
          error: (final error, final stackTrace) =>
              ErrorBlock(error, stackTrace: stackTrace),
          data: (final students) => students.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  separatorBuilder: (_, _) => const SizedBox(height: cardGap),
                  itemCount: students.length,
                  itemBuilder: (_, final i) =>
                      Center(child: StudentCard(students.elementAt(i))),
                ),
        ),
  );

  Widget _buildEmptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.people_outline, size: 80, color: Colors.white30),
        Text(
          'No students',
          style: TextStyle(color: Colors.white60, fontSize: 20),
        ),
        Text(
          'Go to the edit page to add students',
          style: TextStyle(color: Colors.white30, fontSize: 14),
        ),
      ],
    ),
  );
}
