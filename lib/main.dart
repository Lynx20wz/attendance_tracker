import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:presents/stats.dart';
import 'package:presents/student.dart';
import 'package:presents/theme.dart';

const cardGap = 8.0;

extension IsSameDay on DateTime {
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}

/// --- DATA SERVICE ---
class StudentRepository {
  Future<List<Student>> load() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/cache.json');

      if (await file.exists()) {
        final json = jsonDecode(await file.readAsString());
        final date = DateTime.fromMillisecondsSinceEpoch(json['timestamp']);
        if (date.isSameDay(DateTime.now())) {
          return [for (var s in json['students']) Student.fromJson(s)];
        }
      }
    } catch (_) {}
    final lines = (await rootBundle.loadString(
      'assets/students.txt',
    )).split('\n').map((line) => line.trim()).takeWhile((l) => l != '---');

    return [for (var student in lines) Student(student)];
  }

  Future<void> save(List<Student> students) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/cache.json');
      await file.writeAsString(
        jsonEncode({
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'students': [for (var s in students) s.toJson()],
        }),
      );
    } catch (e) {
      log('Cache save failed: $e');
    }
  }
}

/// --- APP ROOT ---
void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Presents',
    theme: AppTheme.darkTheme,
    debugShowCheckedModeBanner: false,
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
  List<Student>? students;

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
    if (state == AppLifecycleState.paused && students != null) {
      repo.save(students!);
    }
  }

  Future<void> _load() async {
    students = await repo.load();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (students == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          style: TextButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
            overlayColor: Colors.transparent,
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => StatsPage(students!)),
          ),
          child: const Text('List', style: TextStyle(fontSize: 24)),
        ),
        centerTitle: true,
        backgroundColor: AppColors.darkerGray,
        toolbarHeight: 50,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        color: AppColors.darkGray,
        child: ListView.separated(
          padding: const EdgeInsets.all(8),
          separatorBuilder: (_, _) => const SizedBox(height: cardGap),
          itemCount: students!.length,
          itemBuilder: (_, i) => Center(child: StudentWidget(students![i])),
        ),
      ),
    );
  }
}
