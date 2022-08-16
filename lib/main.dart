import 'package:donev2/bloc/todo_bloc.dart';
import 'package:donev2/route/route_generator.dart';
import 'package:donev2/screens/home_screen.dart';
import 'package:donev2/theme_data/theme.dart';
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
        theme: MyTheme().themeData,
        debugShowCheckedModeBanner: false,
        initialRoute: HomeScreen.tag,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
