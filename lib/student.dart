import 'package:flutter/material.dart';

import 'theme.dart';

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
  final String name;
  StudentStatus status = StudentStatus.unknown;

  Student(this.name, {this.status = StudentStatus.unknown});

  Map<String, String> toJson() => {'name': name, 'status': status.name};

  @override
  String toString() => toJson().toString();

  Student copyWith({String? name, StudentStatus? status}) =>
      Student(name ?? this.name, status: status ?? this.status);

  static Student fromJson(Map<String, dynamic> json) => Student(
    json['name']!,
    status: StudentStatus.values.byName(json['status']!),
  );
}
