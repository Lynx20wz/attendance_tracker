import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:attendance_tracker/models/student.dart';
import 'package:attendance_tracker/viewmodels/students_viewmodel.dart';

import 'package:attendance_tracker/widgets/widgets.dart'
    show EditorCard, StudentDialog;

class EditorPage extends ConsumerWidget {
  const EditorPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) => Scaffold(
    appBar: AppBar(
      title: const Text('Editor', style: TextStyle(fontSize: 24)),
      actions: [
        IconButton(
          onPressed: () => _showAddStudentDialog(context, ref),
          icon: const Icon(Icons.add),
        ),
      ],
    ),
    body: ref
        .watch(studentsProvider)
        .when(
          data: (final students) => students.isEmpty
              ? _buildEmptyState(context)
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemCount: students.length,
                  itemBuilder: (_, final i) =>
                      EditorCard(student: students.elementAt(i)),
                ),
          error: (final error, final stackTrace) => _buildErrorState(error),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
  );

  Widget _buildEmptyState(final BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.people_outline, size: 80, color: Colors.white30),
        Text(
          'No students',
          style: TextStyle(color: Colors.white60, fontSize: 20),
        ),
        Text(
          'Tap + to add',
          style: TextStyle(color: Colors.white30, fontSize: 14),
        ),
      ],
    ),
  );

  Widget _buildErrorState(final Object error) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 60, color: Colors.red),
        const SizedBox(height: 16),
        Text(
          'Exceptions: $error',
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  void _showAddStudentDialog(final BuildContext context, final WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => StudentDialog(
        title: 'New student',
        controller: controller,
        onConfirm: () {
          if (controller.text.trim().isNotEmpty) {
            ref
                .read(studentsProvider.notifier)
                .updateStudent(Student(controller.text.trim()));
            ref.read(studentsProvider.notifier).saveCache();
          }
        },
      ),
    );
  }
}
