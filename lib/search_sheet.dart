import 'package:donev2/bloc/todo_bloc.dart';
import 'package:donev2/screens/category_screen.dart';
import 'package:donev2/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';

/// The sheet that comes in display when the search button is clicked
class SearchSheet extends StatelessWidget {
  const SearchSheet({
    required this.searchText,
    required this.screen,
    Key? key,
  }) : super(key: key);

  final String searchText;
  final String screen;

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return Consumer<TodoBloc>(builder: (_, data, Widget? child) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: searchController,
                            textInputAction: TextInputAction.newline,
                            maxLength: 20,
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w400,
                            ),
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: searchText,
                              labelText: 'Use keywords *',
                              labelStyle: const TextStyle(
                                color: kTertiaryColor,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Go',
                          iconSize: kIconSize - 2,
                          icon: const Icon(
                            Icons.search_rounded,
                            color: kTertiaryColor,
                          ),
                          onPressed: () {
                            if (screen == HomeScreen.tag) {
                              data.getTodos(query: searchController.value.text);
                              data.getCategories(
                                  query: searchController.value.text);
                            } else if (screen == CategoryScreen.tag) {
                              data.getGroup(
                                  category: data.selected,
                                  query: searchController.value.text);
                            }
                            //dismisses the bottomsheet
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
