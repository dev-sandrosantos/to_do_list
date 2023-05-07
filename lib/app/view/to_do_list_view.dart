import 'package:flutter/material.dart';

import '../controller/to_do_list_controller.dart';

class ToDoListView extends StatefulWidget {
  final TodoController controller;

  const ToDoListView({Key? key, required this.controller}) : super(key: key);

  @override
  State<ToDoListView> createState() => _ToDoListViewState();
}

List<String> listDropdown = <String>['BAIXA', 'ALTA'];

class _ToDoListViewState extends State<ToDoListView> {
  @override
  initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String dropdownValue = listDropdown.first;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _textController;
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
              decoration: BoxDecoration(
                  gradient: LinearGradient(stops: const [
                0.0006,
                0.032
              ], colors: [
                todo.priority == 'BAIXA' ? Colors.green : Colors.red,
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
                            setState(() {
                              _textController =
                                  TextEditingController(text: todo.title);
                              dropdownValue = todo.priority;
                            });
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
                                    StatefulBuilder(
                                        builder: (context, setState) {
                                      return DropdownButton<String>(
                                        value: dropdownValue.toUpperCase(),
                                        onChanged: (String? value) {
                                          setState(() {
                                            dropdownValue = value!;
                                          });
                                        },
                                        items: listDropdown
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      );
                                    }),
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
                                                newPriority: dropdownValue);
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
                  StatefulBuilder(builder: (context, setState) {
                    return DropdownButton<String>(
                      value: dropdownValue.toUpperCase(),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                      items: listDropdown
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    );
                  }),
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
                            priority: dropdownValue,
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
