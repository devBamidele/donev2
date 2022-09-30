import 'package:donev2/reusables/category_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc/todo_bloc.dart';
import 'extras/loading.dart';
import 'extras/none_available.dart';

/// Displays the tasks within categories as a list
class CategoryList extends StatelessWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoBloc>(
      builder: (_, data, Widget? child) {
        return StreamBuilder(
          stream: data.categories, // Supply a stream
          builder: (
            BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot,
          ) {
            if (!snapshot.hasData) {
              data.getCategories(query: data.search);
              // At the initial stage when there is no stream
              return const Loading();
            } else {
              return snapshot
                      .data!.isNotEmpty // When the snapshots are received
                  ? ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        scrollbars: false, // Remove the scrollbar by the side
                        physics:
                            const BouncingScrollPhysics(), // Create a bouncy scroll effect
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          final item = snapshot.data![index];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 3.0),
                            child: CategoryCard(
                              id: item,
                              category: item['category'],
                              taskNo: item['COUNT(*)'],
                            ),
                          );
                        },
                      ),
                    )
                  : const NoneAvailable(
                      message: 'No categories',
                    ); // If the snapshots are empty
            }
          },
        );
      },
    );
  }
}
