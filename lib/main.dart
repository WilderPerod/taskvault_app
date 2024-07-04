import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jiffy/jiffy.dart';
import 'package:taskvault_app/config/routes.dart';
import 'package:taskvault_app/config/theme.dart';
import 'package:taskvault_app/data/repositories/task_repository_impl.dart';
import 'package:taskvault_app/ui/bloc/task_bloc.dart';

void main() async {
  await Jiffy.setLocale('es');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(
          taskRepositoryImpl: TaskRepositoryImpl(database: "database.db")),
      child: MaterialApp(
        title: 'TaskVault',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('es'),
        ],
        initialRoute: AppRoutes.home,
        routes: AppRoutes.getAppRoutes(),
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
