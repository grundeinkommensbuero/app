import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/routes/ActionCreator.dart';
import 'package:sammel_app/routes/TermineSeite.dart';
import 'package:sammel_app/services/ListLocationService.dart';
import 'package:sammel_app/services/RoutingService.dart';
import 'package:sammel_app/services/StorageService.dart';
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
          Provider<AbstractListLocationService>.value(
              value: demoModus
                  ? DemoListLocationService()
                  : ListLocationService()),
          Provider<StorageService>.value(value: StorageService()),
          Provider<RoutingService>.value(value: RoutingService()),
        ],
        child: MaterialApp(
            initialRoute: TermineSeite.NAME,
            routes: {
              TermineSeite.NAME: (context) => TermineSeite(),
              ActionCreator.NAME: (context) => ActionCreator(),
            ***REMOVED***,
            title: 'DW & Co. Enteignen',
            theme: DweTheme.themeData));
  ***REMOVED***
***REMOVED***
