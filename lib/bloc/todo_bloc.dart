import 'package:donev2/model/todo.dart';
import 'package:donev2/dao/todo_dao.dart';

import 'dart:async';

import 'package:flutter/material.dart';

class TodoBloc extends ChangeNotifier {
  //Get instance of the Repository
  final _todoDao = TodoDao();

  //Stream controller is the 'Admin' that manages
  //the state of our stream of data like adding
  //new data, change the state of the stream
  //and broadcast it to observers/subscribers
  final _todoController = StreamController<List<Todo>?>.broadcast();

  get todos => _todoController.stream;

  TodoBloc() {
    getTodos();
  }

  getTodos({String? query}) async {
    // (Sink) is a way of adding data reactively to the stream
    _todoController.sink.add(
      await _todoDao.getTodos(query: query, columns: []),
    );
  }

  addTodo(Todo todo) async {
    await _todoDao.createTodo(todo);
    getTodos();
  }

  updateTodo(Todo todo) async {
    await _todoDao.updateTodo(todo);
    getTodos();
  }

  deleteTodoById(int id) async {
    _todoDao.deleteTodo(id);
    getTodos();
  }

  @override
  dispose() {
    super.dispose();
    _todoController.close();
  }
}
