import 'package:flutter_demo/data/models/progress_general.dart';
import 'package:flutter_demo/data/models/progress_description.dart';
import 'package:flutter_demo/data/models/progress_activity.dart';
import 'package:flutter_demo/data/models/progress_personnel.dart';
import 'package:flutter_demo/data/models/progress_issues.dart';


class ProgressData {
  final ProgressGeneral general;
  final ProgressDescription description;
  final ProgressPersonnel personnel;
  final ProgressActivity activity;
  final ProgressIssues issue;

  const ProgressData({
    required this.general,
    required this.description,
    required this.activity,
    required this.personnel,
    required this.issue,
  });

  ProgressData copyWith({
    ProgressGeneral? general,
    ProgressDescription? description,
    ProgressActivity? activity,
    ProgressPersonnel? personnel,
    ProgressIssues? issue,
  }) {
    return ProgressData(
      general: general ?? this.general,
      description: description ?? this.description,
      activity: activity ?? this.activity,
      personnel: personnel ?? this.personnel,
      issue: issue ?? this.issue,
    );
  }
}