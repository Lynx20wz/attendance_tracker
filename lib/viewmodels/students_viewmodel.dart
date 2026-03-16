import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/student.dart';
import '../repositories/student_repository.dart';
import '../repositories/student_repository_impl.dart';

final studentRepositoryProvider = Provider<StudentRepository>(
  (_) => StudentRepositoryImpl(),
);

final studentsProvider = AsyncNotifierProvider<StudentsViewModel, Set<Student>>(
  StudentsViewModel.new,
);

class StudentsViewModel extends AsyncNotifier<Set<Student>> {
  late final StudentRepository _repository;

  @override
  Future<Set<Student>> build() async {
    _repository = ref.watch(studentRepositoryProvider);
    return _sortStudents(await _load());
  }

  void deleteCache() => _repository.deleteCache();

  Map<StudentStatus, List<Student>> getStudentStatuses() => state
      .whenData(
        (final students) => {
          for (var status in StudentStatus.values)
            status:
                students
                    .where((final s) => s.status == status)
                    .toList(growable: false)
                  ..sort((final a, final b) => a.name.compareTo(b.name)),
        },
      )
      .value!;

  void removeStudent(final Student student) => state.whenData((final students) {
    final updated = students
        .where((final s) => s.name != student.name)
        .toList();
    state = AsyncValue.data(_sortStudents(updated));
  });

  void resetStatus() {
    state = state.whenData(
      (final students) => _sortStudents(
        students
            .map((final s) => s.copyWith(status: StudentStatus.unknown))
            .toList(),
      ),
    );
    saveCache();
  }

  Future<void> saveCache() async => state.when(
    data: (final students) async => await _repository.saveCache(students),
    error: (final e, _) => log('Failed to save students: $e'),
    loading: () => null,
  );

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

  void updateStudentStatus(final Student student, final StudentStatus status) =>
      state = state.whenData(
        (final students) => _sortStudents(
          students
              .map(
                (final s) =>
                    s.name == student.name ? s.copyWith(status: status) : s,
              )
              .toList(),
        ),
      );

  Future<List<Student>> _load() async {
    final cache = await _repository.loadCache();
    if (cache != null && cache.isToday && cache.students.isNotEmpty) {
      return cache.students;
    }

    return await _repository.loadDefaults();
  }

  Set<Student> _sortStudents(final List<Student> students) {
    students.sort((final a, final b) => a.name.compareTo(b.name));
    return students.toSet();
  }
}
