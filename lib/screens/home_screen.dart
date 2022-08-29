import 'package:donev2/constants.dart';
import 'package:donev2/screens/add_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc/todo_bloc.dart';
import '../lists/category_list.dart';
import '../lists/task_list.dart';
import 'extras/rename_sheet.dart';
import 'extras/search_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const tag = '/';

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoBloc>(
      builder: (BuildContext context, data, Widget? child) {
        return Scaffold(
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 5),
            child: Card(
              color: kScaffoldColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(27.0),
              ),
              elevation: 8,
              shadowColor: kShadowColor,
              child: FloatingActionButton(
                onPressed: () {
                  // Navigate to Add Task Screen
                  data.getNext();
                  Navigator.pushNamed(context, AddScreen.tag);
                },
                tooltip: 'Add a task',
                child: const Icon(
                  Icons.add,
                  size: 33,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 5,
                left: 15,
                right: 15,
                bottom: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        tooltip: 'Show all',
                        iconSize: kIconSize,
                        onPressed: () {
                          data.getTodos();
                          data.getCategories();
                        },
                        icon: const Icon(
                          Icons.menu_rounded,
                          color: kTertiaryColor,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Search',
                        iconSize: kIconSize,
                        onPressed: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            shape: kRoundedBorder,
                            context: context,
                            builder: (context) => const SearchSheet(
                              searchText: 'Search everywhere',
                              screen: tag,
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.search_rounded,
                          color: kTertiaryColor,
                        ),
                      )
                    ],
                  ),
                  spacing(height: 7),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Text(
                          'What\'s up, ${data.username}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 29,
                            letterSpacing: 1.5,
                          ),
                        ),
                        IconButton(
                          padding: const EdgeInsets.only(bottom: 13, left: 5),
                          alignment: Alignment.bottomLeft,
                          tooltip: 'Rename',
                          iconSize: 16,
                          onPressed: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              shape: kRoundedBorder,
                              context: context,
                              builder: (context) => const RenameSheet(
                                function: '/name',
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.mode_edit_rounded,
                            color: kTertiaryColor,
                          ),
                        )
                      ],
                    ),
                  ),
                  spacing(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'CATEGORIES',
                      style: kText1,
                    ),
                  ),
                  spacing(),
                  const SizedBox(
                    height: 110,
                    child: CategoryList(),
                  ),
                  spacing(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'YOUR TASKS',
                      style: kText1,
                    ),
                  ),
                  spacing(),
                  const Expanded(
                    child: TaskList(),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  spacing({double height = 20}) {
    return SizedBox(
      height: height,
    );
  }
}
