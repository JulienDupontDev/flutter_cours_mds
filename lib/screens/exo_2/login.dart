import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  Login({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  final _formKey = GlobalKey<FormState>();

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
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              leading: IconButton(
                icon: Text("Menu"),
                onPressed: () => Navigator.pushNamed(context, "/"),
              ),
              // Here we take the value from the Login object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sign in",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  Text(
                    "Do id nisi duis dolore laboris et quis mollit ut pariatur velit.",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  )
                ],
              ),
              centerTitle: true,
              toolbarHeight: 200,
            ),
            bottomNavigationBar: Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Don't have an account ?"),
                    TextButton(onPressed: () => {}, child: Text("Sign Up"))
                  ],
                )),
            body: Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              initialValue: "admin",
                              decoration: InputDecoration(
                                hintText: "Login",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your login';
                                }
                                if (value != "admin") return 'Login incorrect';
                                return null;
                              },
                            ),
                            TextFormField(
                              obscureText: true,
                              autocorrect: false,
                              initialValue: "admin",
                              decoration: InputDecoration(hintText: "Password"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value != "admin")
                                  return 'Password incorrect';
                                return null;
                              },
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.lock_outline,
                                  size: 15,
                                  color: Colors.grey[800],
                                ),
                                Container(
                                  height: 50,
                                ),
                                Text(
                                  "We believe in privacy",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.grey[600]),
                                )
                              ],
                            ),
                            ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)))),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text("Login successful")));
                                    Navigator.pushNamed(context, "/exo2/todos");
                                  }
                                },
                                child: Text(
                                  "Sign in",
                                  style: TextStyle(color: Colors.white),
                                ))
                          ],
                        ),
                      ),
                    )),
              ],
            ))));
  }
}
