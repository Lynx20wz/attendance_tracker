import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../models/student.dart';
import '../ext/is_same_day.dart';
import 'student_repository.dart';

class StudentRepositoryImpl implements StudentRepository {
  @override
  Future<List<Student>> load() async {
    final dir = await getApplicationDocumentsDirectory();

    log('Loading students from cache... ($dir');

    final file = File('${dir.path}/cache.json');

    if (await file.exists()) {
      final json = jsonDecode(await file.readAsString());

      final date = DateTime.fromMillisecondsSinceEpoch(json['timestamp']);
      if (date.isSameDay(DateTime.now()) && json['students'].length > 0) {
        return [for (var s in json['students']) Student.fromJson(s)];
      }
      await deleteCache(); // if exists, but stale
    }

    final lines = (await rootBundle.loadString('assets/students.txt'))
        .split('\n')
        .map((final line) => line.trim())
        .takeWhile((final l) => l != '---');

    return [for (var student in lines) Student(student)];
  }

  @override
  Future<void> deleteCache() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/cache.json');
    if (await file.exists()) await file.delete();
  }

  @override
  Future<void> saveCache(final Set<Student> students) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/cache.json');
      await file.writeAsString(
        jsonEncode({
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'students': [for (var s in students) s.toJson()],
        }),
      );
    } catch (e) {
      log('Cache save failed: $e');
    }
  }

  @override
  Future<void> saveStudentsFile(final Set<Student> students) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/students.json');
      await file.writeAsString(students.map((final s) => s.name).join('\n'));
    } catch (e) {
      log('Students file save failed: $e');
    }
  }
}
