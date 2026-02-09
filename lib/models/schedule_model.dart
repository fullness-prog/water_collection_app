/// ROLE: Represents the parent 'Schedule' entry for water collection.
class Schedule {
  final int? id;
  final String title;
  final String collectionDate; // Format: YYYY-MM-DD
  final int isActive; // 1 for active, 0 for inactive
  final String? notes;

  Schedule({
    this.id,
    required this.title,
    required this.collectionDate,
    this.isActive = 1,
    this.notes,
  });

  // Converts a Schedule object into a Map for SQLite insertion.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'collection_date': collectionDate,
      'is_active': isActive,
      'notes': notes,
    };
  }

  // Creates a Schedule object from a database Map.
  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      id: map['id'],
      title: map['title'],
      collectionDate: map['collection_date'],
      isActive: map['is_active'] ?? 1,
      notes: map['notes'],
    );
  }
}
  