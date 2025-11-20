import 'package:flutter/material.dart';
import '../../styles/progress_bar_form_theme.dart';
import '../../../data/models/progress_activity.dart';


class TaskGroup extends StatefulWidget {
  final String taskName;
  final List<ProgressActivity> items;
  final double avgProgress;
  final void Function(ProgressActivity) onEdit;
  final void Function(ProgressActivity) onDelete;

  const TaskGroup({
    super.key,
    required this.taskName,
    required this.items,
    required this.avgProgress,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<TaskGroup> createState() => _TaskGroupState();
}

class _TaskGroupState extends State<TaskGroup> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.15),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Card header
          ListTile(
            leading: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Text('P01'),
            ),
            title: Text(
              widget.taskName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '${widget.items.length} actividades realizadas',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: IconButton(
              icon: Icon(
                _expanded ? Icons.expand_less : Icons.expand_more,
                color: brand,
              ),
              onPressed: () => setState(() => _expanded = !_expanded),
            ),
          ),

          if (_expanded) const Divider(height: 1),

          // Mini menu inside the expanded card
          if (_expanded)
            Column(
              children: [
                for (final act in widget.items)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            act.detail,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Editar',
                          icon: const Icon(
                            Icons.edit,
                            size: 18,
                            color: Colors.black54,
                          ),
                          onPressed: () => widget.onEdit(act),
                        ),
                        IconButton(
                          tooltip: 'Eliminar',
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.black54,
                          ),
                          onPressed: () => widget.onDelete(act),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 4),
              ],
            ),
        ],
      ),
    );
  }
}