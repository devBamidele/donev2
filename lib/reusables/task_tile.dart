import 'dart:math' as math;

import 'package:donev2/bloc/todo_bloc.dart';
import 'package:donev2/constants.dart';
import 'package:donev2/notification/notification_service.dart';
import 'package:donev2/screens/edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:intl/intl.dart';

import '../model/todo.dart';

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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(milliseconds: 1200),
                  content: Text(
                    'Successfully deleted \'${id.task}\'',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
            direction: DismissDirection.startToEnd,
            key: ObjectKey(id.id!),
            child: Card(
              elevation: 8,
              child: ListTile(
                onTap: () {
                  // When the user clicks on the task
                  data.onSelectedTask(id);
                  Navigator.pushNamed(context, EditScreen.tag, arguments: id);
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
                    data.updateTodo(id);
                  },
                  isChecked: id.isDone,
                  size: 25,
                ),
                trailing: Transform.rotate(
                  angle: math.pi / 15,
                  child: trailingWidget(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  dateWidget() {
    Widget value = const SizedBox.shrink();
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

  trailingWidget() {
    dynamic value = const SizedBox.shrink();

    if (alarm != null) {
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

