import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:attendance_tracker/models/student.dart';
import 'package:attendance_tracker/theme.dart';
import 'package:attendance_tracker/viewmodels/students_viewmodel.dart';
import 'package:attendance_tracker/widgets/student_dialog.dart';

class EditorCard extends ConsumerStatefulWidget {
  final Student student;

  const EditorCard({required this.student, super.key});

  @override
  ConsumerState<EditorCard> createState() => _EditorCardState();
}

class _EditorCardState extends ConsumerState<EditorCard> {
  bool _isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.student.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => Dismissible(
    key: Key(widget.student.name),
    direction: DismissDirection.endToStart,
    dismissThresholds: <DismissDirection, double>{
      DismissDirection.endToStart: 0.3,
    },
    background: Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: AppColors.absent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
    ),
    confirmDismiss: (_) async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.cardBackground,
          title: const Text(
            'Remove student?',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            widget.student.name,
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: AppColors.absent),
              child: const Text('Remove'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        ref.read(studentsProvider.notifier).removeStudent(widget.student);
        ref.read(studentsProvider.notifier).saveCache();
      }

      return confirmed ?? false;
    },
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: _isEditing
                  ? TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.white54),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                      onSubmitted: (_) => _saveEdit(),
                    )
                  : Text(
                      widget.student.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isEditing) ...[
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.white),
                    onPressed: _saveEdit,
                    tooltip: 'Save',
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: _cancelEdit,
                    tooltip: 'Cancel',
                  ),
                ] else ...[
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white70),
                    onPressed: () => _showEditDialog(context),
                    tooltip: 'Edit',
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    ),
  );

  void _showEditDialog(final BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => StudentDialog(
        title: 'Edit',
        controller: _controller,
        onConfirm: _saveEdit,
      ),
    );
  }

  void _saveEdit() {
    final newName = _controller.text.trim();
    if (newName.isNotEmpty && newName != widget.student.name) {
      ref
          .read(studentsProvider.notifier)
          .updateStudent(
            Student(newName, status: widget.student.status),
            widget.student.name,
          );
      ref.read(studentsProvider.notifier).saveCache();
    }
    setState(() => _isEditing = false);
  }

  void _cancelEdit() {
    setState(() => _isEditing = false);
    _controller.text = widget.student.name;
  }
}
