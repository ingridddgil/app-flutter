import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardItemProject extends StatelessWidget {
  final String projectName;
  final List<String> labelTasks = [];
  final String partner;
  final String company;
  final String? superintendent;
  final String? supervisor;
  final String? coordinator;
  final DateTime? startDate;
  final double? allocatedHours;
  final String? status;
  final Color color;

  CardItemProject({
    super.key,
    required this.projectName,
    required this.partner,
    required this.company,  
    this.superintendent,
    this.supervisor,
    this.coordinator,
    this.startDate,
    this.allocatedHours,
    this.status,
    required this.color,
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
              projectName,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                Text(
                  partner,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[700],
                  )
                ),
                Text(
                  company,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[700],
                  )
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

}

