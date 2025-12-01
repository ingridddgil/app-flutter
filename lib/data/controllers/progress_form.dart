import '../models/progress_general.dart';
import '../models/progress_description.dart';
import '../models/progress_activity.dart';
import '../models/progress_personnel.dart';
import '../models/progress_issues.dart';
import '../models/progress_data.dart';



class ProgressFormController {
  ProgressGeneral? general;
  ProgressDescription? description;
  final List<ProgressActivity> activities = [];
  final List<ProgressPersonnel> personnel = [];
  ProgressIssues? issues;
  String? _editingId;

  // Singleton :D
  ProgressFormController._internal();
  static final ProgressFormController instance = ProgressFormController._internal();

  bool get isEditing => _editingId != null;
  String? get editingId => _editingId;

  void loadFrom(ProgressData data) {
    _editingId = data.id;
    general = data.general;
    description = data.description;

    activities
      ..clear()
      ..addAll(data.activity);

    personnel
      ..clear()
      ..addAll(data.personnel);

    issues = data.issue;
  }

  void reset({bool keepEditingId = false}) {
    general = null;
    description = null;
    activities.clear();
    personnel.clear();
    issues = null;

    if (!keepEditingId) {
      _editingId = null;
    }
  }


  ProgressData buildProgressData() {
    return ProgressData(
      id: _editingId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      general: general!,
      description: description!,
      activity: List.unmodifiable(activities),
      personnel: List.unmodifiable(personnel),
      issue: issues!,
    );
  }
}