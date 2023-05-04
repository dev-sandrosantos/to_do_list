import '../model/to_do_list_model.dart';

class TodoController {
  List<ToDoListModel> toDoListModels = [];

  void addTodo({String? title}) {
    toDoListModels.add(
      ToDoListModel(id: toDoListModels.length + 1, title: title!, done: false),
    );
  }

  void removeTodo({int? id}) {
    toDoListModels.removeWhere((todo) => todo.id == id);
  }

  void toggleTodo({int? id}) {
    for (var todo in toDoListModels) {
      if (todo.id == id) {
        todo.done = !todo.done;
      }
    }
  }
}
