import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../header_form.dart';
import '../../progress_bar_form.dart';
import '../../../styles/progress_bar_form_theme.dart';
import 'description.dart';
import '../../../../data/models/progress_general.dart';
import '../../../../data/controllers/progress_form.dart';

class GeneralPage extends StatefulWidget {
  const GeneralPage({super.key});

  @override
  State<GeneralPage> createState() => _GeneralPageState();
}

class _GeneralPageState extends State<GeneralPage> {
  // form
  final _formKey = GlobalKey<FormState>();
  final _orderSaleCtrl = TextEditingController();
  final _workplaceCtrl = TextEditingController();
  final _quoteNumber = TextEditingController();
  bool _isRFQ = false;
  String? _especialty;

  // progress bar form 
  static const steps = [
    StepItem(icon: Icons.info_outline, label: 'General'),
    StepItem(icon: Icons.description, label: 'Descripción'),
    StepItem(icon: Icons.checklist, label: 'Avances'),
    StepItem(icon: Icons.badge, label: 'Personal'),
    StepItem(icon: Icons.warning_amber, label: 'Contratiempos'),
  ];

  @override
  void initState() {
    super.initState();

    final form = ProgressFormController.instance;
    final saved = form.general;

    if (saved != null) {
      _orderSaleCtrl.text = saved.orderSale;
      _workplaceCtrl.text = saved.workPlace;
      _quoteNumber.text = saved.quoteNumber;
      _especialty = saved.especialty;
      _isRFQ = saved.rfq == 'RFQ';
    }
  }

  @override
  void dispose() {
    _orderSaleCtrl.dispose();
    _workplaceCtrl.dispose();
    _quoteNumber.dispose();
    super.dispose();
  }

  void _submit() {
    // final ok = _formKey.currentState?.validate() ?? false;
    // if (!ok) return;

    // _formKey.currentState?.save();

    final general = ProgressGeneral(
      orderSale: _orderSaleCtrl.text.trim(),
      workPlace: _workplaceCtrl.text.trim(),
      quoteNumber: _isRFQ ? _quoteNumber.text.trim() : '',
      rfq: _isRFQ ? 'RFQ' : 'OR',
      especialty: _especialty ?? '',
    );
    ProgressFormController.instance.general = general;
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DescriptionPage(general: general)),
    );
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
            Headerform(title: 'Bitácora de actividades diarias por servicio'),
            StepProgressBar(
              steps: steps,
              currentIndex: 0,
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
                      // border: Border.all(color: line),
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
                          const SizedBox(height: 16),

                          // OC/Pedido (label arriba + sombra)
                          Text(
                            'OC/Pedido',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 6),
                          fieldContainer(
                            child: TextFormField(
                              controller: _orderSaleCtrl,
                              decoration: inputDec('OC/Pedido'),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Ingrese la órden de venta o pedido'
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // OR/RFQ + switch + (opcional) No. Cotización
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'OR/RFQ',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(width: 15),
                              CupertinoSwitch(
                                value: _isRFQ,
                                activeColor: brand,
                                onChanged: (v) => setState(() => _isRFQ = v),
                              ),
                              const SizedBox(width: 25),
                              if (_isRFQ)
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'No. Cotización',
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      ),
                                      const SizedBox(height: 6),
                                      fieldContainer(
                                        child: TextFormField(
                                          controller: _quoteNumber,
                                          decoration: inputDec('No. Cotización'),
                                          validator: (v) {
                                            if (_isRFQ && (v == null || v.trim().isEmpty)) {
                                              return 'Ingrese el número de cotización';
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
                          const SizedBox(height: 20),

                          // Centro de trabajo
                          Text(
                            'Centro de trabajo',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 6),
                          fieldContainer(
                            child: TextFormField(
                              controller: _workplaceCtrl,
                              decoration: inputDec('Centro de trabajo'),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Ingrese el centro de trabajo'
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 25),

                          // especialty del trabajo (dropdown) con mismo estilo
                          Text(
                            'Especialidad del trabajo',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 6),
                          fieldContainer(
                            child: DropdownButtonFormField<String>(
                              value: _especialty,
                              decoration: inputDec('Especialidad del trabajo'),
                              items: const [
                                DropdownMenuItem(value: 'Civil', child: Text('Civil')),
                                DropdownMenuItem(value: 'Eléctrica', child: Text('Eléctrica')),
                                DropdownMenuItem(value: 'Mecánica', child: Text('Mecánica')),
                                DropdownMenuItem(value: 'Instrumentación', child: Text('Instrumentación')),
                              ],
                              onChanged: (v) => setState(() => _especialty = v),
                              validator: (v) => v == null ? 'Seleccione una especialidad' : null,
                            ),
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
