import 'package:flutter/material.dart';

class MenuOption {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;

  const MenuOption({
    required this.label,
    this.icon,
    this.onTap,
  });
}

class ThreeDotMenu extends StatelessWidget {
  String pink(String msg) => "\x1B[38;2;255;105;180m$msg\x1B[0m";
  final Color color;
  final List<MenuOption> options;

  const ThreeDotMenu({
    super.key,
    this.color = Colors.white, 
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      color: Colors.white,
      icon: Icon(Icons.more_vert, color: color),
    
      onSelected: (index) {
        options[index].onTap?.call();
      },

      itemBuilder: (context) => [
        for (int s = 0; s < options.length; s++)
          PopupMenuItem(
            value: s,
            child: Row(
              children: [
                Icon(options[s].icon),
                SizedBox(width: 4),
                Text(options[s].label),
              ],
            ),
          ),       
      ],
    );
  }
}
