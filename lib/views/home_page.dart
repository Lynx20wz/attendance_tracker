import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/students_viewmodel.dart';
import '../views/stats_page.dart';
import '../views/students_editor.dart';
import '../widgets/student_widget.dart';
import '../theme.dart';

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
      backgroundColor: AppColors.darkerGray,
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
                  child: Text(
                    'Статусы сброшены',
                    style: TextStyle(fontSize: 18),
                  ),
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
          error: (final error, _) => Text(error.toString()),
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
