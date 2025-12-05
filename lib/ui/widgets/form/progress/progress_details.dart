import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/widgets/progress_bar.dart';
import '../../header_form.dart';
import '../../progress_bar_form.dart';
import '../../../styles/progress_bar_form_theme.dart';
import '../../../../data/models/progress_activity.dart';
import 'package:flutter_demo/ui/styles/styles.dart';

class ProgressDetailsPage extends StatefulWidget {
  final ProgressActivity? initial;
  const ProgressDetailsPage({super.key, this.initial});

  @override
  State<ProgressDetailsPage> createState() => _ProgressDetailsPageState();
}

class _ProgressDetailsPageState extends State<ProgressDetailsPage> {
  // form
  final _formKey = GlobalKey<FormState>();
  final _taskCtrl = TextEditingController();
  final _detailCtrl = TextEditingController();
  final _quantityExecutedCtrl = TextEditingController();
  final _quantityRequestedCtrl = TextEditingController();
  final _quantityRemainingCtrl = TextEditingController();
  final _amountTotalCtrl = TextEditingController();
  final _amountRemainingCtrl = TextEditingController();
  final _amountDisbursedCtrl = TextEditingController();

  double _percentageProgress = 0.0;
  double _cumulativePercentageCtrl = 0.0;

  // progress bar form 
  static const steps = [
    StepItem(icon: Icons.info_outline, label: 'General'),
    StepItem(icon: Icons.description, label: 'Descripción'),
    StepItem(icon: Icons.checklist, label: 'Avances'),
    StepItem(icon: Icons.badge, label: 'Personal'),
    StepItem(icon: Icons.warning_amber, label: 'Contratiempos'),
  ];

  double _toDoubleSafely(String value) {
    return double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
  }

  @override
  void dispose() {
    _taskCtrl.dispose();
    _detailCtrl.dispose();
    _quantityExecutedCtrl.dispose();
    _quantityRequestedCtrl.dispose();
    _quantityRemainingCtrl.dispose();
    _amountTotalCtrl.dispose();
    _amountRemainingCtrl.dispose();
    _amountDisbursedCtrl.dispose();
    super.dispose();
  }

void _submit() {
  final ok = _formKey.currentState?.validate() ?? false;
  if (!ok) return;

  final executed = _toDoubleSafely(_quantityExecutedCtrl.text);
  final requested = _toDoubleSafely(_quantityRequestedCtrl.text);
  final remaining = _toDoubleSafely(_quantityRemainingCtrl.text);
  final amountTotal = _toDoubleSafely(_amountTotalCtrl.text);
  final amountRemaining = _toDoubleSafely(_amountRemainingCtrl.text);
  final amountDisbursed = _toDoubleSafely(_amountDisbursedCtrl.text);

  final activity = ProgressActivity(
    task: _taskCtrl.text.trim(),
    detail: _detailCtrl.text.trim(),
    quantityExecuted: executed,
    quantityRequested: requested,
    quantityRemaining: remaining,
    amountTotal: amountTotal,
    amountRemaining: amountRemaining,
    amountDisbursed: amountDisbursed,
    percentageProgress: _percentageProgress,
    cumulativePercentage: _cumulativePercentageCtrl,
  );
    Navigator.pop(context, activity);


  }

  void _back() {
    Navigator.pop(context);
  }

  @override 
  void initState() {
    super.initState();

    final d = widget.initial;
    if (d != null) {
      _taskCtrl.text = d.task;
      _detailCtrl.text = d.detail;
      _quantityExecutedCtrl.text = d.quantityExecuted.toString();
      _quantityRequestedCtrl.text = d.quantityRequested.toString();
      _quantityRemainingCtrl.text = d.quantityRemaining.toString();
      _amountTotalCtrl.text = d.amountTotal.toString();
      _amountRemainingCtrl.text = d.amountRemaining.toString();
      _amountDisbursedCtrl.text = d.amountDisbursed.toString();
      _percentageProgress = d.percentageProgress;
      _cumulativePercentageCtrl = d.cumulativePercentage;
    }
    _quantityExecutedCtrl.addListener(_recalculateProgress);
    _quantityRequestedCtrl.addListener(_recalculateProgress);
  }

  void _recalculateProgress() {
    final executed = _toDoubleSafely(_quantityExecutedCtrl.text);
    final requested = _toDoubleSafely(_quantityRequestedCtrl.text);
    final ratio = (requested > 0.0) ? (executed / requested) : 0.0;
    final clamped = ratio.clamp(0.0, 1.0);
    setState(() {
      _percentageProgress = clamped;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Headerform(
              title: 'Bitácora de actividades diarias por servicio',
            ),
            StepProgressBar(
              steps: steps, 
              currentIndex: 2,
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
                      borderRadius: BorderRadius.circular(radius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detalles del avance',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 2),

                          Text(
                            'Asegúrese de llenar correctamente el formulario',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.black.withOpacity(0.55),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // --- Tarea / Partida ---
                          Text(
                            'Tarea/ Partida',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 6),
                          fieldContainer(
                            child: TextFormField(
                              controller: _taskCtrl,
                              decoration: inputDec('Tarea/ Partida'),
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? 'Ingrese la tarea'
                                      : null,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // --- Detalle del avance ---
                          Text(
                            'Detalle del avance',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 6),
                          fieldContainer(
                            child: TextFormField(
                              controller: _detailCtrl,
                              decoration: inputDec('Detalle del avance'),
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? 'Ingrese el detalle del avance'
                                      : null,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // --- Cantidad ejecutada / Monto total ---
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Cantidad ejecutada',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    const SizedBox(height: 6),
                                    fieldContainer(
                                      child: TextFormField(
                                        controller: _quantityExecutedCtrl,
                                        decoration:
                                            inputDec('Cantidad ejecutada'),
                                        validator: (v) =>
                                            (v == null || v.trim().isEmpty)
                                                ? 'Ingrese la cantidad ejecutada'
                                                : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Monto total',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    const SizedBox(height: 6),
                                    fieldContainer(
                                      child: TextFormField(
                                        controller: _amountTotalCtrl,
                                        decoration: inputDec('Monto total'),
                                        validator: (v) =>
                                            (v == null || v.trim().isEmpty)
                                                ? 'Ingrese el monto total'
                                                : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // --- Cantidad solicitada / Monto entregado ---
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Cantidad solicitada',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    const SizedBox(height: 6),
                                    fieldContainer(
                                      child: TextFormField(
                                        controller: _quantityRequestedCtrl,
                                        decoration:
                                            inputDec('Cantidad solicitada'),
                                        validator: (v) =>
                                            (v == null || v.trim().isEmpty)
                                                ? 'Ingrese la cantidad solicitada'
                                                : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Monto entregado',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    const SizedBox(height: 6),
                                    fieldContainer(
                                      child: TextFormField(
                                        controller: _amountDisbursedCtrl,
                                        decoration:
                                            inputDec('Monto entregado'),
                                        validator: (v) =>
                                            (v == null || v.trim().isEmpty)
                                                ? 'Ingrese el monto entregado'
                                                : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // --- Cantidad restante / Monto faltante ---
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Cantidad restante',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    const SizedBox(height: 6),
                                    fieldContainer(
                                      child: TextFormField(
                                        controller: _quantityRemainingCtrl,
                                        decoration:
                                            inputDec('Cantidad restante'),
                                        validator: (v) =>
                                            (v == null || v.trim().isEmpty)
                                                ? 'Ingrese la cantidad restante'
                                                : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Monto faltante',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    const SizedBox(height: 6),
                                    fieldContainer(
                                      child: TextFormField(
                                        controller: _amountRemainingCtrl,
                                        decoration:
                                            inputDec('Monto faltante'),
                                        validator: (v) =>
                                            (v == null || v.trim().isEmpty)
                                                ? 'Ingrese el monto faltante'
                                                : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // --- Progress Bar ---
                          ProgressBar(progress: _percentageProgress, height: 20),
                          const SizedBox(height: 16),

                          const SizedBox(height: 24),
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
