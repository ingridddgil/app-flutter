import 'dart:typed_data';

class ProgressPersonnel {
  final String id;
  final String name;
  final String category;
  final double normalHours;
  final Uint8List? signature; // null if not signed yet

  ProgressPersonnel({
    required this.id,
    required this.name,
    required this.category,
    required this.normalHours,
    this.signature,
  });

  // ProgressPersonnel copyWith({
  //   String? id,
  //   String? name,
  //   String? category,
  //   double? normalHours,
  //   Uint8List? signature,
  // }) {
  //   return ProgressPersonnel(
  //     id: id ?? this.id,
  //     name: name ?? this.name,
  //     category: category ?? this.category,
  //     normalHours: normalHours ?? this.normalHours,
  //     signature: signature ?? this.signature,
  //   );
  // }

  Map<String, dynamic> toJson() => {
    'id': id ,
    'name': name,
    'category': category,
    'normalHours': normalHours,
    'signature': signature,
  };

  factory ProgressPersonnel.fromJson(Map<String, dynamic> json) {
    return ProgressPersonnel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      normalHours: json['normalHours'] ?? '',
    );
  } 

}
