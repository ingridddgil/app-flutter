import 'package:flutter/material.dart';

class CardItemProgress extends StatelessWidget {
  final String id;
  final DateTime date;
  final String client;
  final String project;
  final String task;
  final Widget? actions;
  final Widget? status;
  final Color color;
  
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
  });

  String _formatDate(DateTime d) {
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    final year = d.year.toString();
    return '$day/$month/$year'; // 18/11/2025
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
          // Encabezado con gradiente
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              // gradient: LinearGradient(
                // color: [
                color: color,
                  // const Color(0xFF8B1E04),
                  // const Color.fromARGB(255, 180, 42, 8),
                // ],
                // begin: Alignment.centerLeft,
                // end: Alignment.centerRight,
              // ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ID AVANCE + status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "ID AVANCE",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),

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
                          child: Text(
                            'Asignado',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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

          // Contenido
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
