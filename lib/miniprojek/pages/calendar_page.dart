import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/todo.dart';
import 'ai_page.dart';

class CalendarPage extends StatefulWidget {
  final List<Todo> todos;

  const CalendarPage(this.todos, {super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  List<Todo> getEventsForDay(DateTime day) {
    return widget.todos.where((todo) {
      return todo.deadline.year == day.year &&
          todo.deadline.month == day.month &&
          todo.deadline.day == day.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final selectedTodos =
        getEventsForDay(selectedDay);

    return Scaffold(
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TableCalendar(
                firstDay: DateTime(2020),
                lastDay: DateTime(2035),
                focusedDay: focusedDay,
                selectedDayPredicate: (day) =>
                    isSameDay(
                        selectedDay, day),

                eventLoader: getEventsForDay,

                headerStyle:
                    const HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                ),

                calendarStyle:
                    CalendarStyle(
                  markerDecoration:
                      BoxDecoration(
                    color: theme
                        .colorScheme
                        .primary,
                    shape:
                        BoxShape.circle,
                  ),
                  todayDecoration:
                      BoxDecoration(
                    color: theme
                        .colorScheme
                        .primary
                        .withOpacity(.5),
                    shape:
                        BoxShape.circle,
                  ),
                  selectedDecoration:
                      BoxDecoration(
                    color: theme
                        .colorScheme
                        .primary,
                    shape:
                        BoxShape.circle,
                  ),
                ),

                onDaySelected:
                    (selected, focused) {
                  setState(() {
                    selectedDay =
                        selected;
                    focusedDay =
                        focused;
                  });
                },
              ),
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              children: [
                Text(
                  "Agenda Hari Ini",
                  style: theme
                      .textTheme
                      .titleLarge,
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: selectedTodos.isEmpty
                ? ListView(
                    children: [
                      const SizedBox(
                          height: 40),
                      Icon(
                        Icons
                            .calendar_month,
                        size: 80,
                        color: theme
                            .colorScheme
                            .primary,
                      ),
                      const SizedBox(
                          height: 12),
                      Center(
                        child: Text(
                          "Ayo isi waktu kosongmu! 🔥",
                          style: theme
                              .textTheme
                              .titleMedium,
                        ),
                      ),
                      const SizedBox(
                          height: 8),
                      Center(
                        child: Text(
                          "Minta ide produktif ke AI",
                          style: theme
                              .textTheme
                              .bodyMedium,
                        ),
                      ),
                      const SizedBox(
                          height: 20),
                      Padding(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 40,
                        ),
                        child:
                            ElevatedButton.icon(
                          icon: const Icon(
                              Icons
                                  .auto_awesome),
                          label: const Text(
                              "Buka Najah AI"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const AIPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    itemCount:
                        selectedTodos.length,
                    itemBuilder:
                        (_, index) {
                      final todo =
                          selectedTodos[
                              index];

                      return Card(
                        margin:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                                      18),
                        ),
                        child: ListTile(
                          leading:
                              CircleAvatar(
                            child: Icon(
                              todo.done
                                  ? Icons
                                      .check
                                  : Icons
                                      .schedule,
                            ),
                          ),

                          title: Text(
                            todo.title,
                            style:
                                TextStyle(
                              decoration:
                                  todo.done
                                      ? TextDecoration
                                          .lineThrough
                                      : null,
                            ),
                          ),

                          subtitle: Text(
                            "${todo.deadline.hour.toString().padLeft(2, '0')}:${todo.deadline.minute.toString().padLeft(2, '0')}",
                          ),

                          trailing:
                              todo.pinned
                                  ? const Icon(
                                      Icons
                                          .push_pin,
                                      color: Colors
                                          .orange,
                                    )
                                  : null,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}