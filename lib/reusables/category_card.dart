import 'package:donev2/constants.dart';
import 'package:donev2/screens/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../bloc/todo_bloc.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    required this.category,
    required this.taskNo,
    required this.id,
    Key? key,
  }) : super(key: key);

  final Object id;
  final String category;
  final int taskNo;
  final double cardWidth = 195;

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoBloc>(
      builder: (_, data, Widget? child) {
        return GestureDetector(
          onTap: () {
            data.selected = category;
            data.getGroup(category: data.selected);
            Navigator.pushNamed(context, CategoryScreen.tag);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Card(
              elevation: 12,
              child: Container(
                width: cardWidth,
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
                      FittedBox(
                        // Make the text scale down to fit
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
