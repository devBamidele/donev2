import 'package:donev2/constants.dart';
import 'package:donev2/screens/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../bloc/todo_bloc.dart';

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
          onTap: () {
            data.selected = category;
            data.length = taskNo;
            data.getGroup(category: data.selected);
            Navigator.pushNamed(context, CategoryScreen.tag);
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
                        taskNo > 1 ? '$taskNo tasks' : '$taskNo task',
                        style: const TextStyle(
                          fontSize: 16,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        category,
                        style: const TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
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
}
