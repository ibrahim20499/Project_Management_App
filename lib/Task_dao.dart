import 'package:floor/floor.dart';
import 'Task.dart';

@dao
abstract class TaskDao {
  @Query('SELECT * FROM Task')
  Future<List<Task>> getAllTask();
  @insert
  Future<void> addTask(Task task);
  @delete
  Future<void> deleteNote(Task task);
  @update
  Future<void>updateNote(Task task);
}
