import 'package:flutter/material.dart';
import 'item_progress.dart';
import '../mini_button.dart';
import 'dart:math';
import '../../../data/models/temp.dart';
import '../status_tag.dart';

class ProgressList extends StatelessWidget {
  
  const ProgressList({super.key});

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

    final statusColors = [Colors.blue, Colors.green, const Color(0xFFE2BC28)];
    final statuses = ['Activo', 'Pendiente', 'Completado', 'Cancelado'];

    final state = List.generate(
      projectTitles.length,
      (_) => statuses[random.nextInt(statusColors.length)],
    );

    final project = List.generate(
      projectTitles.length,
      (i) => projectTitles[random.nextInt(projectTitles.length)],
    );

    return ListView.separated(
      itemCount: projectTitles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final headerColor = statusColors[statuses.indexOf(state[i])];

        return CardItemProgress(
          id: progressIDs[i],
          date: dates[i],
          client: clientList[i],       
          project: project[i],
          task: 'Tarea ${i + 1}', 
          color: headerColor,
          status: StatusTag(
            color: Colors.white,
            status: _getStatusText(headerColor),
          ),

          actions: Row(
            children: const [
              IconButton(
                icon: Icon(Icons.delete, color:Color(0xFF8B1E04)),
                // onPressed: onDelete,
              ),
              SizedBox(width: 8),
              MiniButton(
                text: 'Editar',
                color: Color(0xFF8B1E04),
                outlined: true,
              ),
            ],
          ),
        );
      },
    );
  }

  String _getStatusText(Color color) {
    if (color == Colors.blue) return 'Confirmado';
    if (color == Colors.green) return 'Asignado';
    if (color == Color(0xFFE2BC28)) return 'Borrador';
    return '';
  }
}
