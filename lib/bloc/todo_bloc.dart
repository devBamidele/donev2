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
  final _categoryController =
      StreamController<List<Map<String, dynamic>>>.broadcast();

  final _groupController = StreamController<List<Todo>?>.broadcast();

  get todos => _todoController.stream;
  get categories => _categoryController.stream;
  get group => _groupController.stream;

  TodoBloc() {
    getTodos();
    getCategories();
  }
  DateTime? time;
  String? selected;

  getTodos({String? query}) async {
    // (Sink) is a way of adding data reactively to the stream
    _todoController.sink.add(
      await _todoDao.getTodos(query: query, columns: []),
    );
  }

  getCategories({String? query}) async {
    _categoryController.sink.add(
      await _todoDao.getCategories(query: query),
    );
  }

  getGroup({required String category}) async {
    _groupController.sink.add(
      await _todoDao.fetchGroup(category),
    );
    notifyListeners();
  }

  addTodo(Todo todo) async {
    await _todoDao.createTodo(todo);
    getTodos();
    getCategories();
  }

  updateTodo(Todo todo) async {
    await _todoDao.updateTodo(todo);
    getTodos();
    getCategories();
    notifyListeners();
  }

  deleteTodoById(int id) async {
    _todoDao.deleteTodo(id);
    getTodos();
    getCategories();
  }

  @override
  dispose() {
    super.dispose();
    _todoController.close();
    _categoryController.close();
  }
}
