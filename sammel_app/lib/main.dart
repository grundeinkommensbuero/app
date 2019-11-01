import 'package:flutter/material.dart';
import 'routes/LoginSeite.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deutsche Wohnen Enteignen',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: LoginSeite(title: 'Deutsche Wohnen Enteignen'),
    );
  }
}
