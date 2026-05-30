enum RepeatType { none, daily, weekly }

class Todo {
  String title;
  DateTime deadline;
  bool done;
  bool pinned;
  RepeatType repeat;

  Todo(
    this.title,
    this.deadline, {
    this.done = false,
    this.pinned = false,
    this.repeat = RepeatType.none,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "deadline": deadline.toIso8601String(),
        "done": done,
        "pinned": pinned,
        "repeat": repeat.index,
      };

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        json["title"],
        DateTime.parse(json["deadline"]),
        done: json["done"],
        pinned: json["pinned"] ?? false,
        repeat: RepeatType.values[json["repeat"] ?? 0],
      );
}