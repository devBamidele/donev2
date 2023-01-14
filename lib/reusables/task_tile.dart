import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:donev2/app_router/router.gr.dart';
import 'package:donev2/bloc/todo_bloc.dart';
import 'package:donev2/constants.dart';
import 'package:donev2/notification/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:intl/intl.dart';

import '../model/todo.dart';
import '../utils.dart';

/// Calculate the difference between the current date
/// and the task-date
extension DateTimeExtension on DateTime {
  int calculateDifference() {
    DateTime now = DateTime.now();
    return DateTime(year, month, day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }
}

/// The class that controls the appearance of each task tile
class TaskTile extends StatelessWidget {
  const TaskTile({
    required this.id,
    required this.alarm,
    required this.complete,
    Key? key,
  }) : super(key: key);

  final Todo id;
  final String? alarm;
  final DateTime? complete;

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoBloc>(
      builder: (_, data, Widget? child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
          child: Dismissible(
            background: Container(
              color: kScaffoldColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.delete_outline_outlined,
                        color: kSecondaryColor,
                        size: 34,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Delete',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            onDismissed: (direction) {
              // Delete task from the database and cancel it's notification
              data.deleteTodoById(id.id!);
              NotificationService().cancelNotifications(id.id!);
              // Display a short pop up message
              Utils.showSnackbar(
                'Successfully deleted \'${id.task}\'',
                delay: 1200,
              );
            },
            direction: DismissDirection.startToEnd,
            key: ObjectKey(id.id!),
            child: Card(
              elevation: 8,
              child: Stack(
                children: [
                  ListTile(
                    // When the user clicks on the task
                    onTap: () {
                      data.onSelectedTask(id);
                      context.router.push(EditScreenRoute(id: id));
                    },
                    title: Text(
                      id.task,
                      style: TextStyle(
                        fontSize: 18.5,
                        decoration: id.isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: Colors.black.withOpacity(0.8),
                        decorationThickness: 3,
                      ),
                    ),
                    subtitle: dateWidget(),
                    leading: RoundCheckBox(
                      checkedWidget: const Icon(
                        Icons.check,
                        color: Colors.black,
                        size: 21,
                      ),
                      uncheckedColor: kScaffoldColor,
                      checkedColor: kTertiaryColor,
                      onTap: (bool? value) {
                        id.isDone = !id.isDone;
                        if (id.isDone && id.ring) {
                          // If the task has been checked 'Completed' disable the notification
                          NotificationService().cancelNotifications(id.id!);
                        }
                        if (!id.isDone && id.ring) {
                          final currentAlarm = DateTime.parse(id.alarm!);
                          // Ensure that the alarm is set for a time in the future
                          if (currentAlarm.isAfter(DateTime.now())) {
                            // Schedule the notification
                            NotificationService().scheduleNotifications(
                              time: currentAlarm,
                              id: id.id!,
                              notify: id.task,
                              heading: id.category,
                            );
                          } else {
                            Utils.showSnackbar(
                                'To enable the reminder, update the pre-set time');
                          }
                        }
                        data.updateTodo(id);
                        data.getTodos();
                      },
                      isChecked: id.isDone,
                      size: 25,
                    ),
                    trailing: Transform.rotate(
                      angle: math.pi / 16,
                      child: trailingWidget(),
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

  /// Displays the Date and Time in a specific format
  Widget dateWidget() {
    dynamic value = const SizedBox.shrink();
    String day, time = '';
    if (complete != null) {
      if (id.ring) {
        time =
            (', ${DateFormat.jm().format(DateTime.parse(id.alarm!)).toLowerCase()}');
      }
      if (complete!.calculateDifference() == 0) {
        day = 'Today$time';
      } else if (complete!.calculateDifference() == 1) {
        day = 'Tomorrow$time';
      } else if (complete!.calculateDifference() == -1) {
        day = 'Yesterday$time';
      } else {
        day = DateFormat('EEEE, d MMM y').format(complete!);
      }
      value = Text(day);
    }
    return value;
  }

  /// Displays the bell icon if there is an alarm set in the future
  Widget trailingWidget() {
    dynamic value = const SizedBox.shrink();

    if (alarm != null && id.isDone == false) {
      if (DateTime.parse(alarm!).isAfter(DateTime.now())) {
        value = const Icon(
          Icons.notifications_active_outlined,
          color: kTertiaryColor,
          size: 25,
        );
      }
    }
    return value;
  }
}
