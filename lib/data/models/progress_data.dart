import 'package:flutter_demo/data/models/progress_general.dart';
import 'package:flutter_demo/data/models/progress_description.dart';
import 'package:flutter_demo/data/models/progress_activity.dart';
import 'package:flutter_demo/data/models/progress_personnel.dart';
import 'package:flutter_demo/data/models/progress_issues.dart';

class ProgressData {
  final String id;
  final ProgressGeneral general;
  final ProgressDescription description;
  final List<ProgressActivity> activity;
  final List<ProgressPersonnel> personnel;
  final ProgressIssues issue;

  const ProgressData({
    required this.id,
    required this.general,
    required this.description,
    required this.activity,
    required this.personnel,
    required this.issue,
  });

  ProgressData copyWith({
    String? id,
    ProgressGeneral? general,
    ProgressDescription? description,
    List<ProgressActivity>? activity,
    List<ProgressPersonnel>? personnel,
    ProgressIssues? issue,
  }) {
    return ProgressData(
      id: id ?? this.id,
      general: general ?? this.general,
      description: description ?? this.description,
      activity: activity ?? this.activity,
      personnel: personnel ?? this.personnel,
      issue: issue ?? this.issue,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'general': general.toJson(),
    'description': description.toJson(),
    'activity': activity.map((a) => a.toJson()).toList(),
    'personnel': personnel.map((p) => p.toJson()).toList(),
    'issue': issue.toJson(),
  };

  factory ProgressData.fromJson(Map<String, dynamic> json) {
    return ProgressData(
      id: json['id'] ?? '',
      general: ProgressGeneral.fromJson(json['general']),
      description: ProgressDescription.fromJson(json['description']),
      activity: (json['activity'] as List<dynamic>? ?? [])
          .map((e) => ProgressActivity.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      personnel: (json['personnel'] as List<dynamic>? ?? [])
          .map((e) => ProgressPersonnel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      issue: ProgressIssues.fromJson(json['issue']),
    );
  }
}
