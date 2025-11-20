// ui/widgets/form/progress/progress_activity.dart
import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/widgets/form/progress/personnel.dart';
import '../../../styles/progress_bar_form_theme.dart';
import '../../header_form.dart';
import '../../progress_bar_form.dart';
import 'progress_details.dart';
import '../../../../data/models/progress_activity.dart';
import '../../menu/task_group.dart';
import 'description.dart';

class ProgressActivityPage extends StatefulWidget {
  const ProgressActivityPage({super.key});

  @override
  State<ProgressActivityPage> createState() => _ProgressActivityPageState();
}

class _ProgressActivityPageState extends State<ProgressActivityPage> {
  final List<ProgressActivity> _items = [];

  static const steps = [
    StepItem(icon: Icons.info_outline, label: 'General'),
    StepItem(icon: Icons.description, label: 'Descripción'),
    StepItem(icon: Icons.checklist, label: 'Avances'),
    StepItem(icon: Icons.badge, label: 'Personal'),
    StepItem(icon: Icons.warning_amber, label: 'Contratiempos'),
  ];

  // -------------------- Navigation --------------------

  void _submit() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PersonnelPage()),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form is valid. Continuing…')),
    );
  }

  void _back() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DescriptionPage()),
    );
  }

  // -------------------- CRUD: Create / Edit / Delete --------------------

  Future<void> _create() async {
    final result = await Navigator.push<ProgressActivity>(
      context,
      MaterialPageRoute(builder: (_) => const ProgressDetailsPage()),
    );

    if (result != null) {
      setState(() => _items.add(result));
    }
  }

  Future<void> _editItem(ProgressActivity item) async {
    final index = _items.indexOf(item);
    if (index == -1) return;

    final updated = await Navigator.push<ProgressActivity>(
      context,
      MaterialPageRoute(builder: (_) => ProgressDetailsPage(initial: item)),
    );

    if (updated != null) {
      setState(() => _items[index] = updated);
    }
  }

  void _deleteItem(ProgressActivity item) {
    setState(() => _items.remove(item));
  }

  // -------------------- Grouping Logic --------------------

  /// Groups activities by "task" (Tarea/Partida)
  Map<String, List<ProgressActivity>> _groupByTask(List<ProgressActivity> list) {
    final map = <String, List<ProgressActivity>>{};

    for (final it in list) {
      map.putIfAbsent(it.task, () => []).add(it);
    }

    return map;
  }

  /// Calculates the average progress of a group (value between 0 and 1)
  double _avgProgress(List<ProgressActivity> list) {
    if (list.isEmpty) return 0.0;

    final sum = list.fold<double>(
      0.0,
      (acc, it) => acc + it.percentageProgress,
    );

    return (sum / list.length).clamp(0.0, 1.0);
  }

  // -------------------- UI --------------------

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByTask(_items);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Headerform(title: 'Bitácora de actividades diarias por servicio'),
            const StepProgressBar(
              steps: steps,
              currentIndex: 2, // Progress step
              activeColor: brand,
              inactiveColor: line,
            ),

            // -------- Scrollable Content --------
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(13, 20, 13, 16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(radius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Avances de obra',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.normal,
                                fontSize: 17,
                              ),
                        ),
                        const SizedBox(height: 4),

                        Text(
                          'Asegúrese de llenar correctamente el documento',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.black.withOpacity(0.55),
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                        const SizedBox(height: 12),

                        // Create button
                        SizedBox(
                          height: 40,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: brand,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _create,
                            child: const Text('Crear'),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Grouped cards by task
                        for (final entry in grouped.entries)
                          TaskGroup(
                            taskName: entry.key,
                            items: entry.value,
                            avgProgress: _avgProgress(entry.value),
                            onEdit: _editItem,
                            onDelete: _deleteItem,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // -------- Navigation Buttons --------
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(13, 8, 13, 12),
                child: Row(
                  children: [
                    // Previous button
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: brand,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: brand),
                            ),
                          ),
                          onPressed: _back,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.chevron_left),
                              SizedBox(width: 8),
                              Text(
                                'Back',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Next button
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: brand,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _submit,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Next',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.chevron_right),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
