import 'package:donev2/screens/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc/todo_bloc.dart';
import '../constants.dart';

/// The popup menu that shows up on the [CategoryScreen]
/// - Show all
/// - Completed
/// - Uncompleted
/// - Delete
class PopUpMenu extends StatelessWidget {
  const PopUpMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoBloc>(
      builder: (_, data, Widget? child) {
        return PopupMenuButton(
          enableFeedback: true,
          icon: Icon(
            Icons.more_vert_rounded,
            size: kIconSize,
            color: kTertiaryColor,
          ),
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            PopupMenuItem(
              onTap: () {
                data.getGroup(category: data.selected);
              },
              child: const Text('Show all'),
            ),
            PopupMenuItem(
              onTap: () {
                data.getGroup(category: data.selected, selected: 1);
                data.currentOption = 1;
              },
              child: const Text('Completed'),
            ),
            PopupMenuItem(
              onTap: () {
                data.getGroup(category: data.selected, selected: 0);
                data.currentOption = 0;
              },
              child: const Text('Uncompleted'),
            ),
            PopupMenuItem(
              onTap: () {
                Future.delayed(
                  const Duration(seconds: 0),
                  () => showDialog(
                    // Display the confirmation to delete Category
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text(
                        'Delete ${data.selected}',
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
                            style:
                                TextStyle(color: kTertiaryColor, fontSize: 16),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            data.deleteCategory(data.selected);
                            int count = 0;
                            // Pop up the stack twice
                            Navigator.of(context).popUntil((_) => count++ >= 2);
                            // Show the snackbar message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(milliseconds: 1200),
                                content: Text(
                                  'Successfully deleted \'${data.selected}\'',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Confirm',
                            style: TextStyle(color: kShadowColor, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
