import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/Task.dart';
import 'package:graduationproject/Task_dao.dart';
import 'package:flutter/foundation.dart';
//import 'package:get/get.dart';
class done extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<done> {
  List<ListItem> _dropdownItems = [
    ListItem(1, "todo"),
    ListItem(2, "doing"),
    ListItem(3, "done"),
  ];

  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  ListItem _itemSelected;

  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
    _itemSelected = _dropdownMenuItems[1].value;
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
TextEditingController TaskTitle = TextEditingController();
  TextEditingController TaskDescription = TextEditingController();
  TextEditingController   TaskStatus = TextEditingController();
  //TextEditingController TaskStatus  =TextEditingController();
  @override
  Widget build(BuildContext context) {
    TaskDao taskDao ;
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
              onPressed: (){
              taskDao.addTask(Task(TaskTitle.text, TaskTitle.text ,TaskStatus.text));
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

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}  