import 'package:flutter/material.dart';

import 'package:attendance_tracker/theme.dart';

class ErrorBlock extends StatelessWidget {
  const ErrorBlock(this.error, {super.key, this.stackTrace});

  final Object error;
  final Object? stackTrace;

  @override
  Widget build(final BuildContext context) => Center(
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            error.toString(),
            style: const TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          if (stackTrace != null) ...{
            Divider(),
            Text(
              stackTrace?.toString() ?? '',
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
          },
        ],
      ),
    ),
  );
}
