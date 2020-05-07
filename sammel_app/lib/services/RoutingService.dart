import 'package:flutter/cupertino.dart';
import 'package:sammel_app/routes/ActionCreator.dart';
import 'package:sammel_app/routes/TermineSeite.dart';

class RoutingService {
  Map<dynamic, Route> registeredRoutes = Map();
  dynamic latestRoute;

  static var routes = {
    TermineSeite.NAME: (context) => TermineSeite(),
    ActionCreator.NAME: (context) => ActionCreator(),
  ***REMOVED***

  static var initialRoute = TermineSeite.NAME;

  void register(dynamic type, Route route) {
//    registeredRoutes[type] = route;
    latestRoute = type;
  ***REMOVED***

  bool hasRouteFor(dynamic type) {
    return registeredRoutes.containsKey(type);
  ***REMOVED***

  Route getRouteFor(dynamic type) => registeredRoutes[type];

  bool test() => true;

  bool isLatestRoute(dynamic type) {
    return type == latestRoute;
  ***REMOVED***
***REMOVED***