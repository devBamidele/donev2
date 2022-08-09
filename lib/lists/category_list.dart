import 'package:donev2/reusables/category_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc/todo_bloc.dart';
import 'extras/loading_data.dart';
import 'extras/none_available.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoBloc>(
      builder: (_, data, Widget? child) {
        return StreamBuilder(
          stream: data.categories,
          builder: (
            BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot,
          ) {
            if (!snapshot.hasData) {
              // At the initial stage when there is no stream
              data.getCategories();
              return const LoadingData();
            } else {
              return snapshot
                      .data!.isNotEmpty // When the snapshots are received
                  ? ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context)
                          .copyWith(scrollbars: false),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          final item = snapshot.data![index];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CategoryCard(
                              category: item['category'],
                              taskNo: item['COUNT(*)'],
                              percent: 0.5,
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
