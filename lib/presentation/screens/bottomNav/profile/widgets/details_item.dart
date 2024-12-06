import 'package:flutter/material.dart';
import 'package:instagram_clone/configs/theme/app_theme.dart';

class DetailsItem extends StatelessWidget {
  const DetailsItem({
    super.key,
    required this.value,
    required this.section,
  });

  final String value;
  final String section;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context)!.theme;
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: theme.primaryTextColor),
        ),
        Text(section, style: TextStyle(color: theme.primaryTextColor))
      ],
    );
  }
}
