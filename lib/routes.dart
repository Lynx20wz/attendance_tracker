import 'package:flutter/material.dart' show Widget;

import 'package:attendance_tracker/pages/pages.dart';

enum AppRoutes {
  home('/', HomePage()),
  editor('/editor', EditorPage()),
  stats('/stats', StatsPage());

  final String path;
  final Widget page;
  const AppRoutes(this.path, this.page);
}
