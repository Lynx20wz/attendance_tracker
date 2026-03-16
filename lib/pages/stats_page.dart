import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:attendance_tracker/models/student.dart';
import 'package:attendance_tracker/viewmodels/students_viewmodel.dart';
import 'package:attendance_tracker/widgets/widgets.dart' show StatsCard;

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Stats',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
    body: Consumer(
      builder: (_, final ref, _) => ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: StudentStatus.values.length,
        itemBuilder: (final context, final i) {
          final status = StudentStatus.values[i];
          final students = ref
              .read(studentsProvider.notifier)
              .studentStatuses[status]!;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: StatsCard(students, status),
          );
        },
      ),
    ),
  );
}
