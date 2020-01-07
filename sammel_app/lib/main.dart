import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/routes/TermineSeite.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/TermineService.dart';
import 'package:sammel_app/shared/DweTheme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final demoModus = true;

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
          title: 'DW & Co. Enteignen',
          theme: DweTheme.themeData,
          home: TermineSeite(title: 'Deutsche Wohnen & Co. Enteignen'),
        ));
  }
}
