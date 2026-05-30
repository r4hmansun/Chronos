import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String apiKey =
      "AIzaSyCmKo8UiAYDA53fdtPRmtRROkQcQCh6YVY";

  static Future<String> askAI(String prompt) async {
    final url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "text":
"""
Kamu adalah Chronos AI, asisten produktivitas yang ramah, modern, dan membantu.

Tugasmu:
- Memberi ide aktivitas produktif
- Memberi hal baru yang menarik untuk dicoba
- Membantu pengguna mengatasi bosan / malas
- Memberi contoh nyata
- Memberi langkah sederhana
- Jawaban singkat tapi berguna
- Gunakan bahasa santai dan friendly

Jika user bingung, berikan beberapa opsi.

Contoh topik:
- kebiasaan sehat
- rutinitas pagi
- skill baru
- challenge 7 hari
- belajar fokus
- ide side hustle
- olahraga ringan
- produktif saat gabut

User: $prompt
"""}
            ]
          }
        ]
      }),
    );

    final data = jsonDecode(response.body);

    if (data["candidates"] != null) {
      return data["candidates"][0]["content"]["parts"][0]["text"];
    } else {
      return "Terjadi error: ${data.toString()}";
    }
  }
}