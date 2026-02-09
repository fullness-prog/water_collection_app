import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// ROLE: High-priority hardware alarms.
/// This handles the actual 'Reminders' by talking to the phone's OS.
class NotificationService {
  static final NotificationService instance = NotificationService._init();
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  NotificationService._init();

  /// ROLE: Initializes the notification engine and timezone data.
  Future<void> init() async {
    // Required to handle Daylight Savings and local time offsets correctly.
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _notifications.initialize(const InitializationSettings(android: android));
  }

  /// ROLE: Schedules an alarm for a specific reminder.
  /// One notification per reminder_time as per architecture rules.
  Future<void> scheduleAlarm(int reminderId, String title, DateTime scheduledTime) async {
    await _notifications.zonedSchedule(
      reminderId, // ID MUST map clearly to reminder ID
      'Water Collection Reminder',
      'Time to collect for: $title',
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'water_reminder_channel',
          'Water Reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// ROLE: Cancels a specific alarm if the user deletes a reminder.
  Future<void> cancelAlarm(int reminderId) async {
    await _notifications.cancel(reminderId);
  }
}