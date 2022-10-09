import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc/todo_bloc.dart';
import '../constants.dart';

/// Contains all the widgets needed to rename
/// a Category or the username
class RenameSheet extends StatelessWidget {
  const RenameSheet({
    required this.function,
    Key? key,
  }) : super(key: key);

  final String function;

  @override
  Widget build(BuildContext context) {
    final editNameController = TextEditingController();

    // Ensure the text field displays the corresponding value
    editNameController.text = function == '/name'
        ? Provider.of<TodoBloc>(context, listen: false).username!
        : Provider.of<TodoBloc>(context, listen: false).selected;
    return Consumer<TodoBloc>(
        builder: (BuildContext context, data, Widget? child) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Form(
                            key: data.formKey,
                            child: TextFormField(
                              validator: (value) {
                                // Ensure the text field passes some criteria
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a name';
                                } else if (value.startsWith(' ')) {
                                  return 'Cannot start with a space';
                                } else {
                                  return null;
                                }
                              },
                              controller: editNameController,
                              textInputAction: TextInputAction.newline,
                              maxLength:
                                  // The rename sheet could either be to change the name of a category
                                  // Or to change the username
                                  function == '/name'
                                      ? data.maxLength
                                      : maxCategoryLength,
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w400,
                              ),
                              autofocus: true,
                              decoration: const InputDecoration(
                                hintText: 'Change name',
                                labelText: 'Edit',
                                labelStyle: TextStyle(
                                  color: kTertiaryColor,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Save',
                          iconSize: kIconSize - 2,
                          icon: const Icon(
                            Icons.save_rounded,
                            color: kTertiaryColor,
                          ),
                          onPressed: () {
                            String text = editNameController.value.text;
                            if (data.formKey.currentState!.validate()) {
                              if (function == '/name') {
                                data.editName(name: text);
                                data.getName();
                              } else if (function == '/category') {
                                // Change the category name
                                data.renameCategory(
                                  from: data.selected,
                                  to: text,
                                );
                                data.getGroup(category: text); // Update values
                              }
                              //dismisses the bottomsheet
                              context.router.pop();
                            }
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
