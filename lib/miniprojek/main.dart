import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'pages/splash_screen.dart';
import 'pages/home_page.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

  await NotificationService.init();
  await NotificationService.scheduleDailyReminder();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData(
  useMaterial3: true,
  colorSchemeSeed: const Color(0xFF10B981),
  brightness: Brightness.light,
),

darkTheme: ThemeData(
  useMaterial3: true,
  colorSchemeSeed: const Color(0xFF10B981),
  brightness: Brightness.dark,
),

      home: SplashScreen(
  toggleTheme: () {
    setState(() => isDark = !isDark);
  },
  isDark: isDark,
),
    );
  }
}