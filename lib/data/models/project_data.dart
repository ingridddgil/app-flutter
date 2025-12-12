class ProjectData {
  final int id;
  final String name;
  final String partner;
  final String company;
  final String superintendent;
  final String supervisor;
  final String coordinator;
  final DateTime? startDate;
  final double allocatedHours;
  final String status;

  const ProjectData({
    required this.id,
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

  factory ProjectData.fromOdoo(Map<String, dynamic> json) {
    return ProjectData(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      name: (json['name'] ?? 'Proyecto sin nombre').toString(),
      partner: _parseMany2One(json['partner_id']),
      company: _parseMany2One(json['company_id']),
      superintendent: _parseMany2One(json['user_id']),
      supervisor: _parseMany2One(json['supervisor']),
      coordinator: _parseMany2One(json['coordinador']),
      startDate: _parseDate(json['date_start']),
      allocatedHours: (json['allocated_hours'] as num?)?.toDouble() ?? 0.0,
      status: json['state'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'partner': partner,
        'company': company,
        'superintendent': superintendent,
        'supervisor': supervisor,
        'coordinator': coordinator,
        'startDate': startDate?.toIso8601String(),
        'allocatedHours': allocatedHours,
        'status': status,
      };

  static String _parseMany2One(dynamic value) {
    if (value is List && value.length >= 2) {
      return value[1]?.toString() ?? '';
    }
    if (value is Map<String, dynamic>) {
      return value['name']?.toString() ?? '';
    }
    if (value is String) {
      return value;
    }
    if (value is num) {
      return value.toString();
    }
    return '';
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}