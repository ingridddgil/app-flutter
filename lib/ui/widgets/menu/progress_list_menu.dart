import 'package:flutter/material.dart';
import '../cards/card_item_progress.dart';
import 'dart:math';
import '../../../data/models/temp.dart';
import '../buttons/status_tag.dart';
class ProgressListMenu extends StatelessWidget {
  const ProgressListMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final random = Random();

    final progressIDs = List.generate(
      projectTitles.length,
      (i) => 'A${random.nextInt(10000)}',
    );

    final dates = List.generate(
      projectTitles.length,
      (i) {
        final now = DateTime.now();
        return now.subtract(Duration(days: random.nextInt(10)));
      },
    );

    final clientList = List.generate(
      projectTitles.length,
      (i) => clients[random.nextInt(clients.length)],
    );

    // COLORES POSIBLES DE ESTADO
    final statusColors = [
      Colors.blue,
      Colors.green,
      const Color(0xFFE2BC28),
    ];

    final project = List.generate(
      projectTitles.length,
      (i) => projectTitles[random.nextInt(projectTitles.length)],
    );

    return ListView.separated(
      itemCount: projectTitles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        // Tomamos un color aleatorio
        final headerColor = statusColors[random.nextInt(statusColors.length)];
        final statusText = _getStatusText(headerColor);

        return CardItemProgress(
          id: progressIDs[i],
          date: dates[i],
          client: clientList[i],
          project: project[i],
          task: 'Tarea ${i + 1}',
          color: headerColor,
          status: StatusTag(
            color: Colors.white,
            status: statusText,
          ),
        );
      },
    );
  }

  String _getStatusText(Color color) {
    if (color == Colors.blue) return 'Confirmado';
    if (color == Colors.green) return 'Asignado';
    if (color == const Color(0xFFE2BC28)) return 'Borrador';
    return '';
  }
}
