import 'package:flutter/material.dart';
import 'package:flutter_demo/data/models/progress_issues.dart';
import 'package:flutter_demo/data/models/progress_personnel.dart';
import 'package:flutter_demo/data/repositories/progress_repository.dart';
import '../../header_form.dart';
import '../../progress_bar_form.dart';
import '../../../styles/progress_bar_form_theme.dart';
import '../../../screens/menu.dart';
import '../../../../data/controllers/progress_form.dart';
import '../../../../data/remote/odoo_client.dart';
import '../../../../data/models/progress_data.dart';
import 'package:flutter_demo/ui/styles/styles.dart';

class IssuesPage extends StatefulWidget {
  final List<ProgressPersonnel> personnel;
  const IssuesPage({super.key, required this.personnel});

  @override
  State<IssuesPage> createState() => _IssuesPageState();
}

class _IssuesPageState extends State<IssuesPage> {
  String pink(String msg) => "\x1B[38;2;255;105;180m$msg\x1B[0m";
  // Description form
  final _formKey = GlobalKey<FormState>();
  final _startTime = TextEditingController();
  final _endTime = TextEditingController();
  final _description = TextEditingController();
  String? _responsable;
  final form = ProgressFormController.instance;
  
  final OdooClient _odoo = OdooClient.instance;
  
  static const steps = [
    StepItem(icon: Icons.info_outline, label: 'General'),
    StepItem(icon: Icons.description, label: 'Descripción'),
    StepItem(icon: Icons.checklist, label: 'Avances'),
    StepItem(icon: Icons.badge, label: 'Personal'),
    StepItem(icon: Icons.warning_amber, label: 'Contratiempos'),
  ];

  @override
  void initState(){
    super.initState();
  }
  
  @override
  void dispose() {
    _startTime.dispose();
    _endTime.dispose();
    _description.dispose();
    super.dispose();    
  }
  
  Future<void> _submit() async {
    // final ok = _formKey.currentState?.validate() ?? false;
    // if (!ok) return;

    // HH:mm -> TimeOfDay
    final sTod = _tryParseHHmm(_startTime.text.trim());
    final eTod = _tryParseHHmm(_endTime.text.trim());
    if (sTod == null || eTod == null) return;

    final date = DateTime.now();

    final startDt = DateTime(
      date.year, 
      date.month, 
      date.day,
      sTod.hour, 
      sTod.minute,
    );

    final endDt = DateTime(
      date.year, 
      date.month, 
      date.day,
      eTod.hour, 
      eTod.minute,
    );

    final issue = ProgressIssues(
      issueStartTime: startDt,
      issueEndTime: endDt,
      description: _description.text.trim(),
      responsable: _responsable ?? '',
    );
    form.issues = issue;
    
    // it builds the whole progress record
    final progress = form.buildProgressData();

    // save locally
    if (form.isEditing && form.editingId != null) {
      await ProgressRepository.instance.updateById(form.editingId!, progress);
    } else {
      await ProgressRepository.instance.add(progress);
    }

    // save in Odoo
    try {
      final values = _mapProgressToOdooValues(progress);   
      if (form.isEditing){
          // 
      } else {
        final newId = await _odoo.createRecord('creacion.avances', values);
        debugPrint(pink('Registro creado en Odoo con ID $newId'));
      }
      
    } catch (e) {
      debugPrint(pink('Error al guardar en Odoo $e'));
      if (mounted){
        debugPrint(pink('There was an error to save in Odoo'));
      }
    }
     
    form.reset();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MenuPage(initialTab: 2)),
      (route) => false,
    );
  }

  Map<String, dynamic> _mapProgressToOdooValues(ProgressData pd){
    return {
      // general
      'oc_pedido': pd.general.orderSale,
      'ct': pd.general.workPlace,
      'or_rfq': pd.general.quoteNumber,
      'especialidad_trabajo': pd.general.especialty,

      // description
      'planta': pd.description.companyPremises,
      'hora_inicio': pd.description.startTime,
      'hora_termino': pd.description.endTime,
      'supervisorplanta': pd.description.clientSupervisor,
      'responsable_id': pd.description.supervisor,
      'area_equipo': pd.description.workArea,
      'licencia': pd.description.license,

      // Avance
      
      // contratiempos 
    };
  }


  void _back(){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Headerform(
              title: 'Bitácora de actividades diarias por sevicio'
            ),
            StepProgressBar(
              steps: steps, 
              currentIndex: 4,
              activeColor: brand,
              inactiveColor: line,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(13, 20, 13, 16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: line),
                      borderRadius: BorderRadius.circular(radius),
                      boxShadow:[
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2)
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // titulo  y subtitulo del formulario
                          Text(
                            'Descripción detallada del trabajo',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 2),

                          Text(
                            'Asegúrese de llenar correctamente el documento',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.black.withOpacity(0.55),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Planta
                          Text(
                            'Motivo',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 6),
                          fieldContainer(
                            child: TextFormField(
                              controller: _description,
                              decoration: inputDec('Motivo'),
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? 'Ingrese el motivo'
                                      : null,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Hora de inicio / Hora de término
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hora de inicio',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    const SizedBox(height: 6),
                                    fieldContainer(
                                      child: TextFormField(
                                        controller: _startTime,
                                        readOnly: true,
                                        decoration: inputDec('Hora de inicio'),
                                        onTap: () async {
                                          FocusScope.of(context).unfocus();
                                          await _pickTime(_startTime);
                                        },
                                        validator: (v) {
                                          final txt = v?.trim() ?? '';
                                          if (_endTime.text.isNotEmpty && txt.isEmpty) {
                                            return 'Ingrese la hora de inicio';
                                          }
                                          if (txt.isNotEmpty && _tryParseHHmm(txt) == null){
                                            return 'Formato inválido (HH:mm)';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hora de termino',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    const SizedBox(height: 6),
                                    fieldContainer(
                                      child: TextFormField(
                                        controller: _endTime,
                                        readOnly: true,
                                        decoration: inputDec('Hora de termino'),
                                        onTap: () async {
                                          FocusScope.of(context).unfocus();
                                          await _pickTime(_endTime);
                                        },
                                        validator: (v) {
                                          final txt = v?.trim() ?? '';
                                          if (_startTime.text.isNotEmpty && txt.isEmpty) {
                                            return 'Ingrese la hora de termino';
                                          }
                                          if (txt.isNotEmpty && _tryParseHHmm(txt) == null){
                                            return 'Formato inválido (HH:mm)';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Text(
                            'Responsable',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 6),
                          fieldContainer(
                            child: DropdownButtonFormField<String>(
                              value: _responsable,
                              decoration: inputDec('Responsable'),
                              items: const [
                                DropdownMenuItem(value: 'Cliente', child: Text('Cliente')),
                                DropdownMenuItem(value: 'Ayasa', child: Text('Ayasa')),
                              ],
                              onChanged: (v) => setState(() => _responsable = v),
                              validator: (v) => v == null ? 'Seleccione una especialidad' : null,
                            ),
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 155), // Here I manually add space for the 'Anterior' and 'Siguiente' buttons

                  // botones
                  SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        // Botón anterior
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
                ], 
              )
            )
          ],
        ),
      ),
    );
  }
  
  String _formatHHmm(TimeOfDay  t){
    final h = t.hour.toString().padLeft(2,'0');
    final m = t.minute.toString().padLeft(2,'0');
    return '$h:$m';
  }

  TimeOfDay? _tryParseHHmm(String value){
    final parts = value.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h ==  null || m == null || h < 0 || h > 23 || m < 0 || m > 59) return null;
    return TimeOfDay(hour: h, minute: m);
  }

  // Open the selector and set the selected time to the controller in HH:mm format
  Future<void> _pickTime(TextEditingController target) async {
    final initial = _tryParseHHmm(target.text) ?? TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      initialEntryMode: TimePickerEntryMode.dial,
      builder:(context, child) {
        // Force 24-hour format
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
      helpText: 'Seleccione la hora',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );
    if (picked != null) {
      target.text = _formatHHmm(picked);
    }
  }

  // used to validate is start time is before end time 
  String? _validateTimeOrder(){
    final s = _tryParseHHmm(_startTime.text.trim());
    final e = _tryParseHHmm(_endTime.text.trim());
    if (s == null || e == null) return null;
    final sm = s.hour * 60 + s.minute;
    final em = e.hour * 60 + e.minute;
    if (sm >= em) return 'La hora de inicio debe ser antes de la hora de término';
    return null;
  }
}
