import 'package:flutter/material.dart';

import 'package:attendance_tracker/models/student.dart';
import 'package:attendance_tracker/theme.dart';

class StatsCard extends StatefulWidget {
  final List<Student> students;
  final StudentStatus status;
  final Color color;

  StatsCard(this.students, this.status, {super.key})
    : color = statusColors[status] ?? AppColors.cardBackground;

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  IconData get _statusIcon {
    switch (widget.status) {
      case StudentStatus.present:
        return Icons.check_circle_outline;
      case StudentStatus.sick:
        return Icons.sick_outlined;
      case StudentStatus.absent:
        return Icons.cancel_outlined;
      default:
        return Icons.help_outline;
    }
  }

  Duration get _calculateAnimatationDuration =>
      Duration(milliseconds: (widget.students.length * 25).clamp(50, 300));

  @override
  Widget build(final BuildContext context) {
    final count = widget.students.length;
    final hasStudents = count > 0;

    return Container(
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                spacing: 10,
                children: [
                  Icon(_statusIcon, color: Colors.white, size: 28),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.status.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        hasStudents ? '$count students' : 'No students',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: _calculateAnimatationDuration,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white.withValues(alpha: 0.7),
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: _calculateAnimatationDuration,
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 8),
                  if (hasStudents)
                    ...widget.students.map(
                      (final student) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          student.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Text(
                          'Empty list',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
