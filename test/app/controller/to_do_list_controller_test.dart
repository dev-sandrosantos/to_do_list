import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_list/app/controller/to_do_list_controller.dart';

void main() {
  group('TodoController', () {
    late TodoController controller;

    setUp(() {
      controller = TodoController();
    });

    test('should add a todo', () {
      controller.addTodo(
        title: 'Nova tarefa',
      );
      expect(controller.toDoListModels.length, 1);
      expect(controller.toDoListModels[0].title, 'Nova tarefa');
      expect(controller.toDoListModels[0].done, false);
    });

    test('should remove a todo', () {
      controller.addTodo(
        title: 'Tarefa a ser removida',
      );
      expect(controller.toDoListModels.length, 1);
      final id = controller.toDoListModels[0].id;
      controller.removeTodo(
        id: id,
      );
      expect(controller.toDoListModels.length, 0);
    });

    test('should toggle a todo', () {
      controller.addTodo(
        title: 'Tarefa a ser concluída',
      );
      expect(controller.toDoListModels[0].done, false);
      final id = controller.toDoListModels[0].id;
      controller.toggleTodo(
        id: id,
      );
      expect(controller.toDoListModels[0].done, true);
      controller.toggleTodo(
        id: id,
      );
      expect(controller.toDoListModels[0].done, false);
    });
  });
}
