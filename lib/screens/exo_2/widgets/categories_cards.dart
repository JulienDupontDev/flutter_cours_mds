import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cours/models/category.dart';
import 'package:flutter_cours/models/todo.dart';
import 'package:flutter_cours/screens/exo_2/todos.dart';

class CategoriesCardsWidget extends StatelessWidget {
  final List<Todo> todos;

  CategoriesCardsWidget({required this.todos});

  @override
  Widget build(BuildContext context) {
    return ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          ...getCategories().map((category) {
            int count = 0;
            todos.forEach((todo) {
              if (todo.category.title != category.title) return;
              count++;
            });
            return Card(
                elevation: 6,
                child: Container(
                    padding: EdgeInsets.all(10),
                    width: 140.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(category.icon),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "$count items",
                              style: TextStyle(),
                            ),
                          ],
                        )
                      ],
                    )),
                color: Colors.white);
          })
        ]);
  }
}
