import 'dart:developer';
import 'package:donev2/bloc/todo_bloc.dart';
import 'package:donev2/constants.dart';
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
      newDate = DateTime.tryParse(id.completion.toString()) ?? currentDate;
      currentDate = newDate;

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
                id != null ? 'Save Changes' : 'Add Task',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: IconButton(
                      iconSize: kIconSize,
                      color: Colors.black54,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: kTertiaryColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 25,
                    ),
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
                        const SizedBox(
                          height: 10,
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
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          horizontalTitleGap: 0,
                          title: const Text(
                            'Due date',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          leading: const Icon(
                            Icons.calendar_today_outlined,
                            size: 26,
                          ),
                          trailing: Switch(
                            value: false,
                            onChanged: (bool value) {},
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          horizontalTitleGap: 0,
                          title: const Text(
                            'Set notification',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          leading: const Icon(
                            Icons.alarm,
                            size: 26,
                          ),
                          trailing: Switch(
                            value: false,
                            onChanged: (bool value) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
