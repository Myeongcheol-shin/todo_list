import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/models/Todo.dart';
import 'package:todo_list/screen/custom_checkbox.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/sql/db.dart';
import 'package:todo_list/sql/todo_db.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? selectedType = "";
  final textController = TextEditingController();

  Future<List<TODO>> todayList = Future.value([]);
  Future<List<TODO>> nextDateList = Future.value([]);
  Future<List<TODO>> allClearList = Future.value([]);
  Future<List<TODO>> allTodoList = Future.value([]);

  @override
  void initState() {
    super.initState();
    todayList = DatabaseHelper.instance.getToday();
    nextDateList = DatabaseHelper.instance.getNextDay();
    allTodoList = DatabaseHelper.instance.getAllTodo();
    allClearList = DatabaseHelper.instance.getAllClearTodo();
  }

  Color getColor(String type) {
    switch (type) {
      case 'Work':
        return const Color.fromARGB(255, 255, 141, 141);
      case 'Study':
        return const Color.fromARGB(255, 209, 250, 121);
      case 'Personal':
        return const Color.fromARGB(255, 252, 226, 153);
      case 'Meeting':
        return const Color.fromARGB(255, 255, 222, 198);
      case 'Assignment':
        return const Color.fromARGB(255, 172, 196, 255);
    }
    return const Color.fromARGB(255, 172, 196, 255);
  }

  DateTime? nowDateTime = DateTime.now();
  List<Todo> typeList = [
    Todo(
      TypeName: "Work",
      isSelected: false,
      backgroundColor: const Color.fromARGB(255, 255, 141, 141),
    ),
    Todo(
      TypeName: "Study",
      isSelected: false,
      backgroundColor: const Color.fromARGB(255, 209, 250, 121),
    ),
    Todo(
      TypeName: "Personal",
      isSelected: false,
      backgroundColor: const Color.fromARGB(255, 252, 226, 153),
    ),
    Todo(
      TypeName: "Meeting",
      isSelected: false,
      backgroundColor: const Color.fromARGB(255, 255, 222, 198),
    ),
    Todo(
      TypeName: "Assignment",
      isSelected: false,
      backgroundColor: const Color.fromARGB(255, 172, 196, 255),
    ),
  ];

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  dbChange() {}
  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = <Widget>[
      Expanded(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "today",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                FutureBuilder(
                  future: todayList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final tl = snapshot.data!;
                      if (tl.isEmpty) {
                        return Container(
                            padding: const EdgeInsets.only(top: 5),
                            child: const Text(
                              "Today, There's No Schedule \u{1F601}",
                              style: TextStyle(fontSize: 18),
                            ));
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.only(top: 15),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: tl.length,
                        itemBuilder: (context, index) {
                          final item = tl[index];
                          return sliderWidget(getColor(item.type), item);
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 8,
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "tomorrow",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                FutureBuilder(
                  future: nextDateList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final tl = snapshot.data!;
                      if (tl.isEmpty) {
                        return Container(
                            padding: const EdgeInsets.only(top: 5),
                            child: const Text(
                              "Tomorrow, There's No Schedule \u{1F606}",
                              style: TextStyle(fontSize: 18),
                            ));
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.only(top: 15),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: tl.length,
                        itemBuilder: (context, index) {
                          final item = tl[index];
                          return sliderWidget(getColor(item.type), item);
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 8,
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      Expanded(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "All finished Task",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                FutureBuilder(
                  future: allClearList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final tl = snapshot.data!;
                      if (tl.isEmpty) {
                        return Container(
                            padding: const EdgeInsets.only(top: 5),
                            child: const Text(
                              "There's No finished Schedule \u{1F601}",
                              style: TextStyle(fontSize: 18),
                            ));
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.only(top: 15),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: tl.length,
                        itemBuilder: (context, index) {
                          final item = tl[index];
                          return sliderWidget(getColor(item.type), item);
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 8,
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "All Unfinished Task",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                FutureBuilder(
                  future: allTodoList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final tl = snapshot.data!;
                      if (tl.isEmpty) {
                        return Container(
                            padding: const EdgeInsets.only(top: 5),
                            child: const Text(
                              "There's No unfinished Schedule \u{1F606}",
                              style: TextStyle(fontSize: 18),
                            ));
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.only(top: 15),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: tl.length,
                        itemBuilder: (context, index) {
                          final item = tl[index];
                          return sliderWidget(getColor(item.type), item);
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 8,
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ];
    return MaterialApp(home: Builder(builder: (BuildContext context) {
      return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'List',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: const Color.fromARGB(255, 255, 141, 141),
            onTap: _onItemTapped,
          ),
          floatingActionButton: SizedBox(
            width: 70,
            height: 70,
            child: FloatingActionButton(
              onPressed: () {
                showTodoModalBottomSheet(context);
              },
              backgroundColor: Colors.pink[100],
              child: const Icon(
                Icons.add_rounded,
                size: 50,
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: Column(
            children: [
              Stack(
                children: <Widget>[
                  SizedBox(
                      width: double.infinity,
                      height: 180,
                      child: CustomPaint(
                        painter: WavePainter(),
                      )),
                  const Positioned(
                    left: 15,
                    bottom: 80,
                    child: Text(
                      "TO-DO LIST",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
              widgetOptions.elementAt(_selectedIndex)
            ],
          ));
    }));
  }

  void showTodoModalBottomSheet(BuildContext context) {
    setState(() {
      selectedType = "";
      textController.text = "";
      nowDateTime = null;
      for (var element in typeList) {
        element.isSelected = false;
      }
    });
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            width: double.infinity,
            color: Colors.black,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            height: Platform.isMacOS
                ? MediaQuery.of(context).size.height * 0.6
                : MediaQuery.of(context).size.height * 0.45,
            child: Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 45,
                    width: double.maxFinite,
                  ),
                  const Center(
                    child: Text("Add New Task",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        )),
                  ),
                  TextField(
                    decoration: const InputDecoration(
                        hintText: 'Input New Task!',
                        hintStyle: TextStyle(fontSize: 14)),
                    style: const TextStyle(fontSize: 18),
                    controller: textController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final item = typeList[index];
                        return CustomTypeCheckbox(
                            isChecked: item.isSelected,
                            onTap: () {
                              setState(() {
                                for (var element in typeList) {
                                  element.isSelected = false;
                                }
                                item.isSelected = !item.isSelected;
                                selectedType = item.TypeName;
                              });
                            },
                            backgroundColor: item.backgroundColor,
                            typeName: item.TypeName);
                      },
                      itemCount: typeList.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          width: 5,
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () async {
                      DateTime? dateTime =
                          await showOmniDateTimePicker(context: context);
                      setState(() {
                        nowDateTime = dateTime;
                      });
                    },
                    child: const Row(
                      children: [
                        Text("Choose Date",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            )),
                        Icon(
                          Icons.arrow_drop_down_sharp,
                          size: 30,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                        nowDateTime != null
                            ? DateFormat.yMMMd('en_US')
                                .add_jm()
                                .format(nowDateTime!)
                            : "",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        )),
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  TextButton(
                      onPressed: () {
                        if (textController.text != "" &&
                            nowDateTime != null &&
                            selectedType != null) {
                          DatabaseHelper.instance.add(TODO(
                              isCompleted: 0,
                              contents: textController.text,
                              day: nowDateTime!.day,
                              month: nowDateTime!.month,
                              timeMill: nowDateTime!.millisecondsSinceEpoch,
                              type: selectedType!,
                              random: DateTime.now().millisecondsSinceEpoch,
                              year: nowDateTime!.year));
                          setState(() {
                            todayList = DatabaseHelper.instance.getToday();
                            nextDateList = DatabaseHelper.instance.getNextDay();
                            allTodoList = DatabaseHelper.instance.getAllTodo();
                            allClearList =
                                DatabaseHelper.instance.getAllClearTodo();
                          });
                          Navigator.of(context).pop();
                        } else if (textController.text == "") {
                          Fluttertoast.showToast(
                              msg: "Task cannot be blank",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red[400],
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else if (nowDateTime == null) {
                          Fluttertoast.showToast(
                              msg: "Date cannot be blank",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red[400],
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please select type",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red[400],
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        margin: const EdgeInsets.only(bottom: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(colors: [
                              Colors.blue[200]!,
                              Colors.green[200]!,
                            ])),
                        child: const Text(
                          "Add Task",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w600),
                        ),
                      ))
                ],
              ),

              floatingActionButton: Container(
                width: 70,
                height: 70,
                transform: Matrix4.translationValues(0.0, -30, 0.0),
                child: FloatingActionButton(
                  backgroundColor: Colors.pink[100],
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close_rounded,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              // dock it to the center top (from which it is translated)
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerTop,
            ),
          );
        });
  }

  Slidable sliderWidget(Color color, TODO todo) {
    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          MaterialButton(
            onPressed: () {
              DatabaseHelper.instance.remove(todo);
              setState(() {
                todayList = DatabaseHelper.instance.getToday();
                nextDateList = DatabaseHelper.instance.getNextDay();
                allTodoList = DatabaseHelper.instance.getAllTodo();
                allClearList = DatabaseHelper.instance.getAllClearTodo();
              });
            },
            color: Colors.red[200],
            textColor: Colors.white,
            padding: const EdgeInsets.all(8),
            shape: const CircleBorder(),
            child: const Icon(
              Icons.delete,
              size: 35,
            ),
          ),
          MaterialButton(
            onPressed: () {
              DatabaseHelper.instance
                  .updateComplete(todo.random, todo.isCompleted == 1 ? 0 : 1);
              setState(() {
                todayList = DatabaseHelper.instance.getToday();
                nextDateList = DatabaseHelper.instance.getNextDay();
                allTodoList = DatabaseHelper.instance.getAllTodo();
                allClearList = DatabaseHelper.instance.getAllClearTodo();
              });
            },
            color: Colors.blue[300],
            textColor: Colors.white,
            padding: const EdgeInsets.all(8),
            shape: const CircleBorder(),
            child: Icon(
              todo.isCompleted == 0 ? Icons.check : Icons.redo_outlined,
              size: 35,
            ),
          ),
        ],
      ),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color,
          ),
          child: ListTile(
            title: Text(todo.contents,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18)),
          )),
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    /// Paints the whole canvas white
    canvas.drawPaint(Paint()..color = Colors.white);

    /// Translate method shifts the coordinate of the canvas, in this case we are shifting
    /// the point of origin to the top-center of  the canvas
    canvas.translate(size.width / 2, 0);

    final width = size.width / 2;

    Path bezierPath = Path()
      ..moveTo(-width, size.height)
      ..lineTo(-width, (size.height) * 0.2)
      ..cubicTo(
        -width * 0.4,
        (size.height - 150) * 0.4,
        0.3,
        (size.height) * 0.7,
        width,
        (size.height - 180) * 0.8,
      )
      ..lineTo(width, size.height);

    final bezierPaint = Paint()
      ..shader = LinearGradient(colors: [
        Colors.blue[200]!,
        Colors.green[200]!,
      ]).createShader(Offset(-width, size.height) & size);

    // y axis mirror
    canvas.scale(1, -1);
    canvas.translate(0, -size.height);

    canvas.drawPath(bezierPath, bezierPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
