import 'package:flutter/material.dart';
import 'package:presents/student.dart';
import 'package:presents/theme.dart';

class StatsPage extends StatelessWidget {
  final List<Student> students;

  const StatsPage(this.students, {super.key});

  Map<StudentStatus, List<Student>> get statusCounts {
    final count = <StudentStatus, List<Student>>{};
    for (var status in StudentStatus.values) {
      count[status] = students
          .where((student) => student.status == status)
          .toList();
    }
    return count;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Stats', style: TextStyle(fontSize: 24)),
      centerTitle: true,
      backgroundColor: AppColors.darkerGray,
      toolbarHeight: 50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
    ),
    body: Center(
      child: Container(
        margin: EdgeInsets.all(10),
        child: ListView(
          children: [
            for (var status in StudentStatus.values)
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: StatsCard(statusCounts[status]!, status),
              ),
          ],
        ),
      ),
    ),
  );
}

class StatsCard extends StatefulWidget {
  final List<Student> students;
  final StudentStatus status;
  final Color color;

  StatsCard(this.students, this.status, {super.key})
    : color = getStatusColor(status);

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      TextButton(
        style: TextButton.styleFrom(
          backgroundColor: widget.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.status.toString().split('.').last,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Text(
              widget.students.length.toString(),
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ],
        ),
      ),

      if (_isExpanded) ...[
        Container(
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          width: 300,
          padding: EdgeInsets.all(12),
          child: Column(
            children: widget.students.isNotEmpty
                ? [
                    for (var student in widget.students)
                      Text(
                        student.name,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                  ]
                : [
                    Text(
                      'No students',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
          ),
        ),
      ],
    ],
  );
}
