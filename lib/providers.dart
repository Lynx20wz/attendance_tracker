import 'package:riverpod/riverpod.dart';

import 'storage.dart';
import 'student.dart';

final studentsProvider = AsyncNotifierProvider<StudentsNotifier, Set<Student>>(
  StudentsNotifier.new,
);

class StudentsNotifier extends AsyncNotifier<Set<Student>> {
  late final StudentRepository _repo;

  @override
  Future<Set<Student>> build() async {
    _repo = ref.watch(studentRepositoryProvider);
    return await _repo.load();
  }

  Future<void> save() async {
    try {
      await _repo.save(state.value!);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void updateStudentStatus(Student student, StudentStatus status) {
    state = state.whenData(
      (students) => students
          .map((s) => s.name == student.name ? s.copyWith(status: status) : s)
          .toSet(),
    );
  }

  Map<StudentStatus, List<Student>> getStudentStatuses() => state
      .whenData(
        (students) => {
          for (var status in StudentStatus.values)
            status:
                (students)
                    .where((s) => s.status == status)
                    .toList(growable: false)
                  ..sort((a, b) => a.name.compareTo(b.name)),
        },
      )
      .value!;

  void resetStatus() {
    state = state.whenData(
      (students) => students
          .map((s) => s.copyWith(status: StudentStatus.unknown))
          .toSet(),
    );
  }
}

final studentRepositoryProvider = Provider<StudentRepository>(
  (_) => StudentRepository(),
);
