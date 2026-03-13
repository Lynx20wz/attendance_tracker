import '../models/student.dart';

/// Интерфейс репозитория для работы с данными студентов
abstract class StudentRepository {
  Future<List<Student>> load();
  Future<void> saveCache(final Set<Student> students);
  Future<void> saveStudentsFile(final Set<Student> students);
  Future<void> deleteCache();
}
