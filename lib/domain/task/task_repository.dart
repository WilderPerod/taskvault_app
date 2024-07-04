import 'package:taskvault_app/domain/task/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getAllTask();
  Future<Task> addTask({required Task task});
  Future<void> deleteTask({required String id});
  Future<void> updateCompletedTask({required Task task});
}
