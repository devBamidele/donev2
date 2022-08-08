import 'package:donev2/model/todo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc/todo_bloc.dart';
import 'extras/loading_data.dart';
import 'extras/none_available.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoBloc>(
      builder: (_, data, Widget? child) {
        return StreamBuilder(
          stream: data.todos,
          builder: (BuildContext context, AsyncSnapshot<List<Todo>?> snapshot) {
            if (!snapshot.hasData) {
              // At the initial stage when there is no stream
              data.getTodos();
              return const LoadingData();
            } else {
              return snapshot
                      .data!.isNotEmpty // When the snapshots are received
                  ? Container(
                      color: Colors.red,
                    )
                  : const NoneAvailable(); // If the snapshots are empty
            }
          },
        );
      },
    );
  }
}
