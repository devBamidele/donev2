import 'package:donev2/bloc/todo_bloc.dart';
import 'package:donev2/constants.dart';
import 'package:donev2/lists/mod_category_list.dart';
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
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 7.5,
                      top: 10,
                      right: 7.5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomBackButton(),
                        IconButton(
                          tooltip: 'Search',
                          iconSize: kIconSize,
                          onPressed: () {},
                          icon: const Icon(
                            Icons.search_rounded,
                            color: kTertiaryColor,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8,
                        left: 15,
                        right: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.selected,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 33,
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
