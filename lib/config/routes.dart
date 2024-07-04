import 'package:flutter/material.dart';
import 'package:taskvault_app/ui/add_task_page.dart';
import 'package:taskvault_app/ui/home_page.dart';

class AppRoutes {
  static const String home = '/home';
  static const String addTask = '/addTask';

  static final routes = <RouteOption>[
    RouteOption(route: home, screen: HomePage()),
    RouteOption(route: addTask, screen: const AddTaskPage())
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};
    for (final element in routes) {
      appRoutes.addAll(
          {element.route: (BuildContext buildContext) => element.screen});
    }

    return appRoutes;
  }
}

class RouteOption {
  final String route;
  final Widget screen;

  RouteOption({required this.route, required this.screen});
}
