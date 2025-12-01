import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/widgets/buttons/three_dot_menu.dart';
import 'package:flutter_demo/ui/widgets/form/progress/general.dart';
import 'package:flutter_demo/data/repositories/progress_repository.dart';
import 'package:flutter_demo/data/controllers/progress_form.dart';
import 'package:flutter_demo/data/controllers/progress_form.dart';
import 'package:flutter_demo/data/repositories/progress_repository.dart';

class CardItemProgress extends StatelessWidget {
  final String id;
  final DateTime date;
  final String client;
  final String project;
  final String task;
  final Widget? actions;
  final Widget? status;
  final Color color;
  final VoidCallback? onDeleted;
  
  const CardItemProgress({
    super.key,
    required this.id,
    required this.date,
    required this.client,
    required this.project,
    required this.task,
    required this.color,
    this.actions,
    this.status,
    this.onDeleted,
  });

  String _formatDate(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    final year = d.year.toString();
    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ENCABEZADO
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ID AVANCE + STATUS + MENU
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ID AVANCE',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    SizedBox(width: 100),
                    status ??
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Sin estado',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                    ThreeDotMenu(
                      onEdit: () {
                        // Get the record from local repository using this card's id
                        final repo = ProgressRepository.instance;
                        final data = repo.getById(id);

                        if (data == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('No se encontró el registro para editar')),
                          );
                          return;
                        }
                        final form = ProgressFormController.instance;
                        form.loadFrom(data);

                        // Start the wizard at the first step
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const GeneralPage(),
                          ),
                        );
                      },
                      onDelete: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              iconColor: Colors.white,
                              title: const Text('¿Está seguro que desea eliminar este registro?'),
                              content: const Text('Esta acción es irreversible'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(), // cancel
                                  child: const Text(
                                    'Cancelar',
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    await ProgressRepository.instance.removeById(id);

                                    if (onDeleted != null){
                                      onDeleted!();
                                    } 
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Registro eliminado'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  },
                                  child: const Text('Eliminar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  id,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // CONTENIDO
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: _infoColumn("Cliente", client),
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: _infoColumn("Fecha", _formatDate(date)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _infoColumn("Proyecto", project),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _infoColumn("Tarea", task),
                    ),
                  ],
                ),
                if (actions != null) ...[
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: actions!,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
