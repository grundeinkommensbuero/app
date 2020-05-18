import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/routes/Navigation.dart';
import 'package:sammel_app/services/ListLocationService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/shared/DweTheme.dart';

void main() => runApp(MyApp());

const Mode mode = Mode.DEMO;

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AbstractTermineService>.value(
              value: demoMode ? DemoTermineService() : TermineService()),
          Provider<AbstractStammdatenService>.value(
              value: demoMode ? DemoStammdatenService() : StammdatenService()),
          Provider<AbstractListLocationService>.value(
              value: demoMode
                  ? DemoListLocationService()
                  : ListLocationService()),
          Provider<StorageService>.value(value: StorageService()),
        ],
        child: MaterialApp(
          title: 'DW & Co. Enteignen',
          theme: DweTheme.themeData,
          home: Navigation(),
        ));
  }

}

enum Mode {LOCAL, DEMO, TEST}

get demoMode => mode == Mode.DEMO;
get testMode => mode == Mode.TEST;
