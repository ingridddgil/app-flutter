import 'package:flutter/material.dart';
import '../cards/card_item_project.dart';
import 'dart:math';
import '../../../data/models/temp.dart';

class ProjectListMenu extends StatelessWidget {
  const ProjectListMenu({
    super.key
  });

  @override
  Widget build(BuildContext context){
    final random = Random();
    final statusColors = [Colors.blue, Colors.green, Color(0xFFE2BC28), const Color.fromARGB(255, 179, 40, 30)];
    final statuses = ['Activo', 'Pendiente', 'Completado', 'Cancelado'];
    final state = List.generate(6, (_) => statuses[random.nextInt(statusColors.length)]);
    final titles = List.generate(6, (i) => projectTitles[random.nextInt(projectTitles.length)]);
    return ListView.separated(
      itemCount: projectTitles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) => CardItemProject(
        title: titles[i],
        subtitle: clients[i % clients.length],
        color: statusColors[statuses.indexOf(state[i])],
        status: _getStatusText(statusColors[statuses.indexOf(state[i])]),
      ),
    );
  }
  String _getStatusText(Color color) {
  if (color == Colors.blue) return 'Completado';
  if (color == Colors.green) return 'Activo';
  if (color == Color(0xFFE2BC28)) return 'Pendiente';
  if (color == Color.fromARGB(255, 179, 40, 30)) return 'Cancelado';
  return '';
}
}