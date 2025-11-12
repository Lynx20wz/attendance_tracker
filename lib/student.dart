import 'dart:io';

import 'package:flutter/material.dart';
import 'package:presents/theme.dart';

final cardHeight = 60.0;
final cardWidth = 355.0;

Color getStatusColor(StudentStatus status) {
  switch (status) {
    case StudentStatus.present:
      return AppColors.present;
    case StudentStatus.sick:
      return AppColors.sick;
    case StudentStatus.absent:
      return AppColors.absent;
    default:
      return AppColors.darkerGray;
  }
}

enum StudentStatus { present, absent, sick, unknown }

class Student {
  String name;
  StudentStatus status = StudentStatus.unknown;

  Student(this.name, {this.status = StudentStatus.unknown});

  Map<String, String> toJson() => {'name': name, 'status': status.name};

  @override
  String toString() => toJson().toString();

  static Student fromJson(Map<String, dynamic> json) => Student(
    json['name']!,
    status: StudentStatus.values.byName(json['status']!),
  );
}

extension ResetStatus on List<Student> {
  void resetStatus() =>
      forEach((student) => student.status = StudentStatus.unknown);
}

class StudentWidget extends StatefulWidget {
  final Student? student;
  final bool isEmpty;

  const StudentWidget.empty({super.key}) : student = null, isEmpty = true;
  const StudentWidget(this.student, {super.key}) : isEmpty = false;

  @override
  State<StudentWidget> createState() => _StudentWidgetState();
}

class _StudentWidgetState extends State<StudentWidget> {
  double _dragOffset = 0.0;

  @override
  Widget build(BuildContext context) => widget.isEmpty
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
          onHorizontalDragUpdate: (details) {
            setState(() {
              _dragOffset += details.delta.dx;
              _dragOffset = _dragOffset.clamp(-50.0, 50.0);
            });
          },
          onHorizontalDragEnd: (details) {
            setState(
              () => widget.student!.status = _dragOffset >= 50
                  ? StudentStatus.sick
                  : StudentStatus.absent,
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
                    onPressed: () => setState(
                      () => widget.student!.status = StudentStatus.present,
                    ),
                    onLongPress: () => setState(
                      () => widget.student!.status = StudentStatus.unknown,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

  void _startSmoothReturn({
    int steps = 100,
    int totalDuration = 200,
    int delay = 0,
  }) {
    sleep(Duration(milliseconds: delay));
    for (int i = 0; i < steps; i++) {
      Future.delayed(Duration(milliseconds: i * (totalDuration ~/ steps)), () {
        if (mounted) {
          setState(() => _dragOffset += _dragOffset > 0 ? -1 : 1);
        }
      });
    }
  }
}
