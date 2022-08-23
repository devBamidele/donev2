import 'package:donev2/bloc/todo_bloc.dart';
import 'package:donev2/constants.dart';
import 'package:donev2/lists/mod_category_list.dart';
import 'package:donev2/screens/extras/search_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'extras/custom_back_button.dart';
import 'extras/rename_sheet.dart';

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
                          PopupMenuButton(
                            color: const Color(0xff12172B),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            icon: Icon(
                              Icons.more_vert_rounded,
                              size: kIconSize,
                              color: kTertiaryColor,
                            ),
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry>[
                              PopupMenuItem(
                                onTap: () {
                                  data.getGroup(category: data.selected);
                                },
                                child: const Text('Show all'),
                              ),
                              const PopupMenuDivider(),
                              PopupMenuItem(
                                onTap: () {
                                  data.getGroup(
                                      category: data.selected, selected: 1);
                                  data.currentOption = 1;
                                },
                                child: const Text('Completed'),
                              ),
                              const PopupMenuDivider(),
                              PopupMenuItem(
                                onTap: () {
                                  data.getGroup(
                                      category: data.selected, selected: 0);
                                  data.currentOption = 0;
                                },
                                child: const Text('Uncompleted'),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    data.selected,
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  IconButton(
                                    padding: const EdgeInsets.only(
                                      bottom: 11,
                                      left: 5,
                                    ),
                                    alignment: Alignment.bottomLeft,
                                    tooltip: 'Rename',
                                    iconSize: 16,
                                    onPressed: () {
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        shape: kRoundedBorder,
                                        context: context,
                                        builder: (context) => const RenameSheet(
                                          function: '/category',
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
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                data.length! > 1
                                    ? '${data.length} tasks'
                                    : '${data.length} task',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              const Text(
                                'Tasks',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
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
