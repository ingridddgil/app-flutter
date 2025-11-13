class ProgressDetailsData {
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

  const ProgressDetailsData({
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

  ProgressDetailsData copyWith({
    String? task,
    String? detail,
    double? quantityExecuted,
    double? quantityRequested,
    double? quantityRemaining,
    double? amountTotal,
    double? amountRemaining,
    double? amountDisbursed,
    double? percentageProgress,
    double? cumulativePercentage,  
  }) {
    return ProgressDetailsData(
      task: task ?? this.task,
      detail: detail ?? this.detail,
      quantityExecuted: quantityExecuted ?? this.quantityExecuted,
      quantityRequested: quantityRequested ?? this.quantityRequested,
      quantityRemaining: quantityRemaining ?? this.quantityRemaining,
      amountTotal: amountTotal ?? this.amountTotal,
      amountRemaining: amountRemaining ?? this.amountRemaining,
      amountDisbursed: amountDisbursed ?? this.amountDisbursed,
      percentageProgress: percentageProgress ?? this.percentageProgress,
      cumulativePercentage: cumulativePercentage ?? this.cumulativePercentage,
    );
  }
}