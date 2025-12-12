import 'package:flutter/material.dart';
import 'package:flutter_demo/data/models/project_data.dart';
import 'package:flutter_demo/data/remote/odoo_client.dart';
import '../cards/card_item_project.dart';

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
    return FutureBuilder<List<ProjectData>>(
      future: _projectsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error al cargar proyectos: ${snapshot.error}'),
          );
        }

        final projects = snapshot.data ?? [];
        if (projects.isEmpty) {
          return const Center(child: Text('No hay proyectos registrados'));
        }

        return ListView.separated(
          itemCount: projects.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final project = projects[index];
            final color = _getStatusColor(project.status);
            final statusText = _getStatusText(project.status);

            return CardItemProject(
              projectName: project.name,
              partner: project.partner.isNotEmpty ? project.partner : 'Sin cliente',
              company: project.company.isNotEmpty ? project.company : 'Sin compañía',
              color: color,
              status: statusText,
            );
          },
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    final value = status.toLowerCase();
    if (value == 'done' || value == 'completado' || value == 'completed') {
      return Colors.blue;
    }
    if (value == 'open' || value == 'active' || value == 'activo') {
      return Colors.green;
    }
    if (value == 'pending' || value == 'pendiente' || value == 'onhold') {
      return const Color(0xFFE2BC28);
    }
    if (value == 'cancelled' || value == 'cancelado') {
      return const Color.fromARGB(255, 179, 40, 30);
    }
    return Colors.blueGrey;
  }

  String _getStatusText(String status) {
    final value = status.toLowerCase();
    if (value.isEmpty) return 'Sin estado';
    if (value == 'done' || value == 'completed' || value == 'completado') {
      return 'Completado';
    }
    if (value == 'open' || value == 'active' || value == 'activo') {
      return 'Activo';
    }
    if (value == 'pending' || value == 'pendiente' || value == 'onhold') {
      return 'Pendiente';
    }
    if (value == 'cancelled' || value == 'cancelado') {
      return 'Cancelado';
    }
    return status[0].toUpperCase() + status.substring(1);
  }
}