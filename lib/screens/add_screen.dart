import 'dart:developer';
import 'package:donev2/bloc/todo_bloc.dart';
import 'package:donev2/notification/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../model/todo.dart';
import 'extras/custom_back_button.dart';
import 'package:flutter_switch/flutter_switch.dart';

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

  static const tag = '/add';
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
        newTime = TimeOfDay.fromDateTime(DateTime.parse(id.alarm!));
        currentTime = newTime;
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
                  if (data.formKey.currentState!.validate()) {
                    final newTodo = Todo(
                      id: id?.id,
                      task: myTaskController.value.text,
                      category: myCategoryController.value.text.isEmpty
                          ? null
                          : myCategoryController.value.text,
                      completion: newDate?.toString(),
                      alarm: data.time?.toString(),
                    );

                    if (id != null) {
                      data.updateTodo(newTodo);
                      if (newTodo.alarm != null) {
                        NotificationService().scheduleNotifications(
                          time: DateTime.parse(newTodo.alarm!),
                          id: newTodo.id!,
                          notify: newTodo.task!,
                          heading: newTodo.category,
                        );
                      }
                    } else {
                      data.addTodo(newTodo);
                      if (newTodo.alarm != null) {
                        NotificationService().scheduleNotifications(
                          time: DateTime.parse(newTodo.alarm!),
                          id: data.nextNumber! + 1,
                          notify: newTodo.task!,
                          heading: newTodo.category,
                        );
                      }
                    }

                    // Erase the values
                    data.time = null;
                    data.currentTask = null;
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
                            key: data.formKey,
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
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.calendar_today_outlined),
                                    SizedBox(width: 15),
                                    Text(
                                      "Completion Date",
                                      style: TextStyle(fontSize: 17.5),
                                    ),
                                  ],
                                ),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(85, 37),
                                    backgroundColor: kScaffoldColor,
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  onPressed: () async {
                                    newDate = await showDatePicker(
                                      context: context,
                                      initialDate: currentDate,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2150),
                                      builder: (_, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: const ColorScheme.dark(
                                              primary: kTertiaryColor,
                                              surface: Color(0xff2d2e4e),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (newDate != null) {
                                      currentDate = newDate!;
                                    }
                                    // Update all instances of newDate
                                    data.update(value: newDate);
                                  },
                                  child: Text(
                                    newDate != null
                                        ? DateFormat('MMM dd, y')
                                            .format(newDate!)
                                        : '-- / -- / ---',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Divider(
                            indent: 10,
                            endIndent: 10,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.alarm),
                                    SizedBox(width: 15),
                                    Text(
                                      "Notification",
                                      style: TextStyle(fontSize: 17.5),
                                    ),
                                  ],
                                ),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(85, 37),
                                    backgroundColor: kScaffoldColor,
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  onPressed: () async {
                                    newTime = await showTimePicker(
                                      context: context,
                                      initialTime: currentTime,
                                    );
                                    if (newTime != null) {
                                      if (TimeOfDay.now().compareTo(newTime!) ==
                                          -1) {
                                        DateTime alarm = toDateTime(
                                            date: currentDate, time: newTime!);

                                        // Update all instances of newDate
                                        currentTime = newTime!;
                                        data.update(value2: newTime);
                                        data.time = alarm;
                                      }
                                    }
                                  },
                                  child: Text(
                                    newTime != null
                                        ? '${newTime!.hour} : ${newTime!.minute} ${newTime!.period.name}'
                                        : '-- : --',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          FlutterSwitch(
                            value: true,
                            onToggle: (value) {},
                          )
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
