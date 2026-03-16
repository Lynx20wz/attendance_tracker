import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';

import 'package:attendance_tracker/models/cache.dart';
import 'package:attendance_tracker/models/student.dart';
import 'package:attendance_tracker/repositories/student_repository.dart';

class StudentRepositoryImpl implements StudentRepository {
  @override
  Future<Cache?> loadCache() async {
    final dir = await getApplicationDocumentsDirectory();

    log('Loading students from cache... ($dir');

    final file = File('${dir.path}/cache.json');

    if (await file.exists()) {
      final json = jsonDecode(await file.readAsString());
      log('Cache loaded: $json');
      return Cache.fromJson(json);
    }

    return null;
  }

  @override
  Future<List<Student>> loadDefaults() async {
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
