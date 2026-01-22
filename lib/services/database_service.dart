class DatabaseService {
  // This will handle opening the database box
  Future<void> init() async {
    // TODO: Fullness - Initialize Hive here
    print("Database Initialized");
  }

  // Example: Save a schedule
  Future<void> addSchedule(String time, String note) async {
    // TODO: Fullness - Write code to save data
  }

  // Example: Get all schedules
  List<dynamic> getSchedules() {
    // TODO: Fullness - Return actual data
    return [];
  }
}