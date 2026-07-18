import 'package:flutter/material.dart';

import '../core/app_theme.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.action,
    this.onTap,
  });

  final String title;
  final String? action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
            ),
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onTap,
            child: Text(action!),
          ),
      ],
    );
  }
}
