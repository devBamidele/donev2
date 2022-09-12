import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../bloc/todo_bloc.dart';
import '../../constants.dart';
import '../../lists/extras/none_available.dart';
import '../../lists/mod_category_list.dart';

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
    // The search results that are displayed
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
            data.groupLength! > 0
                ? Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Tasks (${data.groupLength})',
                            style: kText1,
                          ),
                        ),
                        spacing(),
                        const Expanded(
                          child: ModifiedCategoryList(),
                        )
                      ],
                    ),
                  )
                : const Expanded(
                    child: Center(
                      child: NoneAvailable(
                        message: 'No results found',
                      ),
                    ),
                  )
          ],
        ),
      );
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Provider.of<TodoBloc>(context, listen: false).search = query;
    return Consumer<TodoBloc>(
      builder: (_, data, Widget? child) {
        //data.search = query;
        data.getGroup(category: data.selected, query: query);
        return query.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      child: data.groupLength! > 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  '${data.groupLength.toString()} found',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white60,
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),
                    const Expanded(
                      child: ModifiedCategoryList(
                        customMessage: 'No search results',
                      ),
                    ),
                  ],
                ),
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
