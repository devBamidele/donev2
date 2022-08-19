import 'dart:developer';
import 'package:donev2/bloc/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../model/todo.dart';
import 'extras/custom_back_button.dart';

extension TimeOfDayExtension on TimeOfDay {
  int compareTo(TimeOfDay other) {
    if (hour < other.hour) return -1;
    if (hour > other.hour) return 1;
    if (minute < other.minute) return -1;
    if (minute > other.minute) return 1;
    return 0;
  }
}

class AddScreen extends StatefulWidget {
  const AddScreen({this.id, Key? key}) : super(key: key);

  static const tag = '/add';
  final Todo? id;

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final id = widget.id;
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
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus
              ?.unfocus(), // To remove the focus of the text field
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 20, right: 5),
              child: FloatingActionButton.extended(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newTodo = Todo(
                      id: id?.id,
                      task: myTaskController.value.text,
                      category: myCategoryController.value.text.isEmpty
                          ? null
                          : myCategoryController.value.text,
                      completion: newDate?.toString(),
                      alarm: data.time?.toString(),
                    );
                    id != null
                        ? data.updateTodo(newTodo)
                        : data.addTodo(newTodo);
                    data.time = null; // Erase the value
                    log(myTaskController.value.text);
                    Navigator.pop(context);
                  }
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
                    const Padding(
                      padding: EdgeInsets.only(left: 12, top: 7),
                      child: CustomBackButton(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 25,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            id != null ? 'Edit Task' : 'Add Task',
                            style: const TextStyle(
                              fontSize: 33,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  maxLength: 30,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  controller: myTaskController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a task';
                                    } else if (value.length < 3) {
                                      return 'Too short';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Enter your task *',
                                    labelStyle: TextStyle(
                                      fontSize: 17,
                                      color: kTertiaryColor,
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  maxLength: 12,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  controller: myCategoryController,
                                  decoration: const InputDecoration(
                                    labelText: 'Enter category',
                                    labelStyle: TextStyle(
                                      fontSize: 17,
                                      color: kTertiaryColor,
                                    ),
                                  ),
                                ),
                              ],
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
