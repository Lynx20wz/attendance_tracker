import 'package:presents/student.dart';

extension ResetStatus on List<Student> {
  void resetStatus() =>
      forEach((student) => student.status = StudentStatus.unknown);
}
