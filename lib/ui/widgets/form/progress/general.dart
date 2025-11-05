import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../header_form.dart';
import '../../progress_bar_form.dart';

class GeneralPage extends StatefulWidget {
  const GeneralPage({super.key});

  @override
  State<GeneralPage> createState() => _GeneralPageState();
}

class _GeneralPageState extends State<GeneralPage> {
  // form
  final _formKey = GlobalKey<FormState>();
  final _orderSaleCtrl = TextEditingController();
  final _obraCtrl = TextEditingController();
  final _workplaceCtrl = TextEditingController();
  final _quoteNumber = TextEditingController();
  bool _isRFQ = false;
  String? _especialidad;

  // progress bar form 
  static const steps = [
    StepItem(icon: Icons.info_outline, label: 'General'),
    StepItem(icon: Icons.description, label: 'Descripción'),
    StepItem(icon: Icons.checklist, label: 'Avances'),
    StepItem(icon: Icons.badge, label: 'Personal'),
    StepItem(icon: Icons.warning_amber, label: 'Contratiempos'),
  ];

  // styles
  static const Color brand = Color(0xFF8B1E04); // botón / step activo
  static const Color line  = Color.fromARGB(255, 229, 229, 229); // divisores / bordes suaves
  static const double radius = 12;

  InputDecoration _inputDec(String label, {String? hint, Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF1F1F1),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: brand, width: 1.5),
      ),
      suffixIcon: suffixIcon,
    );
  }

  @override
  void dispose() {
    _orderSaleCtrl.dispose();
    _obraCtrl.dispose();
    _workplaceCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;
    _formKey.currentState?.save();
    // TODO: navega a la siguiente pantalla de tu flujo
    // Navigator.push(...);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Formulario válido. Continuando…')),
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
              title: 'Bitácora de actividades diarias por servicio'
            ),
            StepProgressBar(
              steps: steps,
              currentIndex: 0,
              activeColor: brand,
              inactiveColor: line,
        
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(6, 20, 6, 16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: line),
                      borderRadius: BorderRadius.circular(radius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título y subtítulo del bloque
                          Text(
                            'Datos generales del trabajo',
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

                          // OC/Pedido
                          TextFormField(
                            controller: _orderSaleCtrl,
                            decoration: _inputDec('OC/Pedido'),
                            validator: (v) =>
                                (v == null || v.trim().isEmpty) ? 'Ingrese la órden de venta o pedido' : null,
                          ),
                          const SizedBox(height: 20),

                          // OR/RFQ + switch
                          Row(
                            children: [
                              Text(
                                'OR/RFQ',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(width: 15),
                              CupertinoSwitch(
                                value: _isRFQ,
                                activeColor: brand,
                                onChanged: (v) => setState(() => _isRFQ = v),

                                // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              const SizedBox(width: 25),
                              if (_isRFQ)
                                Flexible(
                                  child: TextFormField(
                                    controller: _quoteNumber,
                                    decoration: _inputDec('No. Cotización'),
                                    validator: (v) => (v == null && _isRFQ) ? 'Ingrese el número de cotización' : null,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Obra
                          TextFormField(
                            controller: _obraCtrl,
                            decoration: _inputDec('Obra'),
                            validator: (v) =>
                                (v == null || v.trim().isEmpty) ? 'Ingrese la obra' : null,
                          ),
                          const SizedBox(height: 25),

                          // CT
                          TextFormField(
                            controller: _workplaceCtrl,
                            decoration: _inputDec('Centro de trabajo'),
                            validator: (v) =>
                                (v == null || v.trim().isEmpty) ? 'Ingrese el centro de trabajo' : null,
                          ),
                          const SizedBox(height: 25),

                          // Especialidad del trabajo (dropdown)
                          DropdownButtonFormField<String>(
                            value: _especialidad,
                            decoration: _inputDec('Especialidad del trabajo'),
                            items: const [
                              DropdownMenuItem(value: 'Civil', child: Text('Civil')),
                              DropdownMenuItem(value: 'Eléctrica', child: Text('Eléctrica')),
                              DropdownMenuItem(value: 'Mecánica', child: Text('Mecánica')),
                              DropdownMenuItem(value: 'Instrumentación', child: Text('Instrumentación')),
                            ],
                            onChanged: (v) => setState(() => _especialidad = v),
                            validator: (v) => v == null ? 'Seleccione una especialidad' : null,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // BOTÓN SIGUIENTE (ancho completo)
                  SafeArea(
                    top: false,
                    child: SizedBox(
                      width: double.infinity,
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
                            Text('Siguiente'),
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
        ),
      ),
    );
  }
}
