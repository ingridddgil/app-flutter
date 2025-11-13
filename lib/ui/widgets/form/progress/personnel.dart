import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

import '../../../styles/progress_bar_form_theme.dart';
import '../../header_form.dart';
import '../../progress_bar_form.dart';
import '../../form/progress/progress_activity.dart'; // Back step
import '../../form/progress/issues.dart'; // Next step (when you have it)
import '../../../../data/models/person_data.dart';   // <- create this model

class PersonnelPage extends StatefulWidget {
  const PersonnelPage({super.key});

  @override
  State<PersonnelPage> createState() => _PersonnelPageState();
}

class _PersonnelPageState extends State<PersonnelPage> {
  // Search text controller
  final _searchCtrl = TextEditingController();

  /// All people available to assign (later: load from Odoo).
  /// For now, this is just sample data.
  final List<PersonData> _allPeople = [
    PersonData(
      id: 1,
      name: 'Ingrid Sarahí Gil Hernandez',
      category: 'Supervisor',
    ),
    PersonData(
      id: 2,
      name: 'Juan Pérez',
      category: 'Técnico',
    ),
    PersonData(
      id: 3,
      name: 'María López',
      category: 'Ayudante',

    ),
  ];

  /// People assigned to this log.
  final List<PersonData> _assigned = [];

  /// Which rows are currently selected (for deletion).
  final Set<int> _selectedIds = {};

  /// Signature images, keyed by person id.
  final Map<int, Uint8List> _signatures = {};

  static const steps = [
    StepItem(icon: Icons.info_outline, label: 'General'),
    StepItem(icon: Icons.description, label: 'Descripción'),
    StepItem(icon: Icons.checklist, label: 'Avances'),
    StepItem(icon: Icons.badge, label: 'Personal'),
    StepItem(icon: Icons.warning_amber, label: 'Contratiempos'),
  ];

  // -------------------- Navigation --------------------

  void _back() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProgressActivityPage()),
    );
  }

  void _submit() {
    Navigator.push(context,
      MaterialPageRoute(builder: (_) => const IssuesPage()),
    );
    // Later: navigate to ContratiemposPage
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Personal guardado. Continúe al siguiente paso.')),
    );
  }

  // -------------------- Helpers: search / assign --------------------

  /// Filtered list from `_allPeople` based on the search text.
  List<PersonData> get _filteredPeople {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return [];
    return _allPeople
        .where((p) => p.name.toLowerCase().contains(q))
        .toList();
  }

  /// Add a person to `_assigned` if not already there.
  void _addPerson(PersonData p) {
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

  Future<void> _openSignatureDrawer(PersonData person) async {
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

  Widget _buildPersonRow(PersonData p) {
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
