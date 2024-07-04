part of 'task_bloc.dart';

@immutable
sealed class TaskEvent {}

class LoadTask extends TaskEvent {}

class AddTask extends TaskEvent {
  final String title;
  final Color color;
  final DateTime date;

  AddTask({required this.title, required this.color, required this.date});
}

class DeleteTask extends TaskEvent {
  final String taskId;

  DeleteTask({required this.taskId});
}

class UpdateTask extends TaskEvent {
  final Task task;

  UpdateTask({required this.task});
}
