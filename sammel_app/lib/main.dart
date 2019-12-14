import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/services/BenutzerService.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'routes/LoginSeite.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  var demoModus = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<StammatenService>.value(
              value: demoModus ? DemoTermineService() : StammatenService()),
          Provider<BenutzerService>.value(
              value: demoModus ? DemoBenutzerService() : BenutzerService()),
          Provider<StammdatenService>.value(
              value: demoModus ? DemoStammdatenService() : StammdatenService()),
        ],
        child: MaterialApp(
          title: 'Deutsche Wohnen Enteignen',
          theme: ThemeData(
            primarySwatch: Colors.amber,
          ),
          home: LoginSeite(title: 'Deutsche Wohnen Enteignen'),
        ));
  }
}
