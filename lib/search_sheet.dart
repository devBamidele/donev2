import 'package:donev2/bloc/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The sheet that comes in display when the search button is clicked
class SearchSheet extends StatelessWidget {
  const SearchSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();

    return Consumer<TodoBloc>(
      builder: (_, data, Widget? child) {
        return SizedBox(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: searchController,
                          textInputAction: TextInputAction.newline,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                          ),
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: 'Search for todo...',
                            labelText: 'Search *',
                            labelStyle: TextStyle(
                              color: Colors.indigoAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              // The validator isn't working for some reason
                              return 'Please enter some text';
                            }
                            return null;
                            // return value!.contains('@')
                            //     ? 'Do not use the @ char.'
                            //     : null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, top: 1),
                        child: CircleAvatar(
                          backgroundColor: Colors.indigoAccent,
                          radius: 18,
                          child: IconButton(
                            icon: const Icon(
                              Icons.search_rounded,
                              size: 22,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              /*This will get all todos that contains similar string in the textform */
                              data.getTodos(query: searchController.value.text);
                              //dismisses the bottomsheet
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
