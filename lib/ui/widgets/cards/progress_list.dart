import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'card_item_progress.dart';
import 'mini_button.dart';
import 'dart:math';
import '../../../data/models/temp.dart';
import 'status_tag.dart';

class ProgressList extends StatelessWidget {
  const ProgressList({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final progressID = List.generate(6, (i) => 'A${random.nextInt(10000)}');
    final supervisor = List.generate(6, (i) => supervisors[random.nextInt(supervisors.length)]);
    final statusColors = [Colors.blue, Colors.green, Color(0xFFE2BC28)];
    final statuses = ['Activo', 'Pendiente', 'Completado', 'Cancelado'];
    final state = List.generate(6, (_) => statuses[random.nextInt(statusColors.length)]);
    final project = List.generate(6, (i) => projectTitles[random.nextInt(projectTitles.length)]);
    return ListView.separated(
      itemCount: projectTitles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) => CardItemProgress(

        status: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                progressID[i],
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            StatusTag(
              color: statusColors[statuses.indexOf(state[i])],
              status: _getStatusText(statusColors[statuses.indexOf(state[i])]),
            ),
          ],
        ),

        // progressID: progressID[i], // DEBO QUITAR ESTA LÍNEA Y NO SÉ COMO 
        supervisor: supervisor[i],
        projectID: project[i],
        actions: Row(
          children: const [
            MiniButton(
              text: 
              'Eliminar', color: Color(0xFF8B1E04),
            ),
            SizedBox(width: 8),
            MiniButton(
              text: 'Editar',
              color: Color(0xFF8B1E04), outlined: true
            ),
          ],
        ),
      ),
    );
  }
  String _getStatusText(Color color) {
  if (color == Colors.blue) return 'Confirmado';
  if (color == Colors.green) return 'Asignado';
  if (color == Color(0xFFE2BC28)) return 'Borrador';
  return '';
  }
}