import 'package:donev2/bloc/todo_bloc.dart';
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
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: CustomBackButton(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    child: Column(
                      children: [
                        Text(
                          data.selected,
                          style: const TextStyle(
                            fontSize: 34,
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
                        const SizedBox(
                          height: 200,
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
