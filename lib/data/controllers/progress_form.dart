import '../models/progress_general.dart';
import '../models/progress_description.dart';
import '../models/progress_activity.dart';
import '../models/progress_personnel.dart';
import '../models/progress_issues.dart';
import '../models/progress_details_data.dart';



class ProgressFormController {
  ProgressGeneral? general;
  ProgressDescription? description;
  final List<ProgressActivity> activities = [];
  final List<ProgressPersonnel> personnel = [];
  ProgressIssues? issues;

  // Singleton :D
  static final ProgressFormController instance = ProgressFormController._();
  ProgressFormController._();

  void reset() {
    general = null;
    description = null;
    activities.clear();
    personnel.clear();
    issues = null;
  } 

  ProgressData buildProgressData() {
    return ProgressData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      general: general!,
      description: description!,
      activity: List.unmodifiable(activities),
      personnel: List.unmodifiable(personnel),
      issue: issues!,
    );
  }
}