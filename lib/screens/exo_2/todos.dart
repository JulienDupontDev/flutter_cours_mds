import 'package:flutter/material.dart';
import 'package:flutter_cours/models/category.dart';
import 'package:flutter_cours/models/todo.dart';
import 'package:flutter_cours/screens/exo_2/widgets/add_todo.dart';
import 'package:flutter_cours/screens/exo_2/widgets/categories_cards.dart';
import 'package:flutter_cours/screens/exo_2/widgets/todo_list.dart';
import 'package:intl/intl.dart';

class Todos extends StatefulWidget {
  Todos({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _Todos createState() => _Todos();
}

//0 not done, 1 done
List<Todo> todos = [
  Todo(1, "todo 1", Category("wedding", "test", Icons.web), false,
      DateTime.parse("2021-06-20 10:00:00.000")),
  Todo(2, "todo 2", Category("wedding", "test", Icons.web), true,
      DateTime.parse("2021-06-20 09:00:00.000")),
];

class _Todos extends State<Todos> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Todo> _todosToDisplay = [];
  List<Todo> _todos = [];
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
    _todosToDisplay = [];
    _todos = todos;
    _getTodosToDislay(0);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Theme(
        data: ThemeData(accentColor: Colors.blue),
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => {
                addTodoDialog(
                    context: context, addTodo: _addTodo, lastId: _todos.last.id)
              },
              child: Icon(
                Icons.add,
                size: 50,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            resizeToAvoidBottomInset: false,
            body: Column(children: [
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 250.0,
                      child: Stack(
                        fit: StackFit.loose,
                        clipBehavior: Clip.none,
                        children: <Widget>[
                          Container(
                            padding:
                                EdgeInsets.only(top: 60, left: 20, right: 20),
                            color: Colors.blue,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Lets' plan",
                                      style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    CircleAvatar(
                                      child: Image.network(
                                        "https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425_960_720.png",
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              left: 20.0,
                              right: 0.0,
                              bottom: 80.0,
                              child: Text("My schedule",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white))),
                          Positioned(
                            left: 15.0,
                            right: 0.0,
                            bottom: -30.0,
                            child: Container(
                                height: 90.0,
                                width: 100,
                                color: Colors.transparent,
                                child: CategoriesCardsWidget(
                                  todos: _todos,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Expanded(child: Column(),)
                ],
              ),
              Row(children: [
                Expanded(
                    child: SizedBox(
                        height: 500.0,
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(top: 50),
                              child: TabBar(
                                controller: _tabController,
                                indicatorColor: Colors.blue,
                                labelColor: Colors.blue,
                                labelPadding: EdgeInsets.all(0),
                                onTap: (context) => {
                                  _getTodosToDislay(context),
                                },
                                tabs: [
                                  Tab(
                                    text: "Today",
                                  ),
                                  Tab(
                                    text: "Week",
                                  ),
                                  Tab(
                                    text: "Month",
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                                height: 300,
                                child: TodoListWidget(
                                    todos: _todosToDisplay,
                                    updateTodo: updateTodo,
                                    deleteTodo: deleteTodo))
                          ],
                        ))),
              ])
            ])));
  }

  void updateTodo(Todo todo) {
    setState(() {
      int foundTodo = _todos.indexWhere((todoB) => todoB.id == todo.id);
      List<Todo> newList = _todos;
      newList[foundTodo] = todo;
      setState(() {
        _todos = newList;
      });
      _getTodosToDislay(_tabController.index);
    });
  }

  void deleteTodo(int id) {
    setState(() {
      _todos.removeWhere((todo) => todo.id == id);
      _getTodosToDislay(_tabController.index);
    });
  }

  void _addTodo(Todo todo) {
    setState(() {
      _todos = [..._todos, todo];
    });
    _getTodosToDislay(_tabController.index);
  }

  void _getTodosToDislay(currentTab) {
    List<Todo> todosA = [];
    DateTime today = DateTime.now();
    _todos.forEach((todo) {
      bool add = false;
      switch (currentTab) {
        case 0:
          {
            if (isSameDay(todo.due_date, today)) add = true;
          }
          break;
        case 1:
          {
            if (isSameWeek(todo.due_date, today)) add = true;
          }
          break;
        case 2:
          {
            if (isSameMonth(todo.due_date, today)) add = true;
          }
          break;
      }
      if (!add) return;
      todosA.add(todo);
    });
    todosA.sort((a, b) => a.due_date.compareTo(b.due_date));
    setState(() {
      _todosToDisplay = todosA;
    });
  }
}

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

bool isSameWeek(DateTime date1, DateTime date2) {
  return date1.year == date2.year && weekNumber(date1) == weekNumber(date2);
}

int numOfWeeks(int year) {
  DateTime dec28 = DateTime(year, 12, 28);
  int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
  return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
}

int weekNumber(DateTime date) {
  int dayOfYear = int.parse(DateFormat("D").format(date));
  int woy = ((dayOfYear - date.weekday + 10) / 7).floor();
  if (woy < 1) {
    woy = numOfWeeks(date.year - 1);
  } else if (woy > numOfWeeks(date.year)) {
    woy = 1;
  }
  return woy;
}

bool isSameMonth(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month;
}
