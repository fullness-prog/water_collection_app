// TODO: Fullness - specific this class with @HiveType annotations later
class ScheduleModel {
  final String id;
  final DateTime time;
  final String note;
  final bool isCompleted;

  ScheduleModel({
    required this.id,
    required this.time,
    required this.note,
    this.isCompleted = false,
  });
}