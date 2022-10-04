import 'package:donev2/constants.dart';
import 'package:donev2/lists/extras/loading.dart';
import 'package:donev2/reusables/search_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../bloc/todo_bloc.dart';
import '../../lists/category_list.dart';
import '../../lists/extras/none_available.dart';
import '../../lists/task_list.dart';
import '../../model/todo.dart';

/// Searches for both tasks and categories
class TaskSearch extends SearchDelegate {
  TaskSearch({
    required String hintText,
  }) : super(searchFieldLabel: hintText);

  @override
  // The widget that shows up on the left hand side of the screen
  Widget? buildLeading(BuildContext context) {
    // When the back button is pressed
    return IconButton(
      onPressed: () => close(context, null),
      icon: Icon(
        Icons.arrow_back_rounded,
        color: kTertiaryColor,
        size: kIconSize - 5,
      ),
    );
  }

  @override
  // Positions widgets at the right had of the screen
  List<Widget>? buildActions(BuildContext context) {
    return [
      // When the cancel icon is pressed
      query.isNotEmpty
          ? IconButton(
              onPressed: () {
                query = '';
              },
              icon: Icon(
                Icons.clear_rounded,
                size: kIconSize - 5,
                color: kTertiaryColor,
              ),
            )
          : const SizedBox.shrink(),
    ];
  }

  @override
  // Show the search results when the user has submitted a request
  Widget buildResults(BuildContext context) {
    // Pass the query to the TodoBloc
    // The CategoryList and TodoList use this to fetch data
    Provider.of<TodoBloc>(context, listen: false).search = query;

    if (query.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Center(
            child: NoneAvailable(
              message: "Search term cannot be empty",
            ),
          )
        ],
      );
    }

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
  // Displays the search suggestions as the user is typing
  Widget buildSuggestions(BuildContext context) {
    return Consumer<TodoBloc>(
      builder: (_, data, Widget? child) {
        data.getSuggestions(query: query);
        data.getRecent();
        return query.isNotEmpty
            ? StreamBuilder(
                stream: data.suggestions,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<Todo>?> snapshot,
                ) {
                  if (!snapshot.hasData) {
                    return const Loading();
                  } else {
                    return snapshot
                            .data!.isNotEmpty // When the snapshots are received
                        ? ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context).copyWith(
                              scrollbars: false,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 13,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Tasks',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white60,
                                          ),
                                        ),
                                        Text(
                                          '${data.suggestionLength.toString()} found',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white60,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.separated(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        final item = snapshot.data![index];
                                        return SearchItem(
                                          item: item,
                                          show: false,
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              SizedBox(height: kDividerHeight),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const NoneAvailable(
                            message: 'No results found',
                          ); // If the snapshots are empty
                  }
                },
              )
            : StreamBuilder(
                // If the Query is empty
                stream: data.recent,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<Todo>?> snapshot,
                ) {
                  if (!snapshot.hasData) {
                    return const Loading();
                  } else {
                    return snapshot
                            .data!.isNotEmpty // When the snapshots are received
                        ? ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context).copyWith(
                              scrollbars: false,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                                horizontal: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Recent',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white60,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            data.clearSearch();
                                          },
                                          child: const Text(
                                            'Clear history',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white60,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.separated(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        final item = snapshot.data![index];
                                        return SearchItem(item: item);
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              SizedBox(height: kDividerHeight),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const NoneAvailable(
                            message: 'No recent searches',
                          ); // If the snapshots are empty
                  }
                },
              );
      },
    );
  }

  @override
  close(BuildContext context, dynamic result) {
    super.close(context, result);
    // Trigger some actions when the user exits the Search Screen
    Provider.of<TodoBloc>(context, listen: false).exitSearchFromHome();
  }

  spacing({double height = 15}) => SizedBox(height: height);
}
