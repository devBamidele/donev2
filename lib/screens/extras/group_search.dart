import 'package:donev2/screens/extras/search_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../bloc/todo_bloc.dart';
import '../../constants.dart';
import '../../lists/extras/loading_data.dart';
import '../../lists/extras/none_available.dart';
import '../../model/todo.dart';

class GroupSearch extends SearchDelegate {
  GroupSearch({
    required String hintText,
  }) : super(searchFieldLabel: hintText);

  @override
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
  Widget buildSuggestions(BuildContext context) {
    return resultAndSuggestions(context);
  }

  Widget resultAndSuggestions(BuildContext context) {
    return Consumer<TodoBloc>(
      builder: (_, data, Widget? child) {
        data.getSuggestions(query: query, showAllTasks: false);
        return query.isNotEmpty
            ? StreamBuilder(
                stream: data.suggestions,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<Todo>?> snapshot,
                ) {
                  if (!snapshot.hasData) {
                    return const LoadingData();
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
                                              const SizedBox(height: 10),
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
    Provider.of<TodoBloc>(context, listen: false).exitSearchFromCategory();
  }

  spacing({double height = 15}) => SizedBox(height: height);
}
