class ProjectData {
  final int id;
  final String name;
  final String partner;
  final String company;

  const ProjectData({
    required this.id,
    required this.name,
    required this.partner,
    required this.company,
  });

  factory ProjectData.fromOdoo(Map<String, dynamic> json) {
    return ProjectData(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      name: (json['name'] ?? 'Proyecto sin nombre').toString(),
      partner: _parseMany2One(json['partner_id']),
      company: _parseMany2One(json['company_id']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'partner': partner,
        'company': company,
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
}
