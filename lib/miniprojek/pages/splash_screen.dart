import 'dart:async';
import 'package:flutter/material.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDark;

  const SplashScreen({
    super.key,
    required this.toggleTheme,
    required this.isDark,
  });

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(
              toggleTheme:
                  widget.toggleTheme,
              isDark: widget.isDark,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const emerald = Color(0xFF10B981);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              padding:
                  const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: emerald,
                borderRadius:
                    BorderRadius.circular(
                        25),
              ),
              child: const Icon(
                Icons.access_time,
                color: Colors.white,
                size: 50,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "CHRONOS",
              style: TextStyle(
                fontSize: 32,
                fontWeight:
                    FontWeight.bold,
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Atur Waktumu, Raih Harimu",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 40),

            const CircularProgressIndicator(
              color: emerald,
            )
          ],
        ),
      ),
    );
  }
}