import 'package:donev2/model/todo.dart';
import 'package:donev2/dao/todo_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class TodoBloc extends ChangeNotifier {
  // Get instance of the Repository
  final _todoDao = TodoDao();

  // Everytime the class is instantiated, call the following
  TodoBloc() {
    getTodos();
    getCategories();
  }

  // The item the user is currently searching for
  String? search;

  // The lengths of the groups, categories, tasks and suggestions
  int? _groupLength;
  int? _categoryLength;
  int? _taskLength;
  int? _suggestionLength;

  // The Category item that has been tapped
  String selected = '';

  // Stores the next number on the Table
  int? nextNumber;

  // The username stored by shared preferences
  String? username = ' 👋';

  // Max number of characters a user can input for a name
  int maxLength = 7;

  // For the menu in the Category Screen
  int currentOption = 2;

  // Configure the stream controllers
  final _todoController = StreamController<List<Todo>?>.broadcast();
  final _categoryController =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  final _groupController = StreamController<List<Todo>?>.broadcast();
  final _suggestionsController = StreamController<List<Todo>?>.broadcast();
  final _recentController = StreamController<List<Todo>?>.broadcast();

  // The Global key for the forms
  final formKey = GlobalKey<FormState>();

  // Getters for the stream
  get todos => _todoController.stream;
  get categories => _categoryController.stream;
  get group => _groupController.stream;
  get suggestions => _suggestionsController.stream;
  get recent => _recentController.stream;

  // This holds the date that is selected by the user
  DateTime? _selectedDate = DateTime.now();

  // This holds the time that is selected by the user
  TimeOfDay? _selectedTime = TimeOfDay.now();

  // Getters
  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;

  // Setters
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

  // When the user exits search from Home
  exitSearchFromHome() {
    search = null;
    getCategories();
    getTodos();
  }

  // When the user exits search from Category
  exitSearchFromCategory() {
    getGroup(category: selected);
  }

  // Set the max length of the name text depending on the width of the screen
  setMaxChar(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int length = 9;
    if (width <= 350) {
      length = 7;
    } else if (width > 350 && width <= 400) {
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

  // Check if the a value was already pre-saved
  verifyKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('Name')) {
      getName();
    } else {
      editName();
    }
  }

  // Change the saved name
  editName({String name = '👋'}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Name', name);
  }

  getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('Name');
    notifyListeners();
  }

  // Fetch the tasks from the database
  getTodos({String? query}) async {
    List<Todo>? result = await _todoDao.getTodos(query: query, columns: []);
    _taskLength = result?.length;
    _todoController.sink.add(result);
    notifyListeners();
  }

  // Fetch search suggestions
  getSuggestions({String? query, bool showAllTasks = true}) async {
    List<Todo>? result = await _todoDao.getSuggestions(
      query: query,
      columns: [],
      showAllTasks: showAllTasks,
      category: selected,
    );
    _suggestionLength = result?.length;
    _suggestionsController.sink.add(result);
    notifyListeners();
  }

  // Get the recent searches
  getRecent() async {
    List<Todo>? result = await _todoDao.getRecent();
    _recentController.sink.add(result);
    notifyListeners();
  }

  // Get the categories
  getCategories({String? query}) async {
    List<Map<String, dynamic>> result =
        await _todoDao.getCategories(query: query);
    _categoryLength = result.length;
    _categoryController.sink.add(result);
    notifyListeners();
  }

  // Get the tasks under a category
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

  // Get the next id on the table
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

  // Dispose the controllers
  @override
  dispose() {
    super.dispose();
    _todoController.close();
    _categoryController.close();
  }
}
