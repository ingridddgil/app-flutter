// Draw a pill-shaped tab button that can show the progress's records or projects's records
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabPill extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const TabPill(
    {
      super.key,
      required this.text, 
      required this.active,
      required this.onTap
    }
  );

  @override
  Widget build(BuildContext context){
    const red = Color(0xFF8B1E04);
    const grayText = Color(0xFF5A5A5A);
    const grayLight = Color(0xFFF5F5F5);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? red : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: GoogleFonts.montserrat (
            fontSize: 13,
            fontWeight: active ? FontWeight.bold : FontWeight.w500,
            color: active ? grayLight : grayText,
          ),
        ),
      ),
    );
  }
}