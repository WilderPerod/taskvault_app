import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:taskvault_app/config/routes.dart';
import 'package:taskvault_app/config/theme.dart';
import 'package:taskvault_app/domain/task/task.dart';
import 'package:taskvault_app/ui/bloc/task_bloc.dart';
import 'package:taskvault_app/ui/widgets/dialogs.dart';
import 'package:taskvault_app/ui/widgets/loading_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TaskBloc taskBloc;

  @override
  void initState() {
    super.initState();

    taskBloc = BlocProvider.of<TaskBloc>(context);
    taskBloc.add(LoadTask());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_month,
              color: AppTheme.primaryColor,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text("Tareas", style: TextStyle(fontWeight: FontWeight.bold))
          ],
        ),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.addTask);
              },
              icon: const Icon(
                Icons.add,
                color: AppTheme.primaryColor,
              )),
          const SizedBox(
            width: 5.0,
          ),
        ],
        leading: const SizedBox(),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskError) {
            return const Center(
              child: Text(
                "Ups! ha ocurrido un problema al cargar los registros",
                style: TextStyle(color: AppTheme.iconColor),
              ),
            );
          }
          if (state is TaskLoaded && state.tasks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: AppTheme.iconColor,
                    size: 80.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "No existen tareas registradas",
                    style: TextStyle(color: AppTheme.iconColor),
                  ),
                ],
              ),
            );
          }

          if (state is! TaskLoaded) {
            return const LoadingIndicator();
          }

          return Stack(children: [
            state.tasks.length < 5
                ? const Positioned.fill(
                    child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.swipe_right,
                            size: 45.0,
                            color: AppTheme.iconColor,
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Text(
                            "Para eliminar desliza a la derecha",
                            style: TextStyle(color: AppTheme.iconColor),
                          )
                        ],
                      ),
                    ),
                  ))
                : const SizedBox(),
            ListView.separated(
              padding: const EdgeInsets.all(20.0),
              separatorBuilder: (context, index) => const SizedBox(
                height: 12.0,
              ),
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return Dismissible(
                  key: Key(task.id!),
                  direction: DismissDirection.startToEnd,
                  confirmDismiss: (direction) async {
                    final accept = await decisionDialog(
                        context: context,
                        title: "¿Desea eliminar esta tarea?",
                        subtitle: '');

                    if (accept == true) {
                      taskBloc.add(DeleteTask(taskId: task.id!));
                      return true;
                    }
                    return false;
                  },
                  background: Container(
                      padding: const EdgeInsets.only(left: 10.0),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ],
                      )),
                  child: TaskCard(
                    task: task,
                    onPressedCompleted: () {
                      taskBloc.add(UpdateTask(task: task));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: AppTheme.backgroundColor,
                          content: Text(
                            task.completed
                                ? 'Tarea incompleta'
                                : 'Tarea completada',
                            style: const TextStyle(color: Colors.black),
                          )));
                    },
                  ),
                );
              },
            ),
          ]);
        },
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard(
      {super.key, required this.task, required this.onPressedCompleted});

  final Task task;
  final void Function()? onPressedCompleted;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      leading: Container(
        height: 40.0,
        width: 40.0,
        decoration: BoxDecoration(
            color: task.color, borderRadius: BorderRadius.circular(20.0)),
        child: Center(
          child: Text(
            task.id!,
            style: const TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      trailing: IconButton(
          onPressed: onPressedCompleted,
          icon: task.completed
              ? const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                )
              : const Icon(
                  Icons.circle_outlined,
                  color: AppTheme.iconColor,
                )),
      title: Text(task.title),
      subtitle: Text(
        Jiffy.parse(task.date.toString()).yMMMMd,
      ),
      tileColor: AppTheme.backgroundColor,
    );
  }
}
