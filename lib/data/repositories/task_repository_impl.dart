import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:taskvault_app/domain/task/task.dart';
import 'package:taskvault_app/domain/task/task_repository.dart';

class TaskRepositoryImpl extends TaskRepository {
  final String database;
  TaskRepositoryImpl({required this.database});

  final String nameTable = 'Task';
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, database),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE Task(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, date DATETIME NOT NULL, color INTEGER NOT NULL, completed BOOL NOT NULL )",
        );
      },
      version: 1,
    );
  }

  @override
  Future<Task> addTask({required Task task}) async {
    try {
      final Database db = await initializeDB();

      task.id = (await db.insert(nameTable, task.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace))
          .toString();

      return task;
    } catch (e) {
      debugPrint("Something went wrong when addTask: $e");
      throw Exception("No se ha podido registrar la tarea");
    }
  }

  @override
  Future<void> deleteTask({required String id}) async {
    try {
      final Database db = await initializeDB();

      await db.delete(nameTable, where: "id = ?", whereArgs: [id]);
    } catch (e) {
      debugPrint("Something went wrong when deleteTask: $e");
      throw Exception("No se ha podido eliminar la tarea");
    }
  }

  @override
  Future<List<Task>> getAllTask() async {
    try {
      final Database db = await initializeDB();

      final List<Map<String, Object?>> queryResult = await db.query(
        nameTable,
        orderBy: "date ASC",
      );

      return queryResult.map((task) => Task.fromJson(task)).toList();
    } catch (e) {
      debugPrint("Something went wrong when getAllTask: $e");
      throw Exception("No se han podido cargar las tareas");
    }
  }

  @override
  Future<void> updateCompletedTask({required Task task}) async {
    try {
      final Database db = await initializeDB();

      await db.update(nameTable, task.toJson(),
          where: 'id = ?', whereArgs: [task.id]);
    } catch (e) {
      debugPrint("Something went wrong when updateCompletedTask: $e");
      throw Exception("No se ha podido actualizar la tarea");
    }
  }
}
