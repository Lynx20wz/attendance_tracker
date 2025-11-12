import 'dart:developer';

import 'package:flutter/material.dart';

import 'ext/reset_status.dart';
import 'stats.dart';
import 'storage.dart';
import 'student.dart';
import 'theme.dart';

const cardGap = 8.0;

/// --- APP ROOT ---
void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Presents',
    theme: AppTheme.darkTheme,
    home: const HomePage(),
  );
}

/// --- HOME PAGE ---
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final repo = StudentRepository();
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      repo.save(students);
      log('Students saved: $students');
    }
  }

  Future<void> _load() async {
    students = await repo.load();
    log('Students loaded: $students');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: TextButton(
        style: TextButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          overlayColor: Colors.transparent,
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => StatsPage(students)),
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
                students.resetStatus();
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
                repo.save(students);
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
              itemBuilder: (_, i) => Center(child: StudentWidget(students[i])),
            ),
    ),
  );
}
