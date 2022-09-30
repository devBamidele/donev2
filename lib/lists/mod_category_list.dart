import 'package:donev2/bloc/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/todo.dart';
import '../reusables/task_tile.dart';
import 'extras/loading.dart';
import 'extras/none_available.dart';

/// The list of tasks that appear within a category on the [CategoryScreen]
class ModifiedCategoryList extends StatelessWidget {
  const ModifiedCategoryList({this.customMessage, Key? key}) : super(key: key);

  final String? customMessage;
  @override
  Widget build(BuildContext context) {
    return Consumer<TodoBloc>(
      builder: (_, data, Widget? child) {
        return StreamBuilder(
          stream: data.group, // Supply a stream
          builder: (
            BuildContext context,
            AsyncSnapshot<List<Todo>?> snapshot,
          ) {
            if (!snapshot.hasData) {
              // At the initial stage when there is no stream
              data.getGroup(category: data.selected);
              return const Loading();
            } else {
              return snapshot
                      .data!.isNotEmpty // When the snapshots are received
                  ? ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        scrollbars: false, // Remove the scrollbar by the side
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
                  : NoneAvailable(
                      message: customMessage ?? 'No current tasks',
                    ); // If the snapshots are empty
            }
          },
        );
      },
    );
  }
}
