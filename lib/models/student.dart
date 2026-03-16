import 'package:flutter/material.dart';

import '../theme.dart';

Color getStatusColor(final StudentStatus status) {
  switch (status) {
    case StudentStatus.present:
      return AppColors.present;
    case StudentStatus.sick:
      return AppColors.sick;
    case StudentStatus.absent:
      return AppColors.absent;
    default:
      return AppColors.cardBackground;
  }
}

enum StudentStatus { present, absent, sick, unknown }

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
