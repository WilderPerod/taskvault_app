part of 'task_bloc.dart';

@immutable
sealed class TaskState {}

final class TaskInitial extends TaskState {}

final class TaskLoading extends TaskState {}

final class TaskLoaded extends TaskState {
  final List<Task> tasks;

  TaskLoaded({required this.tasks});
}

final class TaskSuccess extends TaskState {}

final class TaskError extends TaskState {
  final String errorMessage;
  final List<Task> state;

  TaskError({required this.errorMessage, required this.state});
}
