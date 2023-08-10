import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/sql/todo_db.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'recipe.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<int> add(TODO todo) async {
    Database db = await instance.database;
    return await db.insert('Todo', todo.toMap());
  }

  Future<List<TODO>> getToday() async {
    DateTime dateTime = DateTime.now();
    Database db = await instance.database;
    var todoDb = await db.query("Todo",
        where: 'year = ? AND month = ? AND day = ? AND isCompleted = 0',
        whereArgs: [dateTime.year, dateTime.month, dateTime.day],
        orderBy: 'timeMill ASC');
    List<TODO> todoList =
        todoDb.isNotEmpty ? todoDb.map((e) => TODO.fromMap(e)).toList() : [];
    return todoList;
  }

  Future<List<TODO>> getNextDay() async {
    DateTime dateTime = DateTime.now().add(const Duration(days: 1));
    Database db = await instance.database;
    var todoDb = await db.query("Todo",
        where: 'year = ? AND month = ? AND day = ? AND isCompleted = 0',
        whereArgs: [dateTime.year, dateTime.month, dateTime.day],
        orderBy: 'timeMill ASC');
    List<TODO> todoList =
        todoDb.isNotEmpty ? todoDb.map((e) => TODO.fromMap(e)).toList() : [];
    return todoList;
  }

  Future<void> updateTodo(TODO todo) async {
    Database db = await instance.database;
    db.update('Todo', {
      'type': todo.type,
      'timeMill': todo.timeMill,
      'year': todo.year,
      'month': todo.month,
      'day': todo.day,
      'random': todo.random,
      'isCompleted': todo.isCompleted,
      'contents': todo.contents,
    });
  }

  Future<void> updateComplete(int random, int isCompleted) async {
    Database db = await instance.database;
    db.update(
        'Todo',
        {
          'isCompleted': isCompleted,
        },
        where: 'random = ?',
        whereArgs: [random]);
  }

  Future<List<TODO>> getAllTodo() async {
    Database db = await instance.database;
    var todoDb = await db.query("Todo",
        where: 'isCompleted = 0', orderBy: 'timeMill ASC');
    List<TODO> todoList =
        todoDb.isNotEmpty ? todoDb.map((e) => TODO.fromMap(e)).toList() : [];
    return todoList;
  }

  Future<List<TODO>> getAllClearTodo() async {
    Database db = await instance.database;
    var todoDb = await db.query("Todo",
        where: 'isCompleted = 1', orderBy: 'timeMill ASC');
    List<TODO> todoList =
        todoDb.isNotEmpty ? todoDb.map((e) => TODO.fromMap(e)).toList() : [];
    return todoList;
  }

  Future<int> remove(TODO todo) async {
    Database db = await instance.database;
    return await db.delete('Todo', where: 'id = ?', whereArgs: [todo.id]);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE Todo(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type TEXT NOT NULL,
      timeMill INTEGER NOT NULL,
      year INTEGER NOT NULL,
      month INTEGER NOT NULL,
      day INTEGER NOT NULL,
      random INTEGER NOT NULL,
      isCompleted INTEGER NOT NULL,
      contents TEXT NOT NULL)
    ''');
  }
}
