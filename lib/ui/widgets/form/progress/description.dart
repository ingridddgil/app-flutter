import 'package:flutter/material.dart';
import '../../header_form.dart';
import '../../progress_bar_form.dart';
import '../../../styles/progress_bar_form_theme.dart';
import 'general.dart';
import 'progress_details.dart';

class DescriptionPage extends StatefulWidget {
  const DescriptionPage({super.key});

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  // Description form
  final _formKey = GlobalKey<FormState>();
  final _companyPremises = TextEditingController();
  final _startTime = TextEditingController();
  final _endTime = TextEditingController();
  final _clientSupervisor = TextEditingController();
  final _supervisor = TextEditingController();
  final _workArea = TextEditingController();
  final _license = TextEditingController();

  static const steps = [
    StepItem(icon: Icons.info_outline, label: 'General'),
    StepItem(icon: Icons.description, label: 'Descripción'),
    StepItem(icon: Icons.checklist, label: 'Avances'),
    StepItem(icon: Icons.badge, label: 'Personal'),
    StepItem(icon: Icons.warning_amber, label: 'Contratiempos'),
  ];
  
  @override
  void dispose() {
    _companyPremises.dispose();
    _startTime.dispose();
    _endTime.dispose();
    _clientSupervisor.dispose();
    _supervisor.dispose();
    _workArea.dispose();
    _license.dispose();
    super.dispose();    
  }

  void _submit() {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;
    final companyPremises = _companyPremises.text.trim();
    final startTime = _startTime.text.trim();
    final endTime = _endTime.text.trim();    
    final clientSupervisor = _clientSupervisor.text.trim();
    final supervisor = _supervisor.text.trim();
    final workArea = _workArea.text.trim();
    final license = _license.text.trim();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProgressDetailsPage()),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Formulario válido.')),
    );
  }

  void _back(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GeneralPage()),
    );
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
              currentIndex: 1,
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
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 4),

                          Text(
                            'Asegúrese de llenar correctamente el documento',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.black.withOpacity(0.55),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _companyPremises,
                            decoration: inputDec('Planta'),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingrese la planta' :  null,
                          ),
                          SizedBox(height: 16),
                          Row (
                            children: [
                              Expanded(
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
                              const SizedBox(width: 12),
                              Expanded (
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
                          const SizedBox(height: 20),

                          TextFormField(
                            controller: _clientSupervisor,
                            decoration: inputDec('Supervisor del cliente'),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingrese el supervisor del cliente' : null,
                          ),
                          const SizedBox(height: 20),

                          TextFormField(
                            controller: _supervisor,
                            decoration: inputDec('Supervisor interno'),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingrese el supervisor interno' : null,
                          ),
                          SizedBox(height: 20), 

                          TextFormField(
                            controller: _workArea,
                            decoration: inputDec('Área de trabajo'),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingrese el área de trabajo' : null,
                          ),
                          SizedBox(height: 20),

                          TextFormField(
                            controller: _license,
                            decoration: inputDec('Licencia/OM'),
                            validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingrese la licencia ambiental' : null,
                          ),  
                          SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  //botón siguiente

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
                                  side: BorderSide(color: brand),
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