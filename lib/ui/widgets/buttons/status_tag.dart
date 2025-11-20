import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class StatusTag extends StatelessWidget{
  final String status;
  final Color color;

  const StatusTag({
    super.key,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 9, vertical: 2),
        child: Text(
          status,
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize:11,
            fontWeight: FontWeight.w500
          )
        )
      ),
    );
  }
}