import 'package:flutter/material.dart';

class Exo1 extends StatefulWidget {
  Exo1({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _Exo1State createState() => _Exo1State();
}

class _Exo1State extends State<Exo1> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the Exo1 object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        centerTitle: true,
        toolbarHeight: 80,
      ),
      body: Column(
        // Column is also a layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        //
        // Invoke "debug painting" (press "p" in the console, choose the
        // "Toggle Debug Paint" action from the Flutter Inspector in Android
        // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
        // to see the wireframe for each widget.
        //
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Image.network(
                  "https://images.photowall.com/products/60869/azores-mountain-landscape-1.jpg?h=699&q=85")),
          Expanded(
              flex: 2,
              child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Oeschen lake efbhzefbhzbfh",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text("ajfnajf, ajzfniahzfb")
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.red),
                              Text("42")
                            ],
                          ),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    splashRadius: 50,
                                    onPressed: () => {
                                      // AlertDialog(title: "Hello",)
                                    },
                                    icon: Icon(
                                      Icons.phone,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  Text("Call",
                                      style: TextStyle(color: Colors.orange))
                                ],
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    splashRadius: 50,
                                    onPressed: () => {},
                                    icon: Icon(
                                      Icons.near_me,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  Text("Route",
                                      style: TextStyle(color: Colors.orange))
                                ],
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    splashRadius: 50,
                                    onPressed: () => {},
                                    icon: Icon(
                                      Icons.phone,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  Text("Call",
                                      style: TextStyle(color: Colors.orange))
                                ],
                              ),
                            ],
                          )),
                      Container(
                        height: 30.0,
                      ),
                      Text(
                        ".oirnLaborum sint irure mollit nostrud cupidatat laboris dolor aliquip id. Ullamco mollit ad labore nostrud qui laboris aliquip adipisicing pariatur do fugiat labore et culpa. Ut amet minim sunt culpa sit eu. Ea quis consequat exercitation enim. Irure laborum magna deserunt culpa non duis qui adipisicing minim minim. Sunt Lorem minim voluptate enim ad do officia esse incididunt anim adipisicing minim velit tempor.zgnjzbeg zejfnzjhbfhzfb  ezj fjzbnfjzefn ezjfnzejfnze jnzfkjzfn kzjefn",
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ))),
        ],
      ),
    );
  }
}
