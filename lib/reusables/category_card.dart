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
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: GestureDetector(
            onTap: () {
              data.selected = category;
              data.getGroup(category: data.selected!);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryScreen(
                    category: category,
                    taskNo: taskNo,
                  ),
                ),
              );
            },
            child: Container(
              width: 195,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(1.5, 1.5), //(x,y)
                    blurRadius: 3.5,
                  ),
                ],
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(15),
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
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
