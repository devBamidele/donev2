import 'package:auto_route/auto_route.dart';
import 'package:donev2/constants.dart';
import 'package:donev2/screens/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../bloc/todo_bloc.dart';

/// The Card that hold information about the category
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    required this.category,
    required this.taskNo,
    Key? key,
  }) : super(key: key);

  final String category;
  final int taskNo;

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoBloc>(
      builder: (_, data, Widget? child) {
        return GestureDetector(
          // Manage gestures
          onTap: () {
            data.selected = category;
            data.getGroup(category: data.selected);
            context.router.pushNamed(CategoryScreen.tag);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Card(
              elevation: 12,
              child: Container(
                width: 195,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  color: kListTileColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        taskAmount(taskNo),
                        style: const TextStyle(
                          fontSize: 16,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      FittedBox(
                        // Make the text scale down to fit its bounds
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          category,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  taskAmount(int length) {
    String text = '';
    if (length > 1) {
      text = '$length tasks';
    } else if (length == 1) {
      text = '$length task';
    } else {
      text = 'No current tasks';
    }
    return text;
  }
}
