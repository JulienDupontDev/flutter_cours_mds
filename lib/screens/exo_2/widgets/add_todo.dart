import 'package:flutter/material.dart';
import 'package:flutter_cours/models/category.dart';
import 'package:flutter_cours/models/todo.dart';
import 'package:flutter_cours/screens/exo_2/todos.dart';
import 'package:intl/intl.dart';

Future<void> addTodoDialog(
    {context, required Function addTodo, required int lastId}) async {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();

  return await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      DateTime _selectedDate = DateTime.now();
      TimeOfDay? _selectedTime = TimeOfDay(hour: 12, minute: 00);
      String? category;
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

        return AlertDialog(
          title: const Text('Add a new TODO'),
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
                    value: category,
                    onChanged: (String? newValue) {
                      setState(() {
                        category = newValue;
                      });
                    },
                    items: [
                      Category("wedding", "test", Icons.web),
                      Category("efdzaed", "test", Icons.web),
                      Category("test", "test", Icons.web)
                    ].map((Category category) {
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
                    "Due date : ${DateFormat("dd-MM-yyyy hh:mm").format(_selectedDate)}"),
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
              child: const Text('Add'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (category == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please select a category")));
                    return;
                  }
                  addTodo(Todo(
                      lastId + 1,
                      _titleController.text,
                      getCategories().firstWhere(
                          (categoryA) => categoryA.title == category),
                      false,
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
    print(selectedDate);

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
