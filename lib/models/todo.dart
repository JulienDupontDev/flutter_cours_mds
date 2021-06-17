import 'package:flutter_cours/models/category.dart';

class Todo {
  int id;
  String title;
  Category category;
  bool done;
  DateTime due_date;
  Todo(this.id, this.title, this.category, this.done, this.due_date);
}
