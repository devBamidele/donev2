import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:intl/intl.dart';

import '../model/todo.dart';
import '../screens/add_screen.dart';

/// The class that controls the appearance of each task tile
class TaskTile extends StatelessWidget {
  const TaskTile({
    required this.id,
    required this.task,
    required this.alarm,
    required this.complete,
    required this.isChecked,
    required this.deleteCallback,
    required this.checkboxCallback,
    Key? key,
  }) : super(key: key);

  final Todo id;
  final String task;
  final String? alarm;
  final bool isChecked;
  final DateTime? complete;
  final Function deleteCallback;
  final Function(bool?) checkboxCallback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.28,
          children: [
            SlidableAction(
              onPressed: (_) =>
                  deleteCallback(), // When the delete button is pressed, call the deleteCallback function
              backgroundColor: Colors.red.withOpacity(0.7),
              foregroundColor: Colors.white,
              icon: Icons.delete_rounded,
              label: 'Delete',
              borderRadius: BorderRadius.circular(18),
            ),
          ],
        ),
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddScreen(id: id),
              ),
            );
          }, // When the user clicks on the task
          tileColor: Colors.white.withOpacity(0.8),
          title: Text(
            task,
            style: TextStyle(
              fontSize: 18,
              decoration: isChecked ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            complete != null
                ? DateFormat('EEEE,  MMM dd, y.').format(complete!)
                : 'No completion date',
          ),
          horizontalTitleGap: 5,
          leading: RoundCheckBox(
            checkedWidget: const Icon(
              Icons.check,
              color: Colors.black,
              size: 18,
            ),
            checkedColor: Colors.grey,
            onTap: checkboxCallback,
            isChecked: isChecked,
            size: 23,
          ),
          trailing: Transform.rotate(
            angle: math.pi / 15,
            child: alarm != null
                ? const Icon(
                    Icons.notifications_active_outlined,
                    color: Colors.grey,
                    size: 24,
                  )
                : const SizedBox.shrink(),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
    );
  }
}
