import 'package:donev2/constants.dart';
import 'package:donev2/screens/add_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc/todo_bloc.dart';
import '../lists/category_list.dart';
import '../lists/task_list.dart';
import '../reusables/rename_sheet.dart';
import 'extras/task_search.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const tag = '/home';

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoBloc>(
      builder: (BuildContext context, data, Widget? child) {
        return Scaffold(
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 5),
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
                left: 9,
                right: 9,
                bottom: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 6, top: 2),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.done_rounded,
                              size: 27,
                              color: kShadowColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Done',
                              style: TextStyle(
                                fontFamily: 'Asap',
                                letterSpacing: 1,
                                fontSize: 22.5,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Search',
                        iconSize: kIconSize,
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: TaskSearch(hintText: 'Search'),
                          );
                        },
                        icon: const Icon(
                          Icons.search_rounded,
                          color: kTertiaryColor,
                        ),
                      )
                    ],
                  ),
                  spacing(height: 3),
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
                          iconSize: kEditIconSize,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'YOUR TASKS',
                          style: kText1,
                        ),
                      ),
                    ],
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

  spacing({double height = 15}) {
    return SizedBox(
      height: height,
    );
  }
}
