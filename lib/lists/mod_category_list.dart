import 'package:donev2/bloc/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/todo.dart';

class ModifiedCategoryList extends StatelessWidget {
  const ModifiedCategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoBloc>(
      builder: (_, data, Widget? child) {
        return StreamBuilder(
            stream: data.todos,
            builder: (
              BuildContext context,
              AsyncSnapshot<List<Todo>?> snapshot,
            ) {
              return Container();
            });
      },
    );
  }
}
