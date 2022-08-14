import 'package:donev2/lists/mod_category_list.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({
    required this.category,
    required this.taskNo,
    Key? key,
  }) : super(key: key);

  final String category;
  final int taskNo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 35,
                  ),
                ),
                Text(
                  taskNo > 1 ? '$taskNo tasks' : '$taskNo task',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                Text(
                  'Tasks in $category',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                const Expanded(
                  child: ModifiedCategoryList(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
