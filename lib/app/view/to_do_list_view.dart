import 'package:flutter/material.dart';

import '../controller/to_do_list_controller.dart';

class ToDoListView extends StatefulWidget {
  final TodoController controller;

  const ToDoListView({Key? key, required this.controller}) : super(key: key);

  @override
  State<ToDoListView> createState() => _ToDoListViewState();
}

class _ToDoListViewState extends State<ToDoListView> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
      ),
      body: ListView.builder(
        itemCount: widget.controller.toDoListModels.length,
        itemBuilder: (context, index) {
          final todo = widget.controller.toDoListModels[index];
          return ListTile(
            title: Text(todo.title.toUpperCase(),
                style: TextStyle(
                    decoration: !todo.done
                        ? TextDecoration.none
                        : TextDecoration.lineThrough)),
            trailing: Checkbox(
              value: todo.done,
              onChanged: (value) {
                setState(() {
                  widget.controller.toggleTodo(
                    id: todo.id,
                  );
                });
              },
            ),
            onLongPress: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Deseja remover esta tarefa?'),
                    actions: [
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: const Text('Remover'),
                        onPressed: () {
                          setState(() {
                            widget.controller.removeTodo(
                              id: todo.id,
                            );
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Adicionar Tarefa'),
                content: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _textController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Por favor, preencha o título da tarefa';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Digite o título da tarefa',
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: const Text('Adicionar'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          widget.controller.addTodo(
                            title: _textController.text,
                          );
                          _textController.clear();
                          Navigator.pop(context);
                        });
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
