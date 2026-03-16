import 'package:flutter/material.dart';

import 'package:attendance_tracker/theme.dart';

class StudentDialog extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final VoidCallback onConfirm;

  const StudentDialog({
    required this.title,
    required this.controller,
    required this.onConfirm,
    super.key,
  });

  @override
  Widget build(final BuildContext context) => AlertDialog(
    backgroundColor: AppColors.cardBackground,
    title: Text(title, style: const TextStyle(color: Colors.white)),
    content: TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Student name',
        hintStyle: const TextStyle(color: Colors.white54),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
      ),
      onSubmitted: (_) => onConfirm(),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          onConfirm();
          Navigator.pop(context);
        },
        style: TextButton.styleFrom(foregroundColor: AppColors.present),
        child: const Text('OK'),
      ),
    ],
  );
}
