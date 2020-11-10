import 'package:floor/floor.dart';
@Entity(tableName: 'Task')
class Task {
  @PrimaryKey(autoGenerate : true)
   int id;
   String taskTitle;
   String taskDescription;
   String taskStatus;
  Task(this.id, this.taskTitle,this.taskDescription,this.taskStatus);
}