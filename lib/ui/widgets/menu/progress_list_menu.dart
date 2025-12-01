import 'package:flutter/material.dart';
import 'package:flutter_demo/data/models/progress_data.dart';
import 'package:flutter_demo/data/repositories/progress_repository.dart';
import '../cards/card_item_progress.dart';
import '../buttons/status_tag.dart';
import '../form/progress/general.dart';
import '../../../data/models/progress_activity.dart';
import '../../../data/controllers/progress_form.dart';

class ProgressListMenu extends StatefulWidget {
  const ProgressListMenu({super.key});

  @override
  State<ProgressListMenu> createState() => _ProgressListMenuState();
}

class _ProgressListMenuState extends State<ProgressListMenu> {
  List<ProgressData> get _items => ProgressRepository.instance.getAll();

    Future<void> _goToNewProgress() async {
      // fresh start: no edit mode
      ProgressFormController.instance.reset();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const GeneralPage(),
        ),
      );
    }



  // Progress average of an activity list
  double _avgProgress(List<ProgressActivity> list) {
    if (list.isEmpty) return 0.0;

    final sum = list.fold<double>(
      0.0,
      (acc, it) => acc + it.percentageProgress,
    );

    return (sum / list.length).clamp(0.0, 1.0);
  }

  // Text showed in a card
  String _taskText(List<ProgressActivity> activities) {
    if (activities.isEmpty) return 'Sin tareas';

    final tasks = activities.map((a) => a.task).toSet().toList();
    if (tasks.length == 1) return tasks.first;

    // Several different tasks
    return '${tasks.first} (+${tasks.length - 1} más)';
  }

  Color _headerColorFromProgress(double percent) {
    // percent viene 0.0 a 1.0
    if (percent >= 1.0) return Colors.green;
    if (percent > 0.0) return  Color.fromARGB(255, 42, 125, 192);
    return const Color(0xFFE2BC28); // pendiente / borrador
  }

  String _getStatusText(Color color) {
    if (color == const Color.fromARGB(255, 42, 125, 192)) {
      return 'Confirmado';
    }
    if (color == Colors.green) {
      return 'Asignado';
    }
    if (color == const Color(0xFFE2BC28)) {
      return 'Borrador';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: _goToNewProgress,
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add, 
          color: Color(0xFF8B1E04),
        ),
      ),
      body: items.isEmpty
          ? const Center(child: Text("No hay avances registrados"))
          : ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final p = items[i];

                final activities = p.activity; 
                final percentAvg = _avgProgress(activities);
                final headerColor = _headerColorFromProgress(percentAvg);
                final taskText = _taskText(activities);

                return CardItemProgress(
                  id: p.id,
                  date: p.description.startTime,
                  client: p.description.clientSupervisor,
                  project: 'Prueba demo',
                  task: taskText, 
                  color: headerColor,
                  status: StatusTag(
                    color: Colors.white,
                    status: _getStatusText(headerColor),
                  ),
                );
              },
            ),
    );
  }
  
}
