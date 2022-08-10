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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton.icon(
                          // The completion date widget
                          onPressed: () async {
                            DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: data.date,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );
                            if (newDate != null) {
                              data.date == newDate;
                            }
                          },
                          icon: const Icon(
                            Icons.calendar_today_outlined,
                            size: 22,
                          ),
                          label: const Text(
                            "Completion Date",
                            style: TextStyle(fontSize: 18),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(12),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(18),
                              ),
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () async {
                            TimeOfDay? newTime = await showTimePicker(
                              context: context,
                              initialTime: data.time,
                            );
                            if (newTime != null) {
                              data.time = newTime;
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(7),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(18),
                              ),
                            ),
                          ),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            size: 32,
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                      ],
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
