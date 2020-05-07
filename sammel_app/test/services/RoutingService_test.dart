import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/services/RoutingService.dart';

void main() {
  RoutingService routing;
  Widget widget;
  setUp(() {
    routing = RoutingService();
  });

  test('register stores routes for widget classes', () {
    var textRoute = MaterialPageRoute(
        settings: RouteSettings(name: 'Text route'),
        builder: (BuildContext context) => Text('123'));
    routing.register(Text, textRoute);
    var iconRoute = MaterialPageRoute(
        settings: RouteSettings(name: 'Icon route'),
        builder: (BuildContext context) => Icon(Icons.update));
    routing.register(Icon, iconRoute);
    var buttonRoute = MaterialPageRoute(
        settings: RouteSettings(name: 'Text route'),
        builder: (BuildContext context) => RaisedButton(onPressed: () {}));
    routing.register(RaisedButton, buttonRoute);

    expect(routing.registeredRoutes.values.length, 3);
    expect(routing.registeredRoutes[Text], equals(textRoute));
    expect(routing.registeredRoutes[Icon], equals(iconRoute));
    expect(routing.registeredRoutes[RaisedButton], equals(buttonRoute));
  });

  test('register replaces routes', () {
    routing.registeredRoutes = {
      Text: MaterialPageRoute(
          settings: RouteSettings(name: 'Text route 1'),
          builder: (BuildContext context) => Text('1')),
    };

    var latestRoute = MaterialPageRoute(
        settings: RouteSettings(name: 'Text route 2'),
        builder: (BuildContext context) => Text('2'));
    routing.register(Text, latestRoute);

    expect(routing.registeredRoutes.values.length, 1);
    expect(routing.registeredRoutes[Text], equals(latestRoute));
  });

  test('hasRouteFor is false if no route for class exists', () {
    routing.registeredRoutes = {
      Text: MaterialPageRoute(
          settings: RouteSettings(name: 'Text route'),
          builder: (BuildContext context) => Text('123')),
      Icon: MaterialPageRoute(
          settings: RouteSettings(name: 'Icon route'),
          builder: (BuildContext context) => Icon(Icons.update)),
    };

    expect(routing.hasRouteFor(RaisedButton), false);
  });

  test('hasRouteFor is true if a route for class exists', () {
    routing.registeredRoutes = {
      Text: MaterialPageRoute(
          settings: RouteSettings(name: 'Text route'),
          builder: (BuildContext context) => Text('123')),
    };

    expect(routing.hasRouteFor(Text), true);
  });

  test('getRouteFor returns correct route for class', () {
    var textRoute = MaterialPageRoute(
          settings: RouteSettings(name: 'Text route'),
          builder: (BuildContext context) => Text('123'));
    routing.registeredRoutes = {
      Text: textRoute,
      Icon: MaterialPageRoute(
          settings: RouteSettings(name: 'Icon route'),
          builder: (BuildContext context) => Icon(Icons.update)),
      RaisedButton: MaterialPageRoute(
          settings: RouteSettings(name: 'Button route'),
          builder: (BuildContext context) => RaisedButton(onPressed: () {})),
    };

    expect(routing.getRouteFor(Text), textRoute);
  });

  test('getRouteFor returns null if no route for class exists', () {
    var textRoute = MaterialPageRoute(
          settings: RouteSettings(name: 'Text route'),
          builder: (BuildContext context) => Text('123'));
    routing.registeredRoutes = {
      Text: textRoute,
    };

    expect(routing.getRouteFor(RaisedButton), isNull);
  });

  test('isLatestRoute returns false if never registered', () {
    var textRoute = MaterialPageRoute(
        settings: RouteSettings(name: 'Text route'),
        builder: (BuildContext context) => Text('123'));
    routing.register(Text, textRoute);

    expect(routing.isLatestRoute(Icon), isFalse);
  });

  test('isLatestRoute returns true if solely registered', () {
    var textRoute = MaterialPageRoute(
        settings: RouteSettings(name: 'Text route'),
        builder: (BuildContext context) => Text('123'));
    routing.register(Text, textRoute);

    expect(routing.isLatestRoute(Text), isTrue);
  });

  test('isLatestRoute returns true if last registered', () {
    routing.register(Text, MaterialPageRoute(
        settings: RouteSettings(name: 'Icon route'),
        builder: (BuildContext context) => Icon(Icons.update)));
    routing.register(Icon, MaterialPageRoute(
        settings: RouteSettings(name: 'Icon route'),
        builder: (BuildContext context) => Icon(Icons.update)));
    var buttonRoute = MaterialPageRoute(
        settings: RouteSettings(name: 'Button route'),
        builder: (BuildContext context) => RaisedButton(onPressed: () {}));
    routing.register(RaisedButton, buttonRoute);

    expect(routing.isLatestRoute(RaisedButton), isTrue);
  });

  test('isLatestRoute returns false if not registered last', () {
    routing.register(Text, MaterialPageRoute(
        settings: RouteSettings(name: 'Icon route'),
        builder: (BuildContext context) => Text('123')));
    var iconRoute = MaterialPageRoute(
        settings: RouteSettings(name: 'Icon route'),
        builder: (BuildContext context) => Icon(Icons.update));
    routing.register(Icon, iconRoute);
    routing.register(RaisedButton, MaterialPageRoute(
        settings: RouteSettings(name: 'Button route'),
        builder: (BuildContext context) => RaisedButton(onPressed: () {})));

    expect(routing.isLatestRoute(Icon), isFalse);
  });
}
