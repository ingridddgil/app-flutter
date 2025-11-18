import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/screens/menu.dart';
import 'package:google_fonts/google_fonts.dart';

class Headerform extends StatelessWidget {
  final String title;
  final bool showDivider;
  final EdgeInsetsGeometry padding;
  final TextStyle? titleStyle;
  final Color? activeColor;

  const Headerform({
    super.key,
    required this.title,
    this.activeColor,
    this.showDivider = true,
    this.padding = const EdgeInsets.fromLTRB(20, 10, 20, 5),
    this.titleStyle,
  });

  void _back(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MenuPage(initialTab: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila con botón de regresar + texto
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    color: const Color(0xFF8B1E04),
                    onPressed: () => _back(context),
                  ),
                  Text(
                    'Regresar',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Título
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                  color: const Color(0xFF2E3A59),
                  fontSize: 20,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (showDivider)
          Padding(
            padding: padding,
            child: const Divider(height: 1),
          ),
      ],
    );
  }
}
