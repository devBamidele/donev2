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

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoBloc>(
      builder: (_, data, Widget? child) {
        return Dismissible(
          background: Container(
            color: kScaffoldColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const Icon(
                      Icons.delete_outline_outlined,
                      color: kSecondaryColor,
                      size: 33,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Delete $category',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          onDismissed: (direction) {},
          confirmDismiss: (direction) async {
            return showDialog<bool?>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Delete $category?'),
                  content: const Text(
                      'Are you sure you want to delete this category. You cannot undo this action !'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      child: const Text('Confirm'),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                    ),
                  ],
                );
              },
            );
          },
          direction: DismissDirection.vertical,
          key: ObjectKey(id),
          child: GestureDetector(
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
          ),
        );
      },
    );
  }
}
