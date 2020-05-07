
import 'package:flutter/cupertino.dart';

class RoutingService {
  Map<dynamic, Route> registeredRoutes = Map();
  dynamic latestRoute;

  void register(dynamic type, Route route) {
//    registeredRoutes[type] = route;
    latestRoute = type;
  }

  bool hasRouteFor(dynamic type) {
    return registeredRoutes.containsKey(type);
  }

  Route getRouteFor(dynamic type) => registeredRoutes[type];

  bool test() => true;

  bool isLatestRoute(dynamic type) {
    return type == latestRoute;
  }
}