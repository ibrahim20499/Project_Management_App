import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:graduationproject/Task.dart';
import 'package:graduationproject/Task_dao.dart';
import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
import 'Task.dart';

import 'database.dart';
import 'done.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  TaskDao taskDao;
  MyApp();
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',


      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder <TaskDatabase>(
          future : $FloorTaskDatabase.databaseBuilder('tasklist.db').build(),
          builder: (context , data){
            if(data.hasData) {
              return MyHomePage(data.data.taskDao, title: "Taskes List",);
            }
            else if(data.hasError) {
              return Text('Error');
            }
            else
              return Text('Loading');
            }
      ),

    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(TaskDao taskDao, {Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage > {

  // List<Tasklist> tasklist = new List<Tasklist>();
  List<Task> filteredTasks = new List<Task>();
  List<Task> allTasks = new List<Task>();

  //List<Tasklist> filtertasklist = new List<Tasklist>();
  List<ListItem> _dropdownItems = [
    ListItem(1, "all"),
    ListItem(2, "todo"),
    ListItem(3, "doing"),
    ListItem(4, "done")
  ];
  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  ListItem _itemSelected;
  // List<Task> tasks = new List<Task>();
  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _itemSelected = _dropdownMenuItems[0].value;
    WidgetsBinding.instance
        .addPostFrameCallback((_)async {
      await refreshDatebase();
    }
    );
  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = List();
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }
   TaskDao taskDao;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body:
      Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  width: 400,
                  decoration: BoxDecoration(
                      color: Colors.cyanAccent,

                      border: Border.all()),
                  child: DropdownButtonHideUnderline(

                    child: DropdownButton(
                        hint: new Text("Select Status"),
                        value: _itemSelected,
                        items: _dropdownMenuItems,
                        onChanged: (value) {
                          setState(() {
                            _itemSelected = value;
                            filterTasks();
                          });
                        }),
                  ),
                ),
              ),

                ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: filteredTasks.length,
                itemBuilder: (context,index) {
                  final item = filteredTasks[index];
                  return ListTile(
                      title: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: Container(
                            //height: 100,
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black,
                                width: 2,),
                              borderRadius: BorderRadius.circular(8),),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Title : ${item.taskTitle}'),
                                Text('Description : ${item.taskDescription}'),
                                Text('Status : ${item.taskStatus}'),
                              ],
                            )
                        ),
                        actions: <Widget>[
                          IconSlideAction(
                            caption: 'Edit',
                            color: Colors.red,
                            icon: Icons.edit,
                            onTap: () {
                              navigateToPage(item, context);
                            }
                          ),
                        ],
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {
                              showAlertDialog(context, () {
                                taskDao.deleteNote(item);
                                setState(() {
                                  filteredTasks.remove(item);
                                  allTasks.remove(item);
                                });

                                Navigator.of(context).pop();
                              });

                            }
                                ),
                        ],
                      ));
                  }
             )
                  ],
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToPage(new Task(1,"","",""), context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void filterTasks() {
    if (_itemSelected.name == "all") {
      filteredTasks.clear();
      filteredTasks.addAll(allTasks);
    } else {
      filteredTasks = allTasks
          .where((u) =>
      (u.taskStatus
          .contains(_itemSelected.name)))
          .toList();
      print('');
    }
  }
  void navigateToPage(Task task,BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<Task>(builder: (context) => done(task: task)),
    ).then((value) async  {
      setState(() async {
        // if(value!=null)
        // todolist.add(value);
        await refreshDatebase();
      });

    });
  }
  var database;

  Future refreshDatebase() async {
    database = await $FloorTaskDatabase
        .databaseBuilder('tasklist.db')
        .build();
    taskDao = database.taskDao;
    List<Task> theTasks = await taskDao.getAllTask();
    allTasks.clear();
    setState(() {
      allTasks.addAll(theTasks);
      if (allTasks == null)
        allTasks = new List<Task>();
      filterTasks();
    });


  }
  showAlertDialog(BuildContext context,VoidCallback deleteCallback) {

    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: deleteCallback,
    );
    Widget cancel = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("Are you sure you want to delete this task"),
      actions: [
        okButton,cancel
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
class ListItem {
  int value;
  String name;
  ListItem(this.value, this.name);
}
class Tasklist {
  String name;
  String Status;
  Tasklist(this.name, this.Status);
}
