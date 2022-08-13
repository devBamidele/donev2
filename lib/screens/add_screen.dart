import 'dart:developer';
import 'package:donev2/bloc/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/todo.dart';

extension TimeOfDayExtension on TimeOfDay {
  int compareTo(TimeOfDay other) {
    if (hour < other.hour) return -1;
    if (hour > other.hour) return 1;
    if (minute < other.minute) return -1;
    if (minute > other.minute) return 1;
    return 0;
  }
}

class AddScreen extends StatelessWidget {
  const AddScreen({this.id, Key? key}) : super(key: key);

  final Todo? id;
  @override
  Widget build(BuildContext context) {
    final id = this.id;
    final myTaskController = TextEditingController();
    final myCategoryController = TextEditingController();
    DateTime currentDate = DateTime.now();
    DateTime? newDate;
    TimeOfDay currentTime = TimeOfDay.now();
    TimeOfDay? newTime;

    if (id != null) {
      // When the page is opened by clicking on a task tile
      myTaskController.text = id.task!;
      myCategoryController.text = id.category ?? '';
      currentDate = DateTime.tryParse(id.completion.toString()) ?? currentDate;

      if (id.alarm != null) {
        currentTime = TimeOfDay.fromDateTime(DateTime.parse(id.alarm!));
      }
    }

    return Consumer<TodoBloc>(
      builder: (BuildContext context, data, Widget? child) {
        return Scaffold(
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 5),
            child: FloatingActionButton.extended(
              onPressed: () {
                final newTodo = Todo(
                  id: id?.id,
                  task: myTaskController.value.text,
                  category: myCategoryController.value.text.isEmpty
                      ? null
                      : myCategoryController.value.text,
                  completion: newDate?.toString(),
                  alarm: data.time?.toString(),
                );
                if (newTodo.task!.isNotEmpty) {
                  id != null ? data.updateTodo(newTodo) : data.addTodo(newTodo);
                  data.time = null; // Erase the value
                }
                log(myTaskController.value.text);
                Navigator.pop(context);
              },
              label: Text(
                id != null ? 'Save changes' : 'Add task',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.cancel_outlined,
                            color: Colors.black38.withOpacity(0.3),
                            size: 44,
                          ),
                        ),
                      ],
                    ),
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
                            newDate = await showDatePicker(
                              context: context,
                              initialDate: currentDate,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );
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
                            newTime = await showTimePicker(
                              context: context,
                              initialTime: currentTime,
                            );
                            if (newTime != null) {
                              if (TimeOfDay.now().compareTo(newTime!) == -1) {
                                DateTime alarm = toDateTime(
                                    date: currentDate, time: newTime!);
                                data.time = alarm;
                              }
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

  toDateTime({
    required TimeOfDay time,
    required DateTime date,
  }) =>
      DateTime(date.year, date.month, date.day, time.hour, time.minute);
}
