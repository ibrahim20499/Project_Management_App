import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart';
import 'Task_dao.dart';
import 'Task.dart';
part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Task])
abstract class TaskDatabase extends FloorDatabase {
  TaskDao get taskDao;
}