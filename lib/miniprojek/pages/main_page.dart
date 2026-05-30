import 'package:flutter/material.dart';

import '../models/todo.dart';
import '../services/storage_service.dart';

import 'note_page.dart';
import 'todo_page.dart';
import 'calendar_page.dart';

class MainPage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDark;
  final int initialIndex;

  const MainPage({
    super.key,
    required this.toggleTheme,
    required this.isDark,
    this.initialIndex = 0,
  });

  @override
  State<MainPage> createState() =>
      _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int index;
  List<Todo> todos = [];

  @override
  void initState() {
    super.initState();
    index = widget.initialIndex;
    loadTodos();
  }

  Future<void> loadTodos() async {
    final data =
        await StorageService.loadList("todos");

    setState(() {
      todos =
          data.map((e) => Todo.fromJson(e)).toList();
    });
  }

  void updateTodos(List<Todo> list) {
    setState(() => todos = list);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const NotePage(),
      TodoPage(
        todos: todos,
        onUpdate: updateTodos,
      ),
      CalendarPage(todos),
    ];

    final titles = [
      "Notes",
      "ToDo",
      "Calendar",
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[index],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: widget.toggleTheme,
            icon: Icon(
              widget.isDark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
          )
        ],
      ),
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) {
          setState(() => index = i);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.note),
            label: "Notes",
          ),
          NavigationDestination(
            icon: Icon(Icons.check),
            label: "ToDo",
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month),
            label: "Calendar",
          ),
        ],
      ),
    );
  }
}