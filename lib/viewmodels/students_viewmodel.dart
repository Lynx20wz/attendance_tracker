import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/student.dart';
import '../repositories/student_repository.dart';
import '../repositories/student_repository_impl.dart';

final studentsProvider =
    AsyncNotifierProvider<StudentsViewModel, Set<Student>>(StudentsViewModel.new);

class StudentsViewModel extends AsyncNotifier<Set<Student>> {
  late final StudentRepository _repository;

  @override
  Future<Set<Student>> build() async {
    _repository = ref.watch(studentRepositoryProvider);
    return _sortStudents(await _repository.load());
  }

  /// Сохранение данных
  Future<void> save() async {
    state.when(
      data: (final students) async {
        await _repository.saveCache(students);
        await _repository.saveStudentsFile(students);
      },
      error: (final e, _) => log('Failed to save students: $e'),
      loading: () => null,
    );
  }

  /// Сортировка студентов по имени
  Set<Student> _sortStudents(final List<Student> students) {
    students.sort((final a, final b) => a.name.compareTo(b.name));
    return students.toSet();
  }

  /// Обновление статуса студента
  void updateStudentStatus(final Student student, final StudentStatus status) {
    state = state.whenData(
      (final students) => _sortStudents(
        students
            .map((final s) => s.name == student.name ? s.copyWith(status: status) : s)
            .toList(),
      ),
    );
  }

  /// Обновление или добавление студента
  void updateStudent(final Student student, [final String oldName = '']) {
    if (student.name.isEmpty) return;

    state.whenData((final students) {
      final updated = List<Student>.from(students);

      if (oldName.isNotEmpty) {
        updated.removeWhere((final s) => s.name == oldName);
      }

      updated.add(student);
      state = AsyncValue.data(_sortStudents(updated));
    });
  }

  /// Удаление студента
  void removeStudent(final Student student) {
    state.whenData((final students) {
      final updated = students.where((final s) => s.name != student.name).toList();
      state = AsyncValue.data(_sortStudents(updated));
    });
  }

  /// Получение студентов, сгруппированных по статусам
  Map<StudentStatus, List<Student>> getStudentStatuses() =>
      state.whenData((final students) => {
          for (var status in StudentStatus.values)
            status: students
                .where((final s) => s.status == status)
                .toList(growable: false)
              ..sort((final a, final b) => a.name.compareTo(b.name)),
        }).value!;

  /// Сброс всех статусов
  void resetStatus() {
    state = state.whenData(
      (final students) => _sortStudents(
        students.map((final s) => s.copyWith(status: StudentStatus.unknown)).toList(),
      ),
    );
    save();
  }
}

/// Провайдер репозитория
final studentRepositoryProvider = Provider<StudentRepository>(
  (_) => StudentRepositoryImpl(),
);
