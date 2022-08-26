import 'dart:developer';

import 'package:donev2/notification/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../bloc/todo_bloc.dart';
import '../constants.dart';
import '../model/todo.dart';
import 'extras/custom_back_button.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({
    required this.id,
    Key? key,
  }) : super(key: key);

  static const tag = '/edit';
  final Todo id;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final myTaskController = TextEditingController();
  final myCategoryController = TextEditingController();
  late bool status = widget.id.ring;

  @override
  Widget build(BuildContext context) {
    myTaskController.text = widget.id.task;
    myCategoryController.text = widget.id.category ?? '';

    // Checks to see if the task already has a completion date set
    DateTime? newDate =
        DateTime.tryParse(widget.id.completion.toString()) ?? DateTime.now();
    DateTime currentDate = newDate; // => Why can't I use newDate directly

    TimeOfDay? newTime = TimeOfDay.fromDateTime(
      DateTime.parse(
        widget.id.alarm ?? DateTime.now().toString(),
      ),
    );
    TimeOfDay currentTime = newTime; // => Why can't I use newTime directly

    bool proceed = true;
    DateTime? editedAlarm; // Store the changed alarm value

    return Consumer<TodoBloc>(
      builder: (BuildContext context, data, Widget? child) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus
              ?.unfocus(), // To remove the focus of the text field
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 20, right: 5),
              child: Card(
                color: kScaffoldColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(27.0),
                ),
                elevation: 6,
                shadowColor: kShadowColor,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    if (data.formKey.currentState!.validate()) {
                      // Verify that the setDate and setTime are in the future
                      DateTime verify =
                          toDateTime(date: currentDate, time: newTime!);

                      if (status) {
                        if (verify.isBefore(DateTime.now()) == true) {
                          proceed = false;
                        } else {
                          editedAlarm = verify;
                          proceed = true;
                        }
                      }

                      // Create a new Task and populate them with predetermined values
                      final newTodo = Todo(
                        id: widget.id.id,
                        task: myTaskController.value.text,
                        category: myCategoryController.value.text.isEmpty
                            ? null
                            : myCategoryController.value.text,
                        completion: newDate.toString(),
                        alarm: editedAlarm?.toString(),
                        ring: status,
                      );

                      // Update the data in the database
                      data.updateTodo(newTodo);

                      if (newTodo.alarm != null && status) {
                        // Schedule a notification if the use wants it
                        NotificationService().scheduleNotifications(
                          time: DateTime.parse(newTodo.alarm!),
                          id: newTodo.id!,
                          notify: newTodo.task,
                          heading: newTodo.category,
                        );
                      }
                      if (proceed) {
                        Navigator.pop(context);
                      } else {
                        snackbarMessage(
                            'You are setting a notification for a past date');
                      }
                    }
                  },
                  label: const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
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
                          const Text(
                            'Edit Task',
                            style: TextStyle(
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
                                    Text(
                                      "Completion Date",
                                      style: TextStyle(fontSize: 18.5),
                                    ),
                                  ],
                                ),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(90, 40),
                                    elevation: 3,
                                    backgroundColor: kScaffoldColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  onPressed: () async {
                                    newDate = await showDatePicker(
                                      context: context,
                                      initialDate: currentDate,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
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
                                      fontSize: 18.5,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.alarm,
                                      size: 34,
                                      color: status
                                          ? Colors.white
                                          : Colors.white60,
                                    ),
                                    const SizedBox(width: 15),
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        minimumSize: const Size(90, 40),
                                        elevation: 3,
                                        backgroundColor: kScaffoldColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      onPressed: () async {
                                        newTime = await showTimePicker(
                                          context: context,
                                          initialTime: currentTime,
                                        );
                                        if (newTime != null) {
                                          // Update all instances of newDate
                                          currentTime = newTime!;
                                          log(editedAlarm.toString());
                                          data.update(value2: newTime);
                                        }
                                      },
                                      child: Text(
                                        newTime != null && status
                                            ? '${newTime!.hour} : ${newTime!.minute} ${newTime!.period.name}'
                                            : 'Disabled',
                                        style: TextStyle(
                                          fontSize: 18.5,
                                          color: status
                                              ? Colors.white
                                              : Colors.white60,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                FlutterSwitch(
                                  value: status,
                                  onToggle: (value) {
                                    setState(() {
                                      status = !status;
                                    });
                                  },
                                  toggleSize: 22,
                                  height: 30,
                                  width: 60,
                                  inactiveColor: kScaffoldColor,
                                  activeColor: kTertiaryColor,
                                  padding: 5,
                                  inactiveSwitchBorder: Border.all(
                                    color: Colors.white30,
                                    width: 1.2,
                                  ),
                                  activeSwitchBorder: Border.all(
                                    color: kTertiaryColor,
                                  ),
                                ),
                              ],
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

  @override
  void dispose() {
    myTaskController.dispose();
    myCategoryController.dispose();
    super.dispose();
  }

  snackbarMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 1500),
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  toDateTime({
    required TimeOfDay time,
    required DateTime date,
  }) =>
      DateTime(date.year, date.month, date.day, time.hour, time.minute);
}
