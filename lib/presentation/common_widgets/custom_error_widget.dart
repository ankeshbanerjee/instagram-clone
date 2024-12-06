import 'package:flutter/material.dart';
import 'package:instagram_clone/configs/theme/app_theme.dart';
import 'package:instagram_clone/presentation/common_widgets/render_svg.dart';
import 'package:instagram_clone/services/assets_provider/svg_assets_provider.dart';

class CustomErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;
  const CustomErrorWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context)!.theme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const RenderSvg(
            path: SvgAssetsProvider.error,
            size: 60.0,
          ),
          const SizedBox(height: 16.0),
          Text(
            "Something went wrong. Please try again.",
            style: TextStyle(
              fontSize: 16.0,
              color: theme.secondaryTextColor,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(onPressed: onRetry, child: const Text("Retry"))
        ],
      ),
    );
  }
}
