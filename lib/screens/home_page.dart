import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:attendance_tracker/providers.dart';
import 'package:attendance_tracker/screens/stats.dart';
import 'package:attendance_tracker/theme.dart';
import 'package:attendance_tracker/student.dart';

const cardGap = 8.0;

/// --- HOME PAGE ---
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) => ref
      .watch(studentsProvider)
      .when(
        loading: () => CircularProgressIndicator(),
        error: (error, _) => Text(error.toString()),
        data: (students) => Scaffold(
          appBar: AppBar(
            title: TextButton(
              style: TextButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
                overlayColor: Colors.transparent,
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StatsPage()),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text('List', style: TextStyle(fontSize: 24)),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() {
                      ref.read(studentsProvider.notifier).resetStatus();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Center(
                            child: Text(
                              'Статусы сброшены',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      );
                      ref.read(studentsProvider.notifier).save();
                    }),
                    icon: Icon(Icons.replay_outlined, size: 24),
                  ),
                ],
              ),
            ),
            backgroundColor: AppColors.darkerGray,
            toolbarHeight: 50,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
          ),
          body: Container(
            margin: const EdgeInsets.all(10),
            color: AppColors.darkGray,
            child: students.isEmpty
                ? StudentWidget.empty()
                : ListView.separated(
                    padding: const EdgeInsets.all(8),
                    separatorBuilder: (_, _) => const SizedBox(height: cardGap),
                    itemCount: students.length,
                    itemBuilder: (_, i) =>
                        Center(child: StudentWidget(students.elementAt(i))),
                  ),
          ),
        ),
      );
}
