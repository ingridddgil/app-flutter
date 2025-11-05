import 'package:flutter/material.dart';

class Headerform extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final bool showDivider;
  final EdgeInsetsGeometry padding;
  final TextStyle? titleStyle;
  final Color? activeColor;

  const Headerform({
    super.key,
    required this.title,
    this.onBack,
    this.activeColor,
    this.showDivider = true,
    this.padding = const EdgeInsets.fromLTRB(16, 8, 16, 12),
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context){
    final defaultTitleStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, height: 1.15,);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (onBack != null)
                IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_ios),
                  color: activeColor ?? Theme.of(context).iconTheme.color,
                  tooltip: 'Regresar',
                ),
              // título
              Text(
                title,
                style: titleStyle ?? defaultTitleStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (showDivider) const SizedBox(height: 8),
        if (showDivider) const Divider(height: 1),
        const SizedBox(height: 12),

      ],
    );
  }
} 