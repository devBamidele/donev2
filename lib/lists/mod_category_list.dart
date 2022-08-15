import 'dart:developer';

import 'package:donev2/bloc/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/todo.dart';
import '../reusables/task_tile.dart';
import 'extras/loading_data.dart';
import 'extras/none_available.dart';

class ModifiedCategoryList extends StatelessWidget {
  const ModifiedCategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoBloc>(
      builder: (_, data, Widget? child) {
        return StreamBuilder(
          stream: data.group,
          builder: (
            BuildContext context,
            AsyncSnapshot<List<Todo>?> snapshot,
          ) {
            if (!snapshot.hasData) {
              // At the initial stage when there is no stream
              data.getGroup(category: data.selected);
              return const LoadingData();
            } else {
              return snapshot
                      .data!.isNotEmpty // When the snapshots are received
                  ? ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context)
                          .copyWith(scrollbars: false),
                      child: ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          data.length = snapshot.data?.length;
                          log(data.length.toString());
                          Todo task = snapshot.data![index];
                          return TaskTile(
                            id: task,
                            deleteCallback: () {
                              data.deleteTodoById(task.id!);
                            },
                            task: task.task!,
                            checkboxCallback: (bool? value) {
                              task.isDone = !task.isDone;
                              data.updateTodo(task);
                            },
                            isChecked: task.isDone,
                            complete: task.completion != null
                                ? DateTime.tryParse(task.completion!)
                                : null, // What if I pass a null value ? 👀
                            alarm: task.alarm,
                          );
                        },
                      ),
                    )
                  : const NoneAvailable(
                      message: 'No current tasks',
                    ); // If the snapshots are empty
            }
          },
        );
      },
    );
  }
}
