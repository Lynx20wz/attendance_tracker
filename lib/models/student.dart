import 'package:flutter/material.dart' show Color;

import 'package:attendance_tracker/theme.dart';

enum StudentStatus { present, absent, sick, unknown }

final statusColors = <StudentStatus, Color>{
  StudentStatus.present: AppColors.present,
  StudentStatus.sick: AppColors.sick,
  StudentStatus.absent: AppColors.absent,
  StudentStatus.unknown: AppColors.cardBackground,
};

class Student {
  final String name;
  StudentStatus status;

  Student(this.name, {this.status = StudentStatus.unknown});

  Map<String, String> toJson() => {'name': name, 'status': status.name};

  @override
  String toString() => 'Student(name: $name, status: $status)';

  Student copyWith({final String? name, final StudentStatus? status}) =>
      Student(name ?? this.name, status: status ?? this.status);

  static Student fromJson(final Map<String, dynamic> json) => Student(
    json['name']!,
    status: StudentStatus.values.byName(json['status']!),
  );

  @override
  bool operator ==(final Object other) =>
      other is Student && hashCode == other.hashCode;

  @override
  int get hashCode => name.hashCode ^ status.hashCode;
}
