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
        return Dismissible(
          background: Container(
            color: kScaffoldColor,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.delete_outline_outlined,
                      color: kSecondaryColor,
                      size: 34,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Delete',
                      style: TextStyle(
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
          onDismissed: (direction) {
            data.deleteCategory(category);
            // Display a short pop up message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(milliseconds: 1200),
                content: Text(
                  'Successfully deleted \'$category\'',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
          confirmDismiss: (direction) async {
            return showDialog<bool?>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    'Delete $category',
                  ),
                  content: const Text(
                      'Are you sure you want to delete this category ?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: kTertiaryColor, fontSize: 18),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text(
                        'Confirm',
                        style: TextStyle(color: kShadowColor, fontSize: 18),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          direction: DismissDirection.down,
          key: ObjectKey(id),
          child: GestureDetector(
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
