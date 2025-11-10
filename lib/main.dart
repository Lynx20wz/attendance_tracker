import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:presents/stats.dart';
import 'package:presents/student.dart';
import 'package:presents/theme.dart';

const cardGap = 8.0;

void main() => runApp(App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: AppTheme.darkTheme,
    debugShowCheckedModeBanner: false,
    title: 'Presents',
    home: HomePage(),
  );
}

class HomePage extends StatelessWidget {
  static List<Student> students = [];

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
          students = snapshot.data ?? [];
          return Container(
            margin: EdgeInsets.all(10),
            color: AppColors.darkGray,
            child: ListView(
              clipBehavior: Clip.none,
              children: [
                for (var student in students)
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

  log(lines.toString());
  return lines.map((line) => Student(line)).toList();
}
