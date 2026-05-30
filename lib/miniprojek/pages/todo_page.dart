import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../models/todo.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class TodoPage extends StatefulWidget {
  final List<Todo> todos;
  final Function(List<Todo>) onUpdate;

  const TodoPage({
    super.key,
    required this.todos,
    required this.onUpdate,
  });

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  String search = "";

  Future<void> save(List<Todo> list) async {
    await StorageService.saveList(
      "todos",
      list.map((e) => e.toJson()).toList(),
    );

    widget.onUpdate(list);
  }

  Future<void> addTodo() async {
    final controller = TextEditingController();

    DateTime? picked;
    RepeatType selectedRepeat = RepeatType.none;

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text("Tambah ToDo"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: "Judul",
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_month),
                  label: Text(
                    picked == null
                        ? "Pilih Deadline"
                        : DateFormat(
                            "dd MMM yyyy HH:mm",
                          ).format(picked!),
                  ),
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2035),
                    );

                    if (date == null) return;

                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (time == null) return;

                    setDialogState(() {
                      picked = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );
                    });
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<RepeatType>(
                  value: selectedRepeat,
                  decoration: const InputDecoration(
                    labelText: "Pengulangan",
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: RepeatType.none,
                      child: Text("Sekali"),
                    ),
                    DropdownMenuItem(
                      value: RepeatType.daily,
                      child: Text("Harian"),
                    ),
                    DropdownMenuItem(
                      value: RepeatType.weekly,
                      child: Text("Mingguan"),
                    ),
                  ],
                  onChanged: (v) {
                    selectedRepeat = v!;
                  },
                )
              ],
            ),
            actions: [
              TextButton(
                child: const Text("Batal"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: const Text("Simpan"),
                onPressed: () async {
                  if (controller.text.isEmpty || picked == null) {
                    return;
                  }

                  final todo = Todo(
                    controller.text,
                    picked!,
                    repeat: selectedRepeat,
                  );

                  final newList = List<Todo>.from(widget.todos)
                    ..add(todo);

                  await save(newList);

                  await NotificationService.scheduleTodo(
                    tz.TZDateTime.from(
                      picked!,
                      tz.local,
                    ),
                    controller.text,
                    repeat: selectedRepeat ==
                            RepeatType.daily
                        ? DateTimeComponents.time
                        : selectedRepeat ==
                                RepeatType.weekly
                            ? DateTimeComponents
                                .dayOfWeekAndTime
                            : null,
                  );

                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.todos
        .where(
          (t) => t.title
              .toLowerCase()
              .contains(search.toLowerCase()),
        )
        .toList();

    filtered.sort((a, b) {
      if (a.pinned && !b.pinned) return -1;
      if (!a.pinned && b.pinned) return 1;

      return a.deadline.compareTo(
        b.deadline,
      );
    });

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari tugas...",
                prefixIcon:
                    const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                ),
              ),
              onChanged: (v) {
                setState(() {
                  search = v;
                });
              },
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      "Belum ada ToDo",
                    ),
                  )
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final todo = filtered[i];

                      return Dismissible(
                        key: Key(
                          todo.title +
                              todo.deadline
                                  .toString(),
                        ),
                        background: Container(
                          color: Colors.red,
                          alignment:
                              Alignment.centerRight,
                          padding:
                              const EdgeInsets.only(
                            right: 20,
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (_) async {
                          widget.todos.remove(todo);

                          await save(
                            widget.todos,
                          );
                        },
                        child: Card(
                          margin:
                              const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: CheckboxListTile(
                            value: todo.done,
                            title: Text(
                              todo.title,
                              style: TextStyle(
                                decoration:
                                    todo.done
                                        ? TextDecoration
                                            .lineThrough
                                        : null,
                              ),
                            ),
                            subtitle: Text(
                              DateFormat(
                                "dd MMM yyyy HH:mm",
                              ).format(
                                todo.deadline,
                              ),
                            ),
                            secondary:
                                IconButton(
                              icon: Icon(
                                todo.pinned
                                    ? Icons.push_pin
                                    : Icons
                                        .push_pin_outlined,
                              ),
                              onPressed: () async {
                                setState(() {
                                  todo.pinned =
                                      !todo
                                          .pinned;
                                });

                                await save(
                                  widget.todos,
                                );
                              },
                            ),
                            onChanged: (v) async {
                              setState(() {
                                todo.done =
                                    v ?? false;
                              });

                              await save(
                                widget.todos,
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: addTodo,
        icon: const Icon(Icons.add),
        label: const Text("Tambah"),
      ),
    );
  }
}

