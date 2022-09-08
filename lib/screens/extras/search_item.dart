import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../bloc/todo_bloc.dart';
import '../../model/todo.dart';
import '../edit_screen.dart';

class SearchItem extends StatelessWidget {
  const SearchItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Todo item;

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoBloc>(
      builder: (_, data, Widget? child) {
        return ListTile(
          title: Text(item.task),
          trailing: Text(item.category ?? ''),
          onTap: () {
            // When the user clicks on the task
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
