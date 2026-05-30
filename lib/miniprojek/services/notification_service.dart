import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings =
        InitializationSettings(android: android);

    await plugin.initialize(settings);
  }

  static Future<void> scheduleDailyReminder() async {
    final now = tz.TZDateTime.now(tz.local);

    final schedule = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      8,
    );

    await plugin.zonedSchedule(
      999,
      "Reminder Harian",
      "Cek ToDo kamu hari ini 🔥",
      schedule.isBefore(now)
          ? schedule.add(Duration(days: 1))
          : schedule,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel',
          'Daily Reminder',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode:
          AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents:
          DateTimeComponents.time,
    );
  }

  static Future<void> scheduleTodo(
    tz.TZDateTime time,
    String title, {
    bool priority = false,
    DateTimeComponents? repeat,
  }) async {
    await plugin.zonedSchedule(
      title.hashCode,
      priority ? "🔥 PRIORITAS!" : "Pengingat ToDo",
      title,
      time,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'todo_channel',
          'Todo Reminder',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode:
          AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: repeat,
    );
  }
}