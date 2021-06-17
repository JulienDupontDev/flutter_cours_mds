/// Flutter code sample for CustomScrollView

// By default, if items are inserted at the "top" of a scrolling container like
// [ListView] or [CustomScrollView], the top item and all of the items below it
// are scrolled downwards. In some applications, it's preferable to have the
// top of the list just grow upwards, without changing the scroll position.
// This example demonstrates how to do that with a [CustomScrollView] with
// two [SliverList] children, and the [CustomScrollView.center] set to the key
// of the bottom SliverList. The top one SliverList will grow upwards, and the
// bottom SliverList will grow downwards.

import 'package:flutter/material.dart';

/// This is the stateful widget that the main application instantiates.
class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

/// This is the private State class that goes with HomePage.
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Exercices et projets réalisées en cours"),
          toolbarHeight: 100,
        ),
        body: SingleChildScrollView(
            child: Container(
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            padding: const EdgeInsets.all(20),
            primary: false,
            children: [
              ...projects.map((project) {
                return SizedBox(
                    height: 50,
                    child: TextButton(
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.orange)),
                        onPressed: () =>
                            {Navigator.pushNamed(context, project.to)},
                        child: Text(project.title)));
              }).toList()
            ],
          ),
        )));
  }
}

var projects = [
  Project("Exercice 1", "/exo1"),
  Project("Exercice Todos", "/exo2"),
  Project("Pokemon api", "/pokemon"),
];

class Project {
  String title;
  String to;
  Project(this.title, this.to);
}
