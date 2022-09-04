import 'package:donev2/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../bloc/todo_bloc.dart';
import '../../lists/category_list.dart';
import '../../lists/extras/none_available.dart';
import '../../lists/task_list.dart';

class MySearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) => [
        // When the cancel icon is pressed
        Consumer<TodoBloc>(
            builder: (BuildContext context, data, Widget? child) {
          return IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null); // close search bar
                data.getCategories();
                data.getTodos();
              } else {
                query = '';
              }
            },
            icon: Icon(
              Icons.clear_rounded,
              size: kIconSize,
              color: kTertiaryColor,
            ),
          );
        })
      ];

  @override
  Widget? buildLeading(BuildContext context) {
    // When the back button is pressed
    return Consumer<TodoBloc>(
        builder: (BuildContext context, data, Widget? child) {
      return IconButton(
        onPressed: () {
          close(context, null);
          data.getCategories();
          data.getTodos();
        },
        icon: Icon(
          Icons.arrow_back_rounded,
          color: kTertiaryColor,
          size: kIconSize,
        ),
      );
    });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Consumer<TodoBloc>(
        builder: (BuildContext context, data, Widget? child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spacing(height: 25),
            data.categoryLength! > 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Categories (${data.categoryLength})',
                          style: kText1,
                        ),
                      ),
                      spacing(),
                      const SizedBox(
                        height: 110,
                        child: CategoryList(),
                      ),
                      spacing(),
                    ],
                  )
                : const SizedBox.shrink(),
            data.taskLength! > 0
                ? Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Tasks (${data.taskLength})',
                            style: kText1,
                          ),
                        ),
                        spacing(),
                        const Expanded(
                          child: TaskList(),
                        )
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
            if (data.taskLength == 0 && data.categoryLength == 0)
              const Expanded(
                child: Center(
                  child: NoneAvailable(
                    message: 'No results found',
                  ),
                ),
              )
            else
              const SizedBox.shrink()
          ],
        ),
      );
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  spacing({double height = 15}) => SizedBox(height: height);
}
