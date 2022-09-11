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
  String timeFormat() {
    return '$hour : $minute ${period.name}';
  }
}

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  static const tag = '/add';

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final myTaskController = TextEditingController();
  final myCategoryController = TextEditingController();
  bool alarmEnabled = false;

  @override
  Widget build(BuildContext context) {
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
                      DateTime verify = toDateTime(
                        date: data.selectedDate!,
                        time: data.selectedTime!,
                      );

                      if (alarmEnabled) {
                        if (verify.isBefore(DateTime.now()) == true) {
                          proceed = false;
                        } else {
                          editedAlarm = verify;
                          proceed = true;
                        }
                      }

                      if (proceed) {
                        final newTodo = Todo(
                          task: myTaskController.value.text,
                          category: myCategoryController.value.text.isEmpty
                              ? null
                              : myCategoryController.value.text,
                          completion: data.selectedDate.toString(),
                          alarm: editedAlarm?.toString(),
                          ring: alarmEnabled,
                        );

                        // Add the task to the data base
                        data.addTodo(newTodo);

                        if (newTodo.alarm != null && alarmEnabled) {
                          // Schedule a notification if the use wants it
                          NotificationService().scheduleNotifications(
                            time: DateTime.parse(newTodo.alarm!),
                            id: data.nextNumber! + 1,
                            notify: newTodo.task,
                            heading: newTodo.category,
                          );
                        }

                        // Refresh the date and time
                        data.refreshDateAndTime();
                        Navigator.pop(context);
                      } else {
                        snackbarMessage(
                          'You set a past-due alert',
                        );
                      }
                    }
                  },
                  label: const Text(
                    'Create',
                    style: TextStyle(
                      fontSize: 19,
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
                      padding: EdgeInsets.only(left: 10, top: 5),
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
                            'Add Task',
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
                                    fontSize: 24.5,
                                  ),
                                  controller: myTaskController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a task';
                                    } else if (value.startsWith(' ')) {
                                      return 'Cannot start with a space';
                                    } else if (value.length < 3) {
                                      return 'Too short';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'New Task',
                                  ),
                                ),
                                TextFormField(
                                  maxLength: 12,
                                  style: const TextStyle(
                                    fontSize: 18.5,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  controller: myCategoryController,
                                  decoration: const InputDecoration(
                                    hintText: 'Group by Category',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 35,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time_rounded,
                                      size: kIconSize,
                                    ),
                                    const SizedBox(width: 25),
                                    Row(
                                      children: const [
                                        Text(
                                          "All-day",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                FlutterSwitch(
                                  value: !alarmEnabled,
                                  onToggle: (value) {
                                    setState(() {
                                      alarmEnabled = !alarmEnabled;
                                    });
                                  },
                                  toggleSize: 19,
                                  height: 23,
                                  width: 50,
                                  inactiveColor: kScaffoldColor,
                                  activeColor: kTertiaryColor,
                                  padding: 2.5,
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
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    data.selectedDate = await showDatePicker(
                                      context: context,
                                      initialDate: data.selectedDate!,
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
                                  },
                                  child: Text(
                                    data.selectedDate != null
                                        ? DateFormat('EEEE, d MMM y')
                                            .format(data.selectedDate!)
                                        : 'No date selected',
                                  ),
                                ),
                                alarmEnabled // Display the time only if it's not an all day event
                                    ? TextButton(
                                        onPressed: () async {
                                          data.selectedTime =
                                              await showTimePicker(
                                            context: context,
                                            initialTime: data.selectedTime!,
                                          );
                                        },
                                        child: Text(
                                          data.selectedTime!.timeFormat(),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
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
