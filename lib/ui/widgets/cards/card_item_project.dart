import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardItemProject extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final String status;

  const CardItemProject({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.status,
  }); 

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F2F4),
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left:BorderSide(
            color: color,
            width: 4,
          ),
        ),
      ),
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500
              )
            ),
            SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                color: Colors.grey[700],
              )
            ),
          ],
        ),
      ),
    );
  }

}

