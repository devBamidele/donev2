import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../bloc/todo_bloc.dart';
import '../../constants.dart';

class RenameSheet extends StatelessWidget {
  const RenameSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editNameController = TextEditingController();
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
                                  return 'Cannot start with \'$value\'';
                                } else {
                                  return null;
                                }
                              },
                              controller: editNameController,
                              textInputAction: TextInputAction.newline,
                              maxLength: data.maxLength,
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
                            if (data.formKey.currentState!.validate()) {
                              data.editName(
                                  name: editNameController.value.text);
                              data.getName();
                              //dismisses the bottomsheet
                              Navigator.pop(context);
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
