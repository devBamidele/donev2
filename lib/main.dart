import 'package:donev2/bloc/todo_bloc.dart';
import 'package:donev2/constants.dart';
import 'package:donev2/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'notification/notification_service.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoBloc>(
      create: (_) => TodoBloc(),
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: kScaffoldColor,
          cardTheme: CardTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          listTileTheme: ListTileThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            horizontalTitleGap: 10,
            style: ListTileStyle.drawer,
            tileColor: kListTileColor,
          ),
        ),
        debugShowCheckedModeBanner: false,
        //Our only screen/page we have
        home: const HomeScreen(),
      ),
    );
  }
}
