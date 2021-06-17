import 'package:flutter/material.dart';
import 'package:flutter_cours/models/category.dart';
import 'package:flutter_cours/models/todo.dart';
import 'package:flutter_cours/screens/exo_2/todos.dart';
import 'package:intl/intl.dart';

class TodoListWidget extends StatelessWidget {
  final List<Todo> todos;
  final Function(Todo) updateTodo;
  final Function(int) deleteTodo;

  TodoListWidget(
      {required this.todos,
      required this.updateTodo,
      required this.deleteTodo});

  @override
  Widget build(BuildContext context) {
    return todos.length == 0
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("No todos found for specified filter")],
          )
        : ListView(
            children: [
              ...todos.map((todo) {
                return Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                        leading: getIcon(todo),
                        onTap: () => seeTodoDialog(
                            context: context,
                            todo: todo,
                            updateTodo: updateTodo,
                            deleteTodo: deleteTodo),
                        title: Text(todo.title),
                        subtitle: Text(todo.category.title),
                        trailing: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(DateFormat("dd-MM-yyyy hh:mm")
                                .format(todo.due_date)),
                            Icon(Icons.keyboard_arrow_right)
                          ],
                        )));
              })
            ],
          );
  }
}

Icon getIcon(Todo todo) {
  DateTime today = DateTime.now();
  int difference = todo.due_date.difference(today).inDays;
  if (todo.done)
    return Icon(
      Icons.check,
      color: Colors.blue,
    );
  return Icon(Icons.circle,
      color: difference > 6
          ? Colors.green
          : difference <= 6 && difference > 1
              ? Colors.orange
              : Colors.red);
}

Future<void> seeTodoDialog({
  context,
  required Todo todo,
  required Function updateTodo,
  required Function(int) deleteTodo,
}) async {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  _titleController.text = todo.title;
  String? _category = todo.category.title;

  return await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      DateTime _selectedDate = todo.due_date;
      TimeOfDay? _selectedTime =
          TimeOfDay(hour: todo.due_date.hour, minute: todo.due_date.minute);
      bool _done = todo.done;
      return StatefulBuilder(builder: (context, setState) {
        void setTime(newTime) {
          setState(() {
            _selectedTime = newTime;
          });
        }

        void setDate(newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        }

        void setDone() {
          setState(() {
            _done = !_done;
          });
        }

        return AlertDialog(
          title: Text('Todo - ${todo.title}'),
          content: SingleChildScrollView(
              child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: "Title"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                DropdownButton(
                    hint: Text("Category"),
                    value: _category,
                    onChanged: (String? newValue) {
                      setState(() {
                        _category = newValue;
                      });
                    },
                    items: getCategories().map((Category category) {
                      return DropdownMenuItem(
                          value: category.title, child: Text(category.title));
                    }).toList()),
                Container(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () =>
                            datePicker(context, setDate, _selectedDate),
                        child: Text("Due date day")),
                    TextButton(
                        onPressed: () =>
                            timePicker(context, setTime, _selectedTime),
                        child: Text("Due date time"))
                  ],
                ),
                Text(
                    "Due date : ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} ${_selectedTime?.hour}:${_selectedTime?.minute}"),
                Row(
                  children: [
                    Text("Done ?"),
                    Checkbox(
                        value: _done,
                        onChanged: (value) {
                          setDone();
                        })
                  ],
                )
              ],
            ),
          )),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                deleteTodo(todo.id);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  updateTodo(Todo(
                      todo.id,
                      _titleController.text,
                      getCategories().firstWhere(
                          (categoryA) => categoryA.title == _category),
                      _done,
                      DateTime(
                          _selectedDate.year,
                          _selectedDate.month,
                          _selectedDate.day,
                          _selectedTime!.hour,
                          _selectedTime!.minute)));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      });
    },
  );
}

Future<Null> datePicker(context, setDate, selectedDate) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: DateTime.now(),
    lastDate: DateTime(2100),
  );
  if (selectedDate != pickedDate && pickedDate != null) {
    setDate(pickedDate);
  }
}

Future<Null> timePicker(context, setTime, _selectedTime) async {
  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: _selectedTime,
  );
  if (picked != null) {
    setTime(picked);
  }
}
