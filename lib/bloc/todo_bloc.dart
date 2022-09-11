import 'package:donev2/model/todo.dart';
import 'package:donev2/dao/todo_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final _suggestionsController = StreamController<List<Todo>?>.broadcast();
  final _recentController = StreamController<List<Todo>?>.broadcast();

  final formKey =
      GlobalKey<FormState>(); // The key for my forms on the add_screen page

  /// Getters for the stream
  get todos => _todoController.stream;
  get categories => _categoryController.stream;
  get group => _groupController.stream;
  get suggestions => _suggestionsController.stream;
  get recent => _recentController.stream;

  TodoBloc() {
    getTodos();
    getCategories();
  }

  // The item the user is currently searching for
  String? _search;

  String? get search => _search;

  set search(String? search) {
    _search = search;
    notifyListeners();
  }

  // The lengths of the groups, categories and task
  int? _groupLength;
  int? _categoryLength;
  int? _taskLength;
  int? _suggestionLength;

  // The Category item that has been tapped
  String selected = '';

  int? nextNumber;

  // The username stored by shared preferences
  String? username = ' 👋';

  // Max number of characters a user can input for a name
  int maxLength = 9;

  // For the menu in the Category Screen
  int currentOption = 2;
  String? query;

  // This holds the date that is selected by the user
  DateTime? _selectedDate = DateTime.now();

  // This holds the time that is selected by the user
  TimeOfDay? _selectedTime = TimeOfDay.now();

  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;

  set selectedDate(DateTime? selectedDate) {
    _selectedDate = selectedDate ?? _selectedDate;
    notifyListeners();
  }

  set selectedTime(TimeOfDay? selectedTime) {
    _selectedTime = selectedTime ?? _selectedTime;
    notifyListeners();
  }

  refreshDateAndTime() {
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  // Save properties on the selected task to
  // [_selectedDate] and [_selectedTime]
  onSelectedTask(Todo selected) {
    _selectedDate =
        DateTime.tryParse(selected.completion.toString()) ?? _selectedDate;
    _selectedTime = TimeOfDay.fromDateTime(
      DateTime.parse(selected.alarm ?? _selectedDate.toString()),
    );
  }

  // Getters for the lengths of the lists
  int? get groupLength => _groupLength;
  int? get categoryLength => _categoryLength;
  int? get taskLength => _taskLength;
  int? get suggestionLength => _suggestionLength;

  // If a value is not present in storage we get a null value
  //int intValue = await prefs.getInt('intValue') ?? 0;

  // When the user navigates off the search screen
  exitSearch() {
    search = null;
    getCategories();
    getTodos();
  }

  // Set the max length of the name text
  setMaxChar(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int length = 9;
    if (width <= 400) {
      length = 8;
    } else if (width > 400 && width <= 450) {
      length = 10;
    } else if (width > 450 && width <= 500) {
      length = 11;
    } else if (width > 500 && width < 600) {
      length = 12;
    } else if (width >= 600) {
      length = 14;
    }
    maxLength = length;
    notifyListeners();
  }

  verifyKey() async {
    // Obtain shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('Name')) {
      getName();
    } else {
      editName();
    }
  }

  editName({String name = '👋'}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Name', name);
  }

  getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('Name');
    notifyListeners();
  }

  // (Sink) is a way of adding data reactively to the stream
  getTodos({String? query}) async {
    List<Todo>? result = await _todoDao.getTodos(query: query, columns: []);
    _taskLength = result?.length;
    _todoController.sink.add(result);
    notifyListeners();
  }

  getSuggestions({String? query}) async {
    List<Todo>? result =
        await _todoDao.getSuggestions(query: query, columns: []);
    _suggestionLength = result?.length;
    _suggestionsController.sink.add(result);
    notifyListeners();
  }

  getRecent() async {
    List<Todo>? result = await _todoDao.getRecent();
    _recentController.sink.add(result);
    notifyListeners();
  }

  getCategories({String? query}) async {
    List<Map<String, dynamic>> result =
        await _todoDao.getCategories(query: query);
    _categoryLength = result.length;
    _categoryController.sink.add(result);
    notifyListeners();
  }

  getGroup({required String category, String? query, int selected = 2}) async {
    List<Todo>? result = await _todoDao.fetchGroup(
      category: category,
      query: query,
      selected: selected,
    );
    _groupLength = result?.length;
    _groupController.sink.add(result);
    notifyListeners();
  }

  getNext() async {
    nextNumber = await _todoDao.getNext();
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
    getGroup(category: selected, selected: currentOption);
  }

  renameCategory({required String from, required String to}) async {
    await _todoDao.renameCategory(from: from, to: to);
    getTodos();
    getCategories();
    selected = to;
    notifyListeners();
  }

  clearSearch() async {
    await _todoDao.clearHistory();
    getRecent();
  }

  deleteTodoById(int id) async {
    _todoDao.deleteTodo(id);
    getTodos();
    getCategories();
    getGroup(category: selected, selected: currentOption);
  }

  deleteCategory(String category) async {
    _todoDao.deleteCategory(category);
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
