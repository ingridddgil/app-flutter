class ProjectData {
  final String name;
  final List<String> labelTasks = [];
  final String partner;
  final String company;
  final String superintendent;
  final String supervisor;
  final String coordinator;
  final DateTime? startDate;
  final double allocatedHours;
  final String status;

  ProjectData({
    required this.name,
    required this.partner,
    required this.company,
    required this.superintendent,
    required this.supervisor,
    required this.coordinator,
    required this.startDate,
    required this.allocatedHours,
    required this.status,
  });

  factory ProjectData.fromJson(Map<String, dynamic> json) {
  // helper para Many2one: [id, "Name"]
  String _m2oName(dynamic field) {
    if (field is List && field.length > 1) {
      return field[1] as String;
    }
    return '';
  }

  DateTime? _parseDate(dynamic value) {
    if (value == null || value == '') return null;
    try {
      return DateTime.parse(value as String);
    } catch (_) {
      return null;
    }
  }

  return ProjectData(
    name: json['name'] as String? ?? '',
    partner: _m2oName(json['partner_id']),
    company: _m2oName(json['company_id']),
    superintendent: _m2oName(json['user_id']),
    supervisor: json['supervisor'] as String? ?? '',
    coordinator: json['coordinador'] as String? ?? '',
    startDate: _parseDate(json['date_start']),
    allocatedHours: (json['allocated_hours'] as num?)?.toDouble() ?? 0.0,
    status: json['state'] as String? ?? '',
  );
}


}