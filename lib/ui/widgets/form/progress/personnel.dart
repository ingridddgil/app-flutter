import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_demo/data/models/progress_activity.dart';
import 'package:flutter_demo/data/models/progress_personnel.dart';
import 'package:signature/signature.dart';
import '../../../styles/progress_bar_form_theme.dart';
import '../../header_form.dart';
import '../../progress_bar_form.dart';
import '../../form/progress/issues.dart';
import '../../../../data/remote/odoo_client.dart'; 
import '../../../../data/models/employee_data.dart';
import '../../../../env.dart';
import '../../../../data/controllers/progress_form.dart'; 


class PersonnelPage extends StatefulWidget {
  
  final List<ProgressActivity> activityDetails;
  const PersonnelPage({super.key, required this.activityDetails});

  @override
  State<PersonnelPage> createState() => _PersonnelPageState();
}

class _PersonnelPageState extends State<PersonnelPage> {
  String pink(String msg) => "\x1B[38;2;255;105;180m$msg\x1B[0m";
  String green(String msg) => "\x1B[32m$msg\x1B[0m";
  String red(String msg)   => "\x1B[31m$msg\x1B[0m";

  final _searchCtrl = TextEditingController();

  final List<EmployeeData> _allPeople = [];

  final form = ProgressFormController.instance;

  // Odoo client instance 
  late final OdooClient _odoo;
  final List<EmployeeData> _assigned = [];
  final Set<int> _selectedIds = {};
  final Map<int, Uint8List> _signatures = {};

  @override
  void initState(){
    super.initState();

    _odoo = OdooClient(
      baseUrl: Env.url,
      dbName: Env.db,
    );
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
  debugPrint(pink('_loadEmployees() started'));

  try {
    debugPrint(pink('Attempting authentication...'));
    final loggedIn = await _odoo.authenticate('admin', 'admin');
    debugPrint(pink('Authentication result: $loggedIn'));

    if (!loggedIn) {
      debugPrint(red('No se pudo autenticar'));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: No se pudo autenticar en Odoo'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    debugPrint(pink('Fetching personnel data...'));
    final raw = await _odoo.fetchPersonnelRaw();
    debugPrint(pink('Raw data received: ${raw.length} records'));
    debugPrint(pink('First record (if any): ${raw.isNotEmpty ? raw.first : "empty"}'));

    if (raw.isEmpty) {
      debugPrint(pink('No employees found in database'));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se encontraron empleados en la base de datos'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    final employees = raw.map((e) {
      debugPrint(pink('Processing employee: $e'));

      String category = 'Sin categoría';

      final jobTitle = e['job_title'];
      debugPrint(pink('  job_title value: $jobTitle (type: ${jobTitle.runtimeType})'));

      if (jobTitle is String && jobTitle.trim().isNotEmpty) {
        category = jobTitle.trim();
      } else {
        final jobId = e['job_id'];
        debugPrint(pink('  job_id value: $jobId (type: ${jobId.runtimeType})'));

        if (jobId is List && jobId.length >= 2 && jobId[1] is String) {
          final jobName = (jobId[1] as String).trim();
          if (jobName.isNotEmpty) category = jobName;
        }
      }

      return EmployeeData(
        id: e['id'] as int,
        name: e['name'] as String,
        category: category,
      );
    }).toList();

    debugPrint(pink('Employees processed: ${employees.length}'));
    for (final e in employees) {
      debugPrint(
        pink('   Employee: id=${e.id}, name=${e.name}, category=${e.category}'),
      );
    }
    setState(() {
      _allPeople
        ..clear()
        ..addAll(employees);
    });

    debugPrint(pink('setState completed, _allPeople.length = ${_allPeople.length}'));
    final form = ProgressFormController.instance;
    final existing = form.personnel;

    debugPrint(pink('Checking edit mode: existing personnel = ${existing.length}'));

    if (existing.isNotEmpty) {
      debugPrint(pink('Edit mode detected — pre-selecting employees...'));

      final byId = {
        for (final e in _allPeople) e.id.toString(): e,
      };

      _assigned
        ..clear()
        ..addAll(
          existing.map((p) {
            final match = byId[p.id];
            if (match != null) {
              debugPrint(pink('Reassigning match for id=${p.id}: ${match.name}'));
              return match;
            }

            debugPrint(
              pink('Employee id=${p.id} not in Odoo list, creating fallback object'),
            );
            return EmployeeData(
              id: int.tryParse(p.id) ?? -1,
              name: p.name,
              category: p.category,
            );
          }),
        );

      debugPrint(pink('_assigned restored with ${_assigned.length} employees'));
    } else {
      debugPrint(pink('Not editing OR no personnel found — nothing to pre-select'));
    }

    if (mounted) setState(() {});

  } catch (e, stackTrace) {
    debugPrint(pink('ERROR in _loadEmployees: $e'));
    debugPrint(pink('Stack trace: $stackTrace'));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar empleados: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }
}

  static const steps = [
    StepItem(icon: Icons.info_outline, label: 'General'),
    StepItem(icon: Icons.description, label: 'Descripción'),
    StepItem(icon: Icons.checklist, label: 'Avances'),
    StepItem(icon: Icons.badge, label: 'Personal'),
    StepItem(icon: Icons.warning_amber, label: 'Contratiempos'),
  ];

  // -------------------- Navigation --------------------

  void _back() {
    Navigator.pop(context);
  }

  void _submit() {
    final personnel = _assigned.map((e) {
      return ProgressPersonnel(
        id: e.id.toString(),
        name: e.name,
        category: e.category,
        normalHours: 0.0,
      );
    }).toList();

    // store in form so IssuesPage can see them too
    form.personnel
      ..clear()
      ..addAll(personnel);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => IssuesPage(personnel: personnel),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form is valid. Continuing…')),
    );
  }


  // filter to search employees
  List<EmployeeData> get _filteredPeople {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return [];
    return _allPeople
        .where((p) => p.name.toLowerCase().contains(q))
        .toList();
  }

  /// Add a person to `_assigned` if not already there.
  void _addPerson(EmployeeData p) {
    final alreadyAssigned = _assigned.any((it) => it.id == p.id);
    if (alreadyAssigned) return;

    setState(() {
      _assigned.add(p);
      _searchCtrl.clear();
    });
  }

  /// Toggle checkbox selection for a row.
  void _toggleSelected(int id, bool selected) {
    setState(() {
      if (selected) {
        _selectedIds.add(id);
      } else {
        _selectedIds.remove(id);
      }
    });
  }

  /// Delete all selected rows.
  void _deleteSelected() {
    setState(() {
      _assigned.removeWhere((p) => _selectedIds.contains(p.id));
      _selectedIds.clear();
      _signatures.removeWhere((id, _) => !_assigned.any((p) => p.id == id));
    });
  }

  // -------------------- Signature drawer --------------------

  Future<void> _openSignatureDrawer(EmployeeData person) async {
    final controller = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );

    final result = await showModalBottomSheet<Uint8List>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SizedBox(
            height: 320,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Firma de ${person.name}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(radius),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.15),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Signature(
                      controller: controller,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: controller.clear,
                      child: const Text('Limpiar'),
                    ),
                    FilledButton(
                      onPressed: () async {
                        final bytes = await controller.toPngBytes();
                        if (bytes != null) {
                          Navigator.pop(context, bytes);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Guardar'),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        _signatures[person.id] = result;
      });
    }
  }

  // -------------------- Lifecycle --------------------

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // -------------------- UI --------------------

  @override
  Widget build(BuildContext context) {
    debugPrint(pink('PersonnelPage build: allPeople=${_allPeople.length}'));
    final assigned = _assigned;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Headerform(title: 'Bitácora de actividades diarias por servicio'),
            const StepProgressBar(
              steps: steps,
              currentIndex: 3, // Personal
              activeColor: brand,
              inactiveColor: line,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(13, 20, 13, 16),
                children: [
                  // -------- Card: search --------
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
                          'Personal',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.normal,
                                fontSize: 17,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Verifique los datos de cada trabajador',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.black.withOpacity(0.55),
                                fontWeight: FontWeight.normal,
                              ),
                        ),
                        const SizedBox(height: 16),

                        Text(
                          'Buscar personal',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 6),

                        // Search box with same style as other fields
                        fieldContainer(
                          child: TextField(
                            controller: _searchCtrl,
                            onChanged: (_) => setState(() {}),
                            decoration: inputDec(
                              '',
                              suffixIcon: const Icon(Icons.search, size: 20),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Suggestions list (only when there is a query)
                        if (_filteredPeople.isNotEmpty)
                          Column(
                            children: [
                              const Divider(height: 1),
                              for (final p in _filteredPeople)
                                ListTile(
                                  dense: true,
                                  title: Text(
                                    p.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(p.category),
                                  trailing: const Icon(Icons.add, color: brand),
                                  onTap: () => _addPerson(p),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // -------- Card: assigned personnel table --------
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
                        // Header: title + delete button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Personal asignado',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            if (_selectedIds.isNotEmpty)
                              SizedBox(
                                height: 32,
                                child: FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: brand,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: _selectedIds.isEmpty ? null : _deleteSelected,
                                  child: const Text('Eliminar'),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Table header row
                        Row(
                          children: const [
                            SizedBox(width: 32), // checkbox column
                            Expanded(child: Text('Nombre')),
                            SizedBox(width: 90, child: Text('Categoría')),
                            SizedBox(width: 60, child: Text('H. Norm')),
                            SizedBox(width: 70, child: Text('Firma')),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(height: 1),

                        // Table rows
                        for (final p in assigned) _buildPersonRow(p),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // -------- Bottom Navigation Buttons --------
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(13, 8, 13, 12),
                child: Row(
                  children: [
                    // Back
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
                                'Anterior',
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
                    // Next
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
                                'Siguiente',
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

  // -------------------- Row builder --------------------

  Widget _buildPersonRow(EmployeeData p) {
    final isSelected = _selectedIds.contains(p.id);
    final signBytes = _signatures[p.id];

    return Column(
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            // Checkbox
            SizedBox(
              width: 32,
              child: Checkbox(
                value: isSelected,
                onChanged: (v) => _toggleSelected(p.id, v ?? false),
              ),
            ),
            // Name
            Expanded(
              child: Text(
                p.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Category
            SizedBox(
              width: 90,
              child: Text(
                p.category,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Normal hours
            // SizedBox(
            //   width: 60,
            //   child: Text(p.normalHours.toStringAsFixed(1)),
            // ),
            // Signature cell
            SizedBox(
              width: 70,
              child: InkWell(
                onTap: () => _openSignatureDrawer(p),
                child: signBytes == null
                    ? const Icon(Icons.border_color_outlined, size: 18)
                    : Image.memory(signBytes, height: 24),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
      ],
    );
  }
}
