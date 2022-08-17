import 'package:donev2/bloc/todo_bloc.dart';
import 'package:donev2/constants.dart';
import 'package:donev2/lists/mod_category_list.dart';
import 'package:donev2/search_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'extras/custom_back_button.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  static const tag = '/category';

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoBloc>(
      builder: (_, data, Widget? child) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomBackButton(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            tooltip: 'Show all',
                            iconSize: kIconSize,
                            onPressed: () {
                              data.getGroup(category: data.selected);
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
                                builder: (context) => SearchSheet(
                                  searchText: 'Search ${data.selected}',
                                  screen: tag,
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.search_rounded,
                              color: kTertiaryColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.selected,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Text(
                          data.length! > 1
                              ? '${data.length} tasks'
                              : '${data.length} task',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        const Text(
                          'Tasks',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Expanded(
                          child: ModifiedCategoryList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
