import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:taskvault_app/config/theme.dart';
import 'package:taskvault_app/ui/bloc/task_bloc.dart';
import 'package:taskvault_app/ui/widgets/dialogs.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();

  List<Color> colorOptions = const [
    Color(0xFFF263DA),
    Color(0xFFE4B231),
    Color(0xFF1B6ECF),
  ];

  final titleController = TextEditingController();
  final dateController = TextEditingController();
  DateTime? day;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    final taskBloc = BlocProvider.of<TaskBloc>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: AppTheme.primaryColor)),
        title: const Text("Registrar tarea",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: BlocListener<TaskBloc, TaskState>(
              listener: (context, state) {
                if (state is TaskError) {
                  infoDialog(
                      context: context,
                      title: 'Ups!',
                      information: state.errorMessage);
                  return;
                }

                if (state is TaskSuccess) {
                  Navigator.pop(context);
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30.0,
                  ),
                  SizedBox(
                    width: screenSize.width * 0.8,
                    child: TextFormField(
                      controller: titleController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]+')),
                      ],
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                          hintText: 'Título',
                          prefixIcon: SizedBox(),
                          suffixIcon: SizedBox()),
                      textAlign: TextAlign.center,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El título es requerido';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDatePicker(
                          context: context,
                          locale: const Locale('es', 'ES'),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now());
                    },
                    child: SizedBox(
                      width: screenSize.width * 0.8,
                      child: TextFormField(
                        controller: dateController,
                        readOnly: true,
                        onTap: () async {
                          final date = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(9999));

                          if (date != null) {
                            dateController.text =
                                Jiffy.parse(date.toIso8601String()).yMMMMd;
                            day = date;
                          }
                        },
                        decoration: const InputDecoration(
                            hintText: 'Fecha',
                            prefixIcon: Icon(
                              Icons.calendar_month,
                            ),
                            suffixIcon: SizedBox()),
                        textAlign: TextAlign.center,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'La fecha es requerida';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  SizedBox(
                    height: screenSize.width * 0.1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              taskBloc.add(AddTask(
                  title: titleController.text,
                  color: colorOptions[Random().nextInt(2)],
                  date: day!));
            }
          },
          child: SizedBox(
              width: screenSize.width * 0.25,
              child: const Row(
                children: [
                  Icon(Icons.save),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    "Guardar",
                    textAlign: TextAlign.center,
                  ),
                ],
              ))),
    );
  }
}
