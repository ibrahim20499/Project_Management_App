import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/Task.dart';
import 'package:graduationproject/Task_dao.dart';
import 'package:flutter/foundation.dart';

import 'database.dart';
//import 'package:get/get.dart';
class done extends StatefulWidget {
  Task task;
  done({Key key, this.task}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<done> {
  List<String> _dropdownItems = [
    "todo",
    "doing",
     "done",
  ];

  List<DropdownMenuItem<String>> _dropdownMenuItems;
  String _itemSelected;

  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);

setState(() {
  if(widget.task.id==1)
  _itemSelected = _dropdownMenuItems[0].value;
  else
    _itemSelected =widget.task.taskStatus ;
  TaskTitle.text=widget.task.taskTitle;
  TaskDescription.text=widget.task.taskDescription;
});
  }

  List<DropdownMenuItem<String>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<String>> items = List();
    for (String listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem),
          value: listItem,
        ),
      );
    }
    return items;
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    TaskTitle.dispose();
    TaskDescription.dispose();

    super.dispose();
  }
  TaskDao taskDao ;
TextEditingController TaskTitle = TextEditingController();
  TextEditingController TaskDescription = TextEditingController();
  // TextEditingController   TaskStatus = TextEditingController();
  //TextEditingController TaskStatus  =TextEditingController();
  @override
  Widget build(BuildContext context) {

    // TaskTitle.text = task.taskTitle;
    // TaskDescription.text = task.taskDescription;
    return Scaffold(
      appBar: AppBar(
        title: Text(" Task Edit page"),
      ),
      body: Container(
        width: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(20),
              alignment: Alignment.topRight,

              child:RaisedButton(
            textColor: Colors.white,
            color: Colors.blue,
               child: Text('done'),
              onPressed: () async{
                final database = await $FloorTaskDatabase.databaseBuilder(
                    'tasklist.db').build();
                taskDao = database.taskDao;
                widget.task.taskStatus=_itemSelected;
                widget.task.taskTitle=TaskTitle.text;
                widget.task.taskDescription=TaskDescription.text;

                if (widget.task.id == 1) {
                  widget.task.id =
                      new DateTime.now().millisecondsSinceEpoch;
                  await taskDao.addTask(widget.task);
                }
                else {
                  await taskDao.updateNote(widget.task);
                }

                // var test=await noteDao.findAllNotes();
                Navigator.of(context).pop(widget.task);
            },
          )),
          Padding(
            //padding:  EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            padding: EdgeInsets.all(15),
            child: TextField(
              controller:   TaskTitle,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Title',
                hintText: 'Task Title',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),

            child: TextField(
              //obscureText: true,
              controller: TaskDescription,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Description',
                hintText: ' Task Description',
              ),
              style: TextStyle(
                            height: 2.0,
                           color: Colors.black
                       )
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  border: Border.all()),
              child: DropdownButtonHideUnderline(

                child: DropdownButton(
                    value: _itemSelected,
                    items: _dropdownMenuItems,
                    onChanged: (value) {
                      setState(() {
                        _itemSelected = value;
                      });
                    }),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

// class ListItem {
//   int value;
//   String name;
//
//   ListItem(this.value, this.name);
// }