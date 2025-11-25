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

  Map<String, dynamic> toJson() => {
    'companyPremises': companyPremises,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'clientSupervisor': clientSupervisor,
    'supervisor': supervisor,
    'workArea': workArea,
    'license': license,
  };

  factory ProgressDescription.fromJson(Map<String, dynamic> json) {
    return ProgressDescription(
      companyPremises: json['companyPremises'] ?? '',
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      clientSupervisor: json['clientSupervisor'] ?? '',
      supervisor: json['supervisor'] ?? '',
      workArea: json['workArea'] ?? '',
      license: json['license'] ?? '',
    );
  }
}
