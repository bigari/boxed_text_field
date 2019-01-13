# Boxed Text Field

A temporary workaround for the issue encountered when using textAlign Center or Right with Flutter Text Field. The idea is to put the TextField inside a sized Box and tune the content Padding according to the Text actual width. It can thus simulates a center/right effect inside the box.

## Usage

This demo showcases how this package can be used:

```dart
import 'package:flutter/material.dart';
import 'package:boxed_text_field/boxed_text_field.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Boxed Text Field',
      home: new HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Container(
        padding: EdgeInsets.all(28.0),
        child: BoxedTextField (
            hintText: "Name",
            textStyle: TextStyle(fontSize:16.0), //mandatory
            alignRight: true, // default false => center instead
        ),
    ));
  }
}
```
