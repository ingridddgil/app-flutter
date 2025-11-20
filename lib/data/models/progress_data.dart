class ProgressCardData {
  final int idProgress;
  final String client;
  final DateTime date;
  final String projectId;
  final String taskId;

  const ProgressCardData({
    required this.idProgress,
    required this.client,
    required this.date,
    required this.projectId,
    required this.taskId
  });
}