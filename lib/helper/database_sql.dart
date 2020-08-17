import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseSQL {

  //Declaring the information regarding the SQLite Database
  static final _databaseName = 'UserLogInActivity.db';
  static final _databaseVersion = 1;
  static final tableName = 'user_activiy';
  static final columnID = '_id';
  static final columnName = 'logged_in';
  static final columnName1 = 'user_uid';

  /*
  Creating a private instance class thus only one object can be used
  throughout the application.
  */
  DatabaseSQL._instance();
  static final DatabaseSQL instance = DatabaseSQL._instance();
  static Database _database;

  //A getter to fetch the database
  Future<Database> get database async {
    if(_database != null) {
      return _database;
    }
    _database = await _initDatabase();
      return _database;
  }

  _initDatabase() async {

    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  //To create the database.
  Future _onCreate(Database db, int version) async {

    await db.execute(
      '''
      CREATE TABLE $tableName (
        $columnID INTEGER PRIMARY KEY,
        $columnName INTEGER NOT NULL,
        $columnName1 INTEGER NOT NULL
      )
      '''
    );
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableName, row);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
//    int id = row[columnID];
    return await db.update(tableName, row);/*, where: '$columnName1 = ?', whereArgs: [row[columnName1]]*/
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(tableName, where: '$columnID = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(tableName);
  }

}