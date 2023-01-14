import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_router/router.gr.dart';
import '../bloc/todo_bloc.dart';
import '../constants.dart';
import '../model/todo.dart';

/// The model for a search item during search
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
        return Card(
          elevation: 4,
          child: ListTile(
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
              // Tag the task as recent and update the last search date
              item.recent = true;
              item.lastSearched = DateTime.now().millisecondsSinceEpoch;
              data.updateTodo(item);
              data.onSelectedTask(item);
              context.router.push(
                EditScreenRoute(id: item),
              );
            },
          ),
        );
      },
    );
  }
}
