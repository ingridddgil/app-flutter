class ProgressIssues {
  final DateTime issueStartTime;
  final DateTime issueEndTime;
  final String description;
  final String responsable;

  const ProgressIssues({
    required this.issueStartTime,
    required this.issueEndTime,
    required this.description,
    required this.responsable,
  });

  ProgressIssues copyWith({
    DateTime? issueStartTime,
    DateTime? issueEndTime,
    String? description,
    String? responsable,
  }) {
    return ProgressIssues(
      issueStartTime: issueStartTime ?? this.issueStartTime,
      issueEndTime: issueEndTime ?? this.issueEndTime,
      description: description ?? this.description,
      responsable: responsable ?? this.responsable,
    );
  }
}
