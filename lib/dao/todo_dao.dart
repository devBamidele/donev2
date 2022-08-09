import 'dart:async';
import 'package:donev2/database/database.dart';
import 'package:donev2/model/todo.dart';

class TodoDao {
  final dbProvider = DatabaseProvider.dbProvider;

  //Adds new T0do records
  Future<int> createTodo(Todo todo) async {
    final db = await dbProvider.database;
    return db!.insert(
      todoTABLE,
      todo.toDatabaseJson(),
    );
  }

  //Get All T0do items and search if query string was passed
  Future<List<Todo>?> getTodos(
      {required List<String> columns, String? query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>>? result;
    if (query != null && query.isNotEmpty) {
      result = await db?.query(
        todoTABLE,
        columns: columns,
        where: 'task LIKE ?',
        whereArgs: ["%$query%"],
      );
    } else {
      result = await db?.query(todoTABLE, columns: columns);
    }

    List<Todo>? todos = result?.isNotEmpty == true
        ? result?.map((item) => Todo.fromDatabaseJson(item)).toList()
        : [];
    return todos;
  }

  Future<List<Map<String, dynamic>>> getCategories({String? query}) async {
    final db = await dbProvider.database;

    final text = query != null && query.isNotEmpty
        ? 'WHERE $columnCategory like \'%$query%\''
        : '';
    Future<List<Map<String, dynamic>>> result;

    result = db!.rawQuery(
      'select $columnCategory, COUNT(*) FROM $todoTABLE $text GROUP BY $columnCategory ORDER BY COUNT(*) DESC',
    );

    return result;
  }

  //Update T0do record
  Future<int?> updateTodo(Todo todo) async {
    final db = await dbProvider.database;

    var result = await db?.update(
      todoTABLE,
      todo.toDatabaseJson(),
      where: "id = ?",
      whereArgs: [todo.id],
    );

    return result;
  }

  //Delete T0do records
  Future<int?> deleteTodo(int id) async {
    final db = await dbProvider.database;
    var result = await db?.delete(
      todoTABLE,
      where: 'id = ?',
      whereArgs: [id],
    );

    return result;
  }

  //This will be useful when I want to delete all the rows in the database
  Future deleteAllTodos() async {
    final db = await dbProvider.database;
    var result = await db?.delete(
      todoTABLE,
    );

    return result;
  }
}
