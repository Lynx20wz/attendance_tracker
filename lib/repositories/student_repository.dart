import 'package:attendance_tracker/models/cache.dart';
import 'package:attendance_tracker/models/student.dart';

abstract class StudentRepository {
  Future<Cache?> loadCache();
  Future<List<Student>> loadDefaults();
  Future<void> saveCache(final Set<Student> students);
  Future<void> saveStudentsFile(final Set<Student> students);
  Future<void> deleteCache();
}
