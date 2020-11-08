import 'package:floor/floor.dart';
@Entity(tableName: 'Task')
class Task {
  @PrimaryKey(autoGenerate : true)
   int id;
   @ColumnInfo(name: 'taskTitle')
   String taskTitle;
   String taskDescription;
   String taskStatus;
  Task( this.taskTitle,this.taskDescription,this.taskStatus, {this.id});
}