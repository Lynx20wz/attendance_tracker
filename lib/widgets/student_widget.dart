import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/student.dart';
import '../theme.dart';
import '../viewmodels/students_viewmodel.dart';

const cardHeight = 60.0;
const cardWidth = 355.0;

class StudentWidget extends ConsumerStatefulWidget {
  final Student? student;
  final bool isEmpty;

  const StudentWidget.empty({super.key}) : student = null, isEmpty = true;
  const StudentWidget(this.student, {super.key}) : isEmpty = false;

  @override
  ConsumerState<StudentWidget> createState() => _StudentWidgetState();
}

class _StudentWidgetState extends ConsumerState<StudentWidget> {
  double _dragOffset = 0.0;

  void setStudentStatus(final StudentStatus status) {
    ref
        .read(studentsProvider.notifier)
        .updateStudentStatus(widget.student!, status);
  }

  @override
  Widget build(final BuildContext context) => widget.isEmpty
      ? Container(
          width: cardWidth,
          height: cardHeight,
          decoration: BoxDecoration(
            color: AppColors.darkerGray,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: const Text(
            'No data',
            style: TextStyle(color: Colors.white70, fontSize: 22),
          ),
        )
      : GestureDetector(
          onHorizontalDragUpdate: (final details) {
            setState(() {
              _dragOffset += details.delta.dx;
              _dragOffset = _dragOffset.clamp(-50.0, 50.0);
            });
          },
          onHorizontalDragEnd: (_) {
            setStudentStatus(
              _dragOffset >= 50 ? StudentStatus.sick : StudentStatus.absent,
            );

            _startSmoothReturn(delay: 50);
          },
          child: Stack(
            children: [
              if (_dragOffset.abs() > 1)
                Container(
                  width: cardWidth,
                  height: cardHeight,
                  decoration: BoxDecoration(
                    color: _dragOffset > 0
                        ? AppColors.sick.withAlpha(
                            _dragOffset.abs().toInt() * 5,
                          )
                        : AppColors.absent.withAlpha(
                            _dragOffset.abs().toInt() * 5,
                          ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    alignment: _dragOffset > 0
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    width: cardWidth,
                    height: cardHeight,
                    child: Icon(
                      _dragOffset > 0 ? Icons.masks : Icons.directions_run,
                      size: 32,
                      color: Color.fromARGB(
                        _dragOffset.abs().toInt() * 5,
                        255,
                        255,
                        255,
                      ),
                    ),
                  ),
                ),
              Transform.translate(
                offset: Offset(_dragOffset, 0),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: cardWidth,
                  height: cardHeight,
                  decoration: BoxDecoration(
                    color: getStatusColor(widget.student!.status),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      widget.student!.name,
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    ),
                    onPressed: () => setStudentStatus(StudentStatus.present),
                    onLongPress: () => setStudentStatus(StudentStatus.unknown),
                  ),
                ),
              ),
            ],
          ),
        );

  void _startSmoothReturn({
    final int steps = 100,
    final int totalDuration = 200,
    final int delay = 0,
  }) {
    Future.delayed(Duration(milliseconds: delay));
    for (int i = 0; i < steps; i++) {
      Future.delayed(Duration(milliseconds: i * (totalDuration ~/ steps)), () {
        if (mounted) {
          setState(() => _dragOffset += _dragOffset > 0 ? -1 : 1);
        }
      });
    }
  }
}
