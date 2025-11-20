import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThreeDotMenu extends StatelessWidget {
  String pink(String msg) => "\x1B[38;2;255;105;180m$msg\x1B[0m";
  final Color color;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ThreeDotMenu({
    super.key,
    this.color = Colors.white,
    this.onEdit,
    this.onDelete
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.white,
      icon: Icon(Icons.more_vert, color: color),
      onSelected: (value) {
        if (value == 'editar') {
          debugPrint(pink('Button tapped'));
          if (onEdit != null) {
            onEdit!();
          }
        } else if(value == 'eliminar') {
          debugPrint(pink('Button tapped'));
          if (onDelete != null){
            onDelete!();
          }       
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'editar',
          child: Row(
            children: [
              const Icon(Icons.edit, size: 18),
              const SizedBox(width: 10),
              Text(
                'Editar',
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'eliminar',
          child: Row(
            children: [
              const Icon(Icons.delete, size: 18, color: Colors.red),
              const SizedBox(width: 10),
              Text(
                'Eliminar',
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
