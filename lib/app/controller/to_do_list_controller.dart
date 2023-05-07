import 'package:flutter/widgets.dart';

import '../model/to_do_list_model.dart';

class TodoController extends ChangeNotifier {
  List<ToDoListModel> toDoListModels = [];

  void addTodo({String? title, String? priority}) {
    toDoListModels.add(
      ToDoListModel(
          id: toDoListModels.length + 1,
          title: title!,
          done: false,
          priority: priority!),
    );
    notifyListeners();
  }

  void removeTodo({int? id}) {
    toDoListModels.removeWhere((todo) => todo.id == id);
    notifyListeners();
  }

  void toggleTodo({int? id}) {
    for (var todo in toDoListModels) {
      if (todo.id == id) {
        todo.done = !todo.done;
        notifyListeners();
        break;
      }
    }
  }

  void editTodo({int? id, String? newTitle}) {
    for (var todo in toDoListModels) {
      if (todo.id == id) {
        todo.title = newTitle!;
        notifyListeners();
        break;
      }
    }
  }
}
