import 'package:auto_route/auto_route.dart';
import 'package:donev2/bloc/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

// Customized button for popping off the stack
class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoBloc>(
      builder: (_, data, Widget? child) {
        return IconButton(
          tooltip: 'Navigate back',
          iconSize: kIconSize,
          color: Colors.black54,
          onPressed: () {
            data.getTodos();
            data.getCategories();
            context.router.pop();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: kTertiaryColor,
          ),
        );
      },
    );
  }
}
