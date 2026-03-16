import 'package:attendance_tracker/widgets/error_block.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme.dart';
import '../viewmodels/students_viewmodel.dart';
import '../widgets/student_widget.dart';
import 'stats_page.dart';
import 'students_editor.dart';

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
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const StatsPage()),
        ),
        child: const Text('List', style: TextStyle(fontSize: 24)),
      ),
      centerTitle: true,
      backgroundColor: AppColors.cardBackground,
      toolbarHeight: 50,
      leading: IconButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const StudentsEditor()),
        ),
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
              ? StudentWidget.empty()
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  separatorBuilder: (_, _) => const SizedBox(height: cardGap),
                  itemCount: students.length,
                  itemBuilder: (_, final i) =>
                      Center(child: StudentWidget(students.elementAt(i))),
                ),
        ),
  );
}
