import 'package:flutter/material.dart';
import '../services/ai_service.dart';

class AIPage extends StatefulWidget {
  const AIPage({super.key});

  @override
  State<AIPage> createState() => _AIPageState();
}

class _AIPageState extends State<AIPage> {
  final controller = TextEditingController();
  final scrollController = ScrollController();

  List<Map<String, String>> messages = [];
  bool loading = false;

  Future<void> send() async {
    if (controller.text.trim().isEmpty) return;

    final text = controller.text.trim();

    setState(() {
      messages.add({
        "role": "user",
        "text": text,
      });
      loading = true;
    });

    controller.clear();
    scrollDown();

    final reply = await AIService.askAI(text);

    setState(() {
      messages.add({
        "role": "ai",
        "text": reply,
      });
      loading = false;
    });

    scrollDown();
  }

  void scrollDown() {
    Future.delayed(const Duration(milliseconds: 300), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Widget bubble(String text, bool isUser) {
    const emerald = Color(0xFF10B981);

    return Align(
      alignment:
          isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: isUser ? emerald : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget suggestionChip(String text) {
    return GestureDetector(
      onTap: () {
        controller.text = text;
        send();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const emerald = Color(0xFF10B981);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Najah AI",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            margin: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: emerald,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "🚀 Siap jadi lebih produktif?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Tanya ide baru, rutinitas sehat, cara fokus, dan aktivitas bermanfaat.",
                  style: TextStyle(color: Colors.white70),
                )
              ],
            ),
          ),

          // Suggestion
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              children: [
                suggestionChip("Aku gabut ngapain ya?"),
                suggestionChip("Kasih rutinitas pagi"),
                suggestionChip("Hal baru yang bisa dicoba"),
                suggestionChip("Cara fokus belajar"),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Chat Area
          Expanded(
            child: messages.isEmpty
                ? const Center(
                    child: Text(
                      "Mulai ngobrol dengan AI ✨",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(14),
                    itemCount: messages.length,
                    itemBuilder: (_, i) {
                      final msg = messages[i];
                      return bubble(
                        msg["text"]!,
                        msg["role"] == "user",
                      );
                    },
                  ),
          ),

          if (loading)
            const Padding(
              padding: EdgeInsets.all(10),
              child: CircularProgressIndicator(),
            ),

          // Input
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Tanya sesuatu...",
                      filled: true,
                      fillColor: const Color(0xFFF1F3F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: emerald,
                  child: IconButton(
                    onPressed: send,
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}