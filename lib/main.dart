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

void main() => runApp(App());

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    loadFromCache();

    _listener = AppLifecycleListener(onPause: saveToCache);
  }

  @override
  void dispose() {
    _listener.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: AppTheme.darkTheme,
    debugShowCheckedModeBanner: false,
    title: 'Presents',
    home: HomePage(),
  );

  Future<void> saveToCache() async {
    log("---SAVE---");
    try {
      final Map<String, dynamic> json = {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'students': [
          for (final student in HomePage.students ?? []) student.toJson(),
        ],
      };
      final directory = await getApplicationDocumentsDirectory();
      log(directory.path);
      final file = File('${directory.path}/cache.json');

      await file.writeAsString(jsonEncode(json));
    } catch (e) {
      print('Failed to save cache: $e');
    }
  }

  Future<void> loadFromCache() async {
    log("---LOAD---");
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/cache.json');

      final json =
          jsonDecode(await file.readAsString()) as Map<String, dynamic>;

      if (DateTime.fromMillisecondsSinceEpoch(
        json['timestamp'],
      ).isSameDay(DateTime.now())) {
        HomePage.students = [
          for (var student in json['students']) Student.fromJson(student),
        ];
      }
    } catch (e) {
      print('Failed to load cache: $e');
    } finally {
      log("---END-LOAD---");
    }
  }
}

class HomePage extends StatelessWidget {
  static List<Student>? students;

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: TextButton(
        style: TextButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          overlayColor: Colors.transparent,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StatsPage(students)),
          );
        },
        child: Text('List', style: TextStyle(fontSize: 24)),
      ),
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
      child: FutureBuilder<List<Student>>(
        future: getStudents(),
        builder: (context, snapshot) {
          students = students ?? snapshot.data;
          return Container(
            margin: EdgeInsets.all(10),
            color: AppColors.darkGray,
            child: ListView(
              clipBehavior: Clip.none,
              children: [
                for (var student in students ?? [])
                  Padding(
                    padding: EdgeInsetsGeometry.only(bottom: cardGap),
                    child: Center(child: StudentWidget(student)),
                  ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

Future<List<Student>> getStudents() async {
  final lines = (await rootBundle.loadString(
    'assets/students.txt',
  )).split('\n').map((line) => line.trim()).takeWhile((line) => line != '---');
  return lines.map((line) => Student(line)).toList();
}
