import 'package:donev2/bloc/todo_bloc.dart';
import 'package:donev2/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoBloc>(
      create: (_) => TodoBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFD2FDFF),
        ),
        //Our only screen/page we have
        home: const HomeScreen(),
      ),
    );
  }
}
