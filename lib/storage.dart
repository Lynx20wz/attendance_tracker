import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'ext/is_same_day.dart';
import 'student.dart';

class StudentRepository {
  Future<List<Student>> load() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/cache.json');

      if (await file.exists()) {
        final json = jsonDecode(await file.readAsString());

        final date = DateTime.fromMillisecondsSinceEpoch(json['timestamp']);
        if (date.isSameDay(DateTime.now()) && json['students'].length > 0) {
          return [for (var s in json['students']) Student.fromJson(s)];
        }
      }
    } catch (_) {}
    final lines = (await rootBundle.loadString(
      'assets/students.txt',
    )).split('\n').map((line) => line.trim()).takeWhile((l) => l != '---');

    return [for (var student in lines) Student(student)];
  }

  Future<void> save(List<Student> students) async {
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
}
