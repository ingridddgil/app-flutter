import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardItemProgress extends StatelessWidget {
  // final String progressID;
  final String supervisor;
  final String projectID;
  final Widget? actions;
  final Widget? status;

  const CardItemProgress({
    super.key,
    // required this.progressID,
    required this.supervisor,
    required this.projectID,
    this.actions,
    this.status,
  });

  @override
  Widget build(BuildContext context){
    return Card(
      elevation: 0,
      color: Color(0xFFF1F2F4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (status != null) ...[
              const SizedBox(height: 10),
              status!
            ],
            SizedBox(height: 10),
            // Text(
            //   progressID,
            //   style: GoogleFonts.poppins(
            //     color: Colors.black,
            //     fontWeight: FontWeight.normal,
            //     fontSize: 14,
            //   )
            // ),
            SizedBox(height: 1),
            Text(
              supervisor,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 12,
              )
            ),
            SizedBox(height: 1),
            Text(
              projectID,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 10,
              )
            ),
            SizedBox(height: 4),
            if (actions != null) ...[
              const SizedBox(height: 10),
              actions!
            ],
          ],
        ),
      ),
    );
  }
}