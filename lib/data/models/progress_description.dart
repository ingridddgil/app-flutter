class ProgressDescription {
  final String companyPremises; 
  final DateTime startTime;
  final DateTime endTime;
  final String clientSupervisor;
  final String supervisor;
  final String workArea;
  final String license;

  const ProgressDescription({
    required this.companyPremises,
    required this.startTime,
    required this.endTime,
    required this.clientSupervisor,
    required this.supervisor,
    required this.workArea,
    required this.license,
  });

  ProgressDescription copyWith({
    String? companyPremises,
    DateTime? startTime,
    DateTime? endTime,
    String? clientSupervisor,
    String? supervisor,
    String? workArea,
    String? license,
  }) {
    return ProgressDescription(
      companyPremises: companyPremises ?? this.companyPremises,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      clientSupervisor: clientSupervisor ?? this.clientSupervisor,
      supervisor: supervisor ?? this.supervisor,
      workArea: workArea ?? this.workArea,
      license: license ?? this.license,
    );
  }
}
