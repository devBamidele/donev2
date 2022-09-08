import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../bloc/todo_bloc.dart';
import '../../constants.dart';
import '../../model/todo.dart';
import '../edit_screen.dart';

class SearchItem extends StatelessWidget {
  const SearchItem({
    Key? key,
    required this.item,
    this.show = true,
  }) : super(key: key);

  final Todo item;
  final bool show;

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoBloc>(
      builder: (_, data, Widget? child) {
        return ListTile(
          title: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              item.task,
              style: const TextStyle(
                fontSize: 18.5,
              ),
            ),
          ),
          trailing: show
              ? IconButton(
                  padding: const EdgeInsets.only(left: 10),
                  onPressed: () {
                    item.recent = false;
                    data.updateTodo(item);
                  },
                  icon: Icon(
                    Icons.clear_rounded,
                    size: kIconSize - 5,
                  ),
                )
              : const SizedBox.shrink(),
          onTap: () {
            // When the user clicks on the task
            item.recent = true;
            data.updateTodo(item);
            data.onSelectedTask(item);
            Navigator.pushNamed(
              context,
              EditScreen.tag,
              arguments: item,
            );
          },
        );
      },
    );
  }
}
