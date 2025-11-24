class ProgressActivity {
  final String task;
  final String detail; 
  final double quantityExecuted; 
  final double quantityRequested; 
  final double quantityRemaining; 
  final double amountTotal; 
  final double amountRemaining; 
  final double amountDisbursed; 
  final double percentageProgress;
  final double cumulativePercentage;

  const ProgressActivity({
    required this.task,
    required this.detail,
    required this.quantityExecuted,
    required this.quantityRequested,
    required this.quantityRemaining,
    required this.amountTotal,
    required this.amountRemaining,
    required this.amountDisbursed,
    required this.percentageProgress,
    required this.cumulativePercentage,
  });

  // ProgressActivity copyWith({
  //   String? task,
  //   String? detail,
  //   double? quantityExecuted,
  //   double? quantityRequested,
  //   double? quantityRemaining,
  //   double? amountTotal,
  //   double? amountRemaining,
  //   double? amountDisbursed,
  //   double? percentageProgress,
  //   double? cumulativePercentage,  
  // }) {
  //   return ProgressActivity(
  //     task: task ?? this.task,
  //     detail: detail ?? this.detail,
  //     quantityExecuted: quantityExecuted ?? this.quantityExecuted,
  //     quantityRequested: quantityRequested ?? this.quantityRequested,
  //     quantityRemaining: quantityRemaining ?? this.quantityRemaining,
  //     amountTotal: amountTotal ?? this.amountTotal,
  //     amountRemaining: amountRemaining ?? this.amountRemaining,
  //     amountDisbursed: amountDisbursed ?? this.amountDisbursed,
  //     percentageProgress: percentageProgress ?? this.percentageProgress,
  //     cumulativePercentage: cumulativePercentage ?? this.cumulativePercentage,
  //   );
  // }
  
  Map<String, dynamic> toJson() => {
    'task': task,
    'detail': detail,
    'quantityExecuted': quantityExecuted,
    'quantityRequested': quantityRequested,
    'quantityRemaining': quantityRemaining,
    'amountTotal': amountTotal,
    'amountRemaining': amountRemaining,
    'amountDisbursed': amountDisbursed,
    'percentageProgress': percentageProgress,
    'cumulativePercentage': cumulativePercentage,
  };

  factory ProgressActivity.fromJson(Map<String, dynamic> json) {
    return ProgressActivity(
      task: json['task'] ?? '',
      detail: json['detail'] ?? '',
      quantityExecuted: (json['quantityExecuted'] ?? 0).toDouble(),
      quantityRequested: (json['quantityRequested'] ?? 0).toDouble(),
      quantityRemaining: (json['quantityRemaining'] ?? 0).toDouble(),
      amountTotal: (json['amountTotal'] ?? 0).toDouble(),
      amountRemaining: (json['amountRemaining'] ?? 0).toDouble(),
      amountDisbursed: (json['amountDisbursed'] ?? 0).toDouble(),
      percentageProgress: (json['percentageProgress'] ?? 0).toDouble(),
      cumulativePercentage: (json['cumulativePercentage'] ?? 0).toDouble(),
    );
  }
}
