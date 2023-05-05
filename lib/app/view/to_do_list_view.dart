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
      body: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 4),
        itemCount: widget.controller.toDoListModels.length,
        itemBuilder: (BuildContext context, int index) {
          final todoNotDone = widget.controller.toDoListModels
              .where((element) => !element.done)
              .toList();
          final todoDone = widget.controller.toDoListModels
              .where((element) => element.done)
              .toList();
          final allTodos = [...todoNotDone, ...todoDone];
          final todo = allTodos[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(stops: [
                0.01,
                0.04
              ], colors: [
                Colors.green,
                Colors.white,
              ])),
              child: ListTile(
                title: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(todo.title.toUpperCase(),
                      style: TextStyle(
                          decoration: !todo.done
                              ? TextDecoration.none
                              : TextDecoration.lineThrough)),
                ),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      Checkbox(
                          value: todo.done,
                          onChanged: (value) {
                            setState(() =>
                                widget.controller.toggleTodo(id: todo.id));
                          }),
                      IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Editar Tarefa'),
                                  content: Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      maxLength: 35,
                                      maxLines: 1,
                                      controller: _textController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Por favor, preencha o novo título da tarefa';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        hintText:
                                            'Digite o novo título da tarefa',
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
                                      child: const Text('Alterar'),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            widget.controller.editTodo(
                                              id: todo.id,
                                              newTitle: _textController.text,
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
                          icon: Icon(
                            Icons.edit,
                            color: Theme.of(context).colorScheme.secondary,
                          ))
                    ],
                  ),
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
              ),
            ),
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
                    maxLength: 35,
                    maxLines: 1,
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
