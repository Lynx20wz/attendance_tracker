import 'package:flutter/material.dart';
import 'package:presents/student.dart';
import 'package:presents/theme.dart';

const _whiteText = TextStyle(color: Colors.white, fontSize: 20);

class StatsPage extends StatelessWidget {
  final Map<StudentStatus, List<Student>> statusCounts;

  StatsPage(List<Student>? students, {super.key})
    : statusCounts = {
        for (var status in StudentStatus.values)
          status:
              (students ?? [])
                  .where((s) => s.status == status)
                  .toList(growable: false)
                ..sort((a, b) => a.name.compareTo(b.name)),
      };

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Stats', style: TextStyle(fontSize: 24)),
      centerTitle: true,
      backgroundColor: AppColors.darkerGray,
      toolbarHeight: 50,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
    ),
    body: ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: StudentStatus.values.length,
      itemBuilder: (context, i) {
        final status = StudentStatus.values[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: StatsCard(statusCounts[status]!, status),
        );
      },
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

class _StatsCardState extends State<StatsCard>
    with SingleTickerProviderStateMixin {
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
        onPressed: () => setState(() => _isExpanded = !_isExpanded),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.status.name, style: _whiteText),
            Text(
              '${widget.students.length}',
              style: _whiteText.copyWith(fontSize: 24),
            ),
          ],
        ),
      ),
      AnimatedSize(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: ConstrainedBox(
          constraints: _isExpanded
              ? const BoxConstraints()
              : const BoxConstraints(maxHeight: 0),
          child: Container(
            width: 300,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(10),
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.students.isNotEmpty
                  ? widget.students
                        .map((s) => Text(s.name, style: _whiteText))
                        .toList()
                  : const [Text('No students', style: _whiteText)],
            ),
          ),
        ),
      ),
    ],
  );
}
