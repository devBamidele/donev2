import 'package:donev2/reusables/search_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../bloc/todo_bloc.dart';
import '../../constants.dart';
import '../../lists/extras/loading.dart';
import '../../lists/extras/none_available.dart';
import '../../model/todo.dart';

/// Enables search functionality for within the group
class GroupSearch extends SearchDelegate {
  GroupSearch({
    required String hintText,
  }) : super(searchFieldLabel: hintText);

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
  // Show the search results when the user has submitted a request
  Widget buildResults(BuildContext context) {
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

    return resultAndSuggestions(context);
  }

  @override
  // Display the search suggestions as the user is typing
  Widget buildSuggestions(BuildContext context) {
    return resultAndSuggestions(context);
  }

  Widget resultAndSuggestions(BuildContext context) {
    return Consumer<TodoBloc>(
      builder: (_, data, Widget? child) {
        data.getSuggestions(query: query, showAllTasks: false);
        return query.isNotEmpty
            ? StreamBuilder(
                stream: data.suggestions, // Supply the stream
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<Todo>?> snapshot,
                ) {
                  if (!snapshot.hasData) {
                    return const Loading(); // Display the progress indicator
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
            : const SizedBox.shrink();
      },
    );
  }

  @override
  close(BuildContext context, dynamic result) {
    super.close(context, result);
    // Trigger some actions when the user exits the Search Screen
    Provider.of<TodoBloc>(context, listen: false).exitSearchFromCategory();
  }

  spacing({double height = 15}) => SizedBox(height: height);
}
