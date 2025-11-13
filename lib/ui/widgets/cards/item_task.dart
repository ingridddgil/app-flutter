import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardItemTask extends StatelessWidget {
  final String title;
  final String subtitle;
  final String client;
  final Widget? action1;

  const CardItemTask({
    super.key,
    required this.title,
    required this.subtitle,
    this.action1,
    required this.client,
  }); 

  @override
  Widget build(BuildContext context){
    return Card(
      elevation:0,
      color: Color(0xFFF1F2F4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.normal
              )
            ),
            SizedBox(height: 1),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                color: Colors.grey[700],
                fontSize: 12,
                fontWeight: FontWeight.normal
              )
            ),
             if (action1 != null) ...[
              const SizedBox(height: 2),
              action1!  
            ],
            SizedBox(height: 2),
            Text(
              client,
              style: GoogleFonts.poppins(
                color: Colors.grey[900],
                fontSize: 10,
                fontWeight: FontWeight.normal
              )
            ),
          ],
        ),
      ),
    );
  }

}

