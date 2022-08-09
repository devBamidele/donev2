import 'package:donev2/constants.dart';
import 'package:donev2/screens/add_screen.dart';
import 'package:flutter/material.dart';

import '../lists/category_list.dart';
import '../lists/task_list.dart';
import '../search_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 5),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddScreen()),
            );
          },
          child: const Icon(
            Icons.add,
            size: 33,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome back !',
                style: TextStyle(
                  fontSize: 35,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('CATEGORIES'),
                  IconButton(
                    iconSize: 27,
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        shape: kRoundedBorder,
                        context: context,
                        builder: (context) => SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: const SearchSheet(),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.search_rounded),
                  )
                ],
              ),
              const SizedBox(
                height: 130,
                child: CategoryList(),
              ),
              spacing(),
              const Text(
                'TODAY\'S TASKS',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              spacing(),
              const Expanded(
                child: TaskList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  spacing({double height = 20}) {
    return SizedBox(
      height: height,
    );
  }
}
