import 'package:flutter/material.dart';
import 'main_page.dart';
import 'ai_page.dart';

class HomePage extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDark;

  const HomePage({
    super.key,
    required this.toggleTheme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    const emerald = Color(0xFF10B981);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "CHRONOS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
       
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            const Text(
              "Halo 👋",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "Kelola waktumu dengan cerdas hari ini.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 25),

            // AI Card
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const AIPage(),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(
                        20),
                decoration: BoxDecoration(
                  gradient:
                      const LinearGradient(
                    colors: [
                      Color(
                          0xFF10B981),
                      Color(
                          0xFF059669),
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(
                          24),
                ),
                child: const Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Icon(
                      Icons.smart_toy,
                      color:
                          Colors.white,
                      size: 35,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Najah AI",
                      style:
                          TextStyle(
                        color: Colors
                            .white,
                        fontSize: 22,
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Temukan ide produktif, rutinitas baru, dan saran cerdas.",
                      style:
                          TextStyle(
                        color: Colors
                            .white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              "Menu Cepat",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            Row(
  children: [
    Expanded(
      child: menuCard(
        icon: Icons.dashboard,
        title: "Masuk App",
        color: emerald,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MainPage(
                toggleTheme: toggleTheme,
                isDark: isDark,
                initialIndex: 0,
              ),
            ),
          );
        },
      ),
    ),

    const SizedBox(width: 12),

    Expanded(
      child: menuCard(
        icon: Icons.calendar_month,
        title: "Kalender",
        color: Colors.blue,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MainPage(
                toggleTheme: toggleTheme,
                isDark: isDark,
                initialIndex: 2,
              ),
            ),
          );
        },
      ),
    ),
  ],
),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(
                      18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(
                        20),
                boxShadow: const [
                  BoxShadow(
                    color:
                        Colors.black12,
                    blurRadius: 8,
                  )
                ],
              ),
              child: const Text(
                "💡 Sedikit progress setiap hari akan menjadi hasil besar.",
                style: TextStyle(
                    fontSize: 15),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget menuCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(
                  20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
            )
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor:
                  color.withOpacity(
                      0.12),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            const SizedBox(height: 10),
            Text(title),
          ],
        ),
      ),
    );
  }
}