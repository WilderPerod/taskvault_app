import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskvault_app/data/repositories/task_repository_impl.dart';
import 'package:taskvault_app/domain/task/task.dart';
import 'package:taskvault_app/domain/task/task_use_case.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepositoryImpl taskRepositoryImpl;

  late TaskUseCase taskUseCase;

  TaskBloc({required this.taskRepositoryImpl}) : super(TaskInitial()) {
    taskUseCase = TaskUseCase(taskRepositoryImpl);

    on<LoadTask>((event, emit) async {
      try {
        emit(TaskLoading());

        List<Task> tasks = await taskUseCase.viewAllTask();

        emit(TaskLoaded(tasks: tasks));
      } catch (e) {
        emit(TaskError(
            errorMessage: e.toString().replaceAll('Exception:', ''),
            state: const []));
      }
    });

    on<AddTask>((event, emit) async {
      final currentTasks = state is TaskLoaded
          ? (state as TaskLoaded).tasks
          : (state as TaskError).state;
      try {
        emit(TaskLoading());

        final task = await taskUseCase.makeTask(
            task:
                Task(title: event.title, date: event.date, color: event.color));

        currentTasks.add(task);

        emit(TaskSuccess());
      } catch (e) {
        emit(TaskError(
            errorMessage: e.toString().replaceAll('Exception:', ''),
            state: currentTasks));
      }
      add(LoadTask());
    });

    on<DeleteTask>((event, emit) async {
      final currentTasks = (state as TaskLoaded).tasks;
      try {
        emit(TaskLoading());

        await taskUseCase.dismissTask(id: event.taskId);

        emit(TaskLoaded(
            tasks: currentTasks
              ..removeWhere((task) => task.id == event.taskId)));
      } catch (e) {
        emit(TaskError(
            errorMessage: e.toString().replaceAll('Exception:', ''),
            state: currentTasks));
      }
    });

    on<UpdateTask>((event, emit) async {
      final currentTasks = (state as TaskLoaded).tasks;
      try {
        // emit(TaskLoading());

        Task task = event.task;
        task.completed = !task.completed;

        await taskUseCase.completedTask(task: task);

        emit(TaskLoaded(
            tasks: currentTasks.map((task) {
          if (task.id == event.task.id) {
            task.completed = event.task.completed;
          }

          return task;
        }).toList()));
      } catch (e) {
        emit(TaskError(
            errorMessage: e.toString().replaceAll('Exception:', ''),
            state: currentTasks));
      }
    });
  }
}
