import 'package:donev2/notification/notification_service.dart';
import 'package:donev2/screens/add_screen.dart' show TimeOfDayExtension;
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../bloc/todo_bloc.dart';
import '../constants.dart';
import '../model/todo.dart';
import '../reusables/custom_back_button.dart';

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
  late bool alarmEnabled = widget.id.ring;

  @override
  Widget build(BuildContext context) {
    myTaskController.text = widget.id.task;
    myCategoryController.text = widget.id.category ?? '';

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
                        // Create a new Task and populate them with predetermined values
                        final newTodo = Todo(
                          id: widget.id.id,
                          task: myTaskController.value.text,
                          category: myCategoryController.value.text.isEmpty
                              ? null
                              : myCategoryController.value.text,
                          isDone: widget.id.isDone,
                          completion: data.selectedDate.toString(),
                          alarm: editedAlarm?.toString(),
                          ring: alarmEnabled,
                          recent: widget.id.recent,
                          lastSearched: widget.id.lastSearched,
                        );

                        // Update the data in the database
                        data.updateTodo(newTodo);

                        if (newTodo.alarm != null && alarmEnabled) {
                          // Schedule a notification if the use wants it
                          NotificationService().scheduleNotifications(
                            time: DateTime.parse(newTodo.alarm!),
                            id: newTodo.id!,
                            notify: newTodo.task,
                            heading: newTodo.category,
                          );
                        }

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
