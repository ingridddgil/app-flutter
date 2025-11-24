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
}
