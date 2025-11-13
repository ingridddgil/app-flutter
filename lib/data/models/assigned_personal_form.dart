import 'dart:typed_data';

class AssignedPersonData {
  final String id;
  final String name;
  final String category;
  final double normalHours;
  final Uint8List? signature; // null if not signed yet

  AssignedPersonData({
    required this.id,
    required this.name,
    required this.category,
    required this.normalHours,
    this.signature,
  });

  AssignedPersonData copyWith({
    String? id,
    String? name,
    String? category,
    double? normalHours,
    Uint8List? signature,
  }) {
    return AssignedPersonData(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      normalHours: normalHours ?? this.normalHours,
      signature: signature ?? this.signature,
    );
  }
}
