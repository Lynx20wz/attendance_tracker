import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/students_viewmodel.dart';
import '../models/student.dart';
import '../theme.dart';
import '../viewmodels/students_viewmodel.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Stats', style: TextStyle(fontSize: 24)),
      centerTitle: true,
      backgroundColor: AppColors.darkerGray,
      toolbarHeight: 50,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
    ),
    body: Consumer(
      builder: (_, final ref, _) => ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: StudentStatus.values.length,
        itemBuilder: (final context, final i) {
          final status = StudentStatus.values[i];
          final students = ref
              .read(studentsProvider.notifier)
              .getStudentStatuses()[status]!;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: StatsCard(students, status),
          );
        },
      ),
    ),
  );
}

class StatsCard extends StatefulWidget {
  final List<Student> students;
  final StudentStatus status;
  final Color color;

  StatsCard(this.students, this.status, {super.key})
    : color = getStatusColor(status);

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(final BuildContext context) => Column(
    children: [
      TextButton(
        style: TextButton.styleFrom(
          backgroundColor: widget.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () => setState(() => _isExpanded = !_isExpanded),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.status.name, style: _whiteText),
            Text(
              '${widget.students.length}',
              style: _whiteText.copyWith(fontSize: 24),
            ),
          ],
        ),
      ),
      AnimatedSize(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: ConstrainedBox(
          constraints: _isExpanded
              ? const BoxConstraints()
              : const BoxConstraints(maxHeight: 0),
          child: Container(
            width: 300,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(10),
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.students.isNotEmpty
                  ? widget.students
                        .map((final s) => Text(s.name, style: _whiteText))
                        .toList()
                  : const [Text('No students', style: _whiteText)],
            ),
          ),
        ),
      ),
    ],
  );
}
