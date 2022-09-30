import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc/todo_bloc.dart';
import '../model/todo.dart';
import '../reusables/task_tile.dart';
import 'extras/loading.dart';
import 'extras/none_available.dart';

/// Display the tasks as a list
class TaskList extends StatelessWidget {
  const TaskList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoBloc>(
      builder: (_, data, Widget? child) {
        return StreamBuilder(
          stream: data.todos, // Supply the stream
          builder: (
            BuildContext context,
            AsyncSnapshot<List<Todo>?> snapshot,
          ) {
            if (!snapshot.hasData) {
              data.getTodos(query: data.search);
              // At the initial stage when there is no stream
              return const Loading();
            } else {
              return snapshot
                      .data!.isNotEmpty // When the snapshots are received
                  ? ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        scrollbars: false, // Remove the scroll bar by the side
                        physics:
                            const BouncingScrollPhysics(), // Create a bouncy scroll effect
                      ),
                      child: ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          Todo task = snapshot.data![index];
                          return TaskTile(
                            id: task,
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
