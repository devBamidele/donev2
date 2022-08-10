import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:intl/intl.dart';

/// The class that controls the appearance of each task tile
class TaskTile extends StatelessWidget {
  const TaskTile({
    required this.task,
    required this.complete,
    required this.isChecked,
    required this.deleteCallback,
    required this.checkboxCallback,
    Key? key,
  }) : super(key: key);

  final String task;
  final bool isChecked;
  final DateTime? complete;
  final Function deleteCallback;
  final Function(bool?) checkboxCallback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.28,
          children: [
            SlidableAction(
              onPressed: (_) =>
                  deleteCallback(), // When the delete button is pressed, call the deleteCallback function
              backgroundColor: const Color(0xFFbd6b73),
              foregroundColor: Colors.white,
              icon: Icons.delete_rounded,
              label: 'Delete',
              borderRadius: BorderRadius.circular(18),
            ),
          ],
        ),
        child: ListTile(
          onTap: () {}, // When the user clicks on the task
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
    );
  }
}