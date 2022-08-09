import 'dart:developer';

import 'package:donev2/bloc/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/todo.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myTaskController = TextEditingController();
    final myCategoryController = TextEditingController();

    return Consumer<TodoBloc>(
      builder: (BuildContext context, data, Widget? child) {
        return Scaffold(
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 5),
            child: FloatingActionButton.extended(
              onPressed: () {
                final newTodo = Todo(
                  task: myTaskController.value.text,
                  category: myCategoryController.value.text,
                );
                if (newTodo.task!.isNotEmpty) {
                  data.addTodo(newTodo);
                }
                log(myTaskController.value.text);
                Navigator.pop(context);
              },
              label: const Text(
                'Add Task',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Center(
                child: Column(
                  children: [
                    TextFormField(
                      controller: myTaskController,
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your task',
                      ),
                    ),
                    TextFormField(
                      controller: myCategoryController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter a category',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
