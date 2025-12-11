import 'package:flutter/material.dart';
import '../cards/card_item_project.dart';
import 'dart:math';
import 'package:flutter_demo/data/models/project_data.dart';
import 'package:flutter_demo/data/remote/odoo_client.dart';

class ProjectListMenuPage extends StatefulWidget {
  const ProjectListMenuPage({super.key});

  @override
  State<ProjectListMenuPage> createState() => _ProjectListMenuPageState();
}

class _ProjectListMenuPageState extends State<ProjectListMenuPage> {
  late Future<List<ProjectData>> _projectsFuture;

  @override
  void initState() {
    super.initState();
    _projectsFuture = OdooClient.instance.fetchProjects(); 
  }

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final statusColors = [
      Colors.blue,
      Colors.green,
      const Color(0xFFE2BC28),
      const Color.fromARGB(255, 179, 40, 30),
    ];

    return FutureBuilder<List<ProjectData>>(
      future: _projectsFuture,
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error
        if (snapshot.hasError) {
          return Center(
            child: Text('Error al cargar proyectos: ${snapshot.error}'),
          );
        }

        // Data ready
        final projects = snapshot.data ?? [];

        if (projects.isEmpty) {
          return const Center(
            child: Text('No hay proyectos registrados'),
          );
        }

        return ListView.separated(
          itemCount: projects.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final project = projects[i];

            final color = statusColors[random.nextInt(statusColors.length)];

            return CardItemProject(
              projectName: project.name,               
              partner: project.partner,   
              company: project.company,  
              color: color,
              status: _getStatusText(color),           
            );
          },
        );
      },
    );
  }

  String _getStatusText(Color color) {
    if (color == Colors.blue) return 'Completado';
    if (color == Colors.green) return 'Activo';
    if (color == const Color(0xFFE2BC28)) return 'Pendiente';
    if (color == const Color.fromARGB(255, 179, 40, 30)) return 'Cancelado';
    return '';
  }
}
