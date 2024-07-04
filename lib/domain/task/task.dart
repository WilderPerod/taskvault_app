import 'dart:ui';

class Task {
  String? id;
  final String title;
  final Color color;
  final DateTime date;
  bool completed;

  Task(
      {this.id,
      required this.title,
      required this.color,
      required this.date,
      this.completed = false});

  // fromJson factory constructor
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        id: json['id'].toString(),
        title: json['title'],
        color: Color(json['color']),
        date: DateTime.parse(json['date']),
        completed: json['completed'] == 1 ? true : false);
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'color': color.value,
      'date': date.toIso8601String(),
      'completed': completed
    };
  }
}
