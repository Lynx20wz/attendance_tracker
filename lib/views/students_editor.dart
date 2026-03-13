import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/students_viewmodel.dart';
import '../models/student.dart';
import '../theme.dart';

class StudentsEditor extends ConsumerWidget {
  const StudentsEditor({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Редактор',
            style: TextStyle(fontSize: 24),
          ),
          centerTitle: true,
          backgroundColor: AppColors.darkerGray,
          toolbarHeight: 50,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20)),
          ),
        ),
        body: ref.watch(studentsProvider).when(
              data: (final students) => students.isEmpty
                  ? _buildEmptyState(context)
                  : ListView.separated(
                      padding: const EdgeInsets.all(12),
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemCount: students.length,
                      itemBuilder: (_, final i) => _StudentEditorCard(
                        student: students.elementAt(i),
                      ),
                    ),
              error: (final error, final stackTrace) => _buildErrorState(error),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddStudentDialog(context, ref),
          backgroundColor: AppColors.present,
          icon: const Icon(Icons.add),
          label: const Text('Добавить'),
        ),
      );

  Widget _buildEmptyState(final BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 80,
              color: Colors.white30,
            ),
            const SizedBox(height: 16),
            Text(
              'Нет студентов',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Нажмите + чтобы добавить',
              style: TextStyle(
                color: Colors.white30,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );

  Widget _buildErrorState(final Object error) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Ошибка: $error',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );

  void _showAddStudentDialog(
    final BuildContext context,
    final WidgetRef ref,
  ) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => _StudentDialog(
        title: 'Новый студент',
        controller: controller,
        onConfirm: () {
          if (controller.text.trim().isNotEmpty) {
            ref
                .read(studentsProvider.notifier)
                .updateStudent(Student(controller.text.trim()));
            ref.read(studentsProvider.notifier).save();
          }
        },
      ),
    );
  }
}

class _StudentEditorCard extends ConsumerStatefulWidget {
  final Student student;

  const _StudentEditorCard({required this.student});

  @override
  ConsumerState<_StudentEditorCard> createState() => _StudentEditorCardState();
}

class _StudentEditorCardState extends ConsumerState<_StudentEditorCard> {
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
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: AppColors.absent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.delete_outline,
            color: Colors.white,
            size: 28,
          ),
        ),
        confirmDismiss: (_) async {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: AppColors.cardBackground,
              title: const Text(
                'Удалить студента?',
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                widget.student.name,
                style: const TextStyle(color: Colors.white70),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Отмена'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.absent,
                  ),
                  child: const Text('Удалить'),
                ),
              ],
            ),
          );

          if (confirmed == true) {
            ref
                .read(studentsProvider.notifier)
                .removeStudent(widget.student);
            ref.read(studentsProvider.notifier).save();
          }

          return confirmed ?? false;
        },
        onDismissed: (_) {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: getStatusColor(widget.student.status),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(50),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _showEditDialog(context),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: _isEditing
                          ? TextField(
                              controller: _controller,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors.white54,
                                  ),
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
                            tooltip: 'Сохранить',
                          ),
                          IconButton(
                            icon:
                                const Icon(Icons.close, color: Colors.white70),
                            onPressed: _cancelEdit,
                            tooltip: 'Отмена',
                          ),
                        ] else ...[
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white70),
                            onPressed: () => _showEditDialog(context),
                            tooltip: 'Редактировать',
                          ),
                          _StatusDropdown(student: widget.student),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  void _showEditDialog(final BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _StudentDialog(
        title: 'Редактировать',
        controller: _controller,
        onConfirm: _saveEdit,
      ),
    );
  }

  void _saveEdit() {
    final newName = _controller.text.trim();
    if (newName.isNotEmpty && newName != widget.student.name) {
      ref.read(studentsProvider.notifier).updateStudent(
            Student(newName, status: widget.student.status),
            widget.student.name,
          );
      ref.read(studentsProvider.notifier).save();
    }
    setState(() => _isEditing = false);
    if (Navigator.canPop(context)) Navigator.pop(context);
  }

  void _cancelEdit() {
    setState(() => _isEditing = false);
    _controller.text = widget.student.name;
    if (Navigator.canPop(context)) Navigator.pop(context);
  }
}

class _StatusDropdown extends ConsumerWidget {
  final Student student;

  const _StatusDropdown({required this.student});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) => PopupMenuButton<StudentStatus>(
        icon: const Icon(Icons.more_vert, color: Colors.white70),
        tooltip: 'Изменить статус',
        color: AppColors.cardBackground,
        onSelected: (final status) {
          ref
              .read(studentsProvider.notifier)
              .updateStudentStatus(student, status);
          ref.read(studentsProvider.notifier).save();
        },
        itemBuilder: (_) => [
          _buildStatusItem(StudentStatus.present, 'Присутствует'),
          _buildStatusItem(StudentStatus.absent, 'Отсутствует'),
          _buildStatusItem(StudentStatus.sick, 'Болеет'),
          _buildStatusItem(StudentStatus.unknown, 'Неизвестно'),
        ],
      );

  PopupMenuItem<StudentStatus> _buildStatusItem(
    final StudentStatus status,
    final String label,
  ) =>
      PopupMenuItem(
        value: status,
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: getStatusColor(status),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      );
}

class _StudentDialog extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final VoidCallback onConfirm;

  const _StudentDialog({
    required this.title,
    required this.controller,
    required this.onConfirm,
  });

  @override
  Widget build(final BuildContext context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Имя студента',
            hintStyle: const TextStyle(color: Colors.white54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
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
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.present,
            ),
            child: const Text('OK'),
          ),
        ],
      );
}
