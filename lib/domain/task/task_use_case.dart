import 'package:taskvault_app/domain/task/task.dart';
import 'package:taskvault_app/domain/task/task_repository.dart';

class TaskUseCase {
  final TaskRepository taskRepository;

  TaskUseCase(this.taskRepository);

  Future<List<Task>> viewAllTask() async {
    return await taskRepository.getAllTask();
  }

  Future<Task> makeTask({required Task task}) async {
    return await taskRepository.addTask(task: task);
  }

  Future<void> dismissTask({required String id}) async {
    return await taskRepository.deleteTask(id: id);
  }

  Future<void> completedTask({required Task task}) async {
    return await taskRepository.updateCompletedTask(task: task);
  }
}
