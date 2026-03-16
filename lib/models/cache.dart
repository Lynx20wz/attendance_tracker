import 'package:attendance_tracker/models/student.dart';

class Cache {
  final DateTime timestamp;
  final List<Student> students;

  Cache({required this.timestamp, required this.students});

  factory Cache.fromJson(final Map<String, dynamic> json) => Cache(
    timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
    students: (json['students'] as List<dynamic>)
        .map((final dynamic s) => Student.fromJson(s as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp,
    'students': students,
  };

  @override
  String toString() => 'Cache(timestamp: $timestamp, students: $students)';

  @override
  bool operator ==(final Object other) =>
      other is Cache && hashCode == other.hashCode;

  @override
  int get hashCode => timestamp.hashCode ^ students.hashCode;

  bool get isToday {
    final today = DateTime.now();
    return timestamp.year == today.year &&
        timestamp.month == today.month &&
        timestamp.day == today.day;
  }
}
