/// ROLE: Child Model - Represents an individual alarm time.
/// Each reminder is linked to a Parent Schedule via 'scheduleId'.
class Reminder {
  final int? id;
  final int scheduleId; // Foreign Key
  final String reminderTime; // Format: HH:mm

  Reminder({
    this.id,
    required this.scheduleId,
    required this.reminderTime,
  });

  // Converts object to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'schedule_id': scheduleId,
      'reminder_time': reminderTime,
    };
  }

  // Creates object from SQLite Map
  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      scheduleId: map['schedule_id'],
      reminderTime: map['reminder_time'],
    );
  }
}