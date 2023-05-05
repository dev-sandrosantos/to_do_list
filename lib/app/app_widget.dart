import 'package:flutter/material.dart';
import 'package:to_do_list/app/controller/to_do_list_controller.dart';

import 'view/to_do_list_view.dart';

class AppWidget extends StatelessWidget {
  AppWidget({super.key});

  final TodoController todoController = TodoController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 166, 3, 3))),
      home: ToDoListView(controller: todoController),
    );
  }
}
