import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/routes/TermineSeite.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/TermineService.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  var demoModus = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AbstractTermineService>.value(
              value: demoModus ? DemoTermineService() : TermineService()),
          Provider<AbstractStammdatenService>.value(
              value: demoModus ? DemoStammdatenService() : StammdatenService()),
        ],
        child: MaterialApp(
          title: 'Deutsche Wohnen Enteignen',
          theme: ThemeData(
            primarySwatch: Colors.amber,
          ),
          home: TermineSeite(title: 'Deutsche Wohnen Enteignen'),
        ));
  ***REMOVED***
***REMOVED***
