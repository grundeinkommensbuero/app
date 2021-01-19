import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:url_launcher/url_launcher.dart';

class AttributionOptions extends LayerOptions {
  final Color color;

  AttributionOptions({
    this.color = Colors.blueGrey,
  ***REMOVED***);
***REMOVED***

class AttributionLayer extends StatelessWidget {
  final AttributionOptions options;
  final MapState map;
  final Stream<void> stream;

  AttributionLayer(this.options, this.map, this.stream);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Row(
        children: [
          IconButton(
              icon: Icon(
                Icons.info,
                color: options.color,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('OpenStreetMap Karte'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                RichText(
                                  text: TextSpan(
                                    text: 'Kartendaten von OpenStreetMap\n',
                                    style: TextStyle(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launch(
                                            'https://www.openstreetmap.org/copyright');
                                      ***REMOVED***,
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Veröffentlicht unter der ODbL\n',
                                    style: TextStyle(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launch(
                                            'https://opendatacommons.org/licenses/odbl/');
                                      ***REMOVED***,
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Kartenserver betrieben vom FOSSGIS e.V.\n',
                                    style: TextStyle(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launch(
                                            'https://www.fossgis.de/');
                                      ***REMOVED***,
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Diese Karte verbessern',
                                    style: TextStyle(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launch(
                                            'https://www.mapbox.com/map-feedback/');
                                      ***REMOVED***,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            FlatButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                ***REMOVED***),
                          ],
                        ));
              ***REMOVED***),
          Text("OpenStreetMap"),
        ],
      ),
    );
  ***REMOVED***
***REMOVED***

class AttributionPlugin extends MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<void> stream) {
    return AttributionLayer(options, mapState, stream);
  ***REMOVED***

  @override
  bool supportsLayer(LayerOptions options) {
    return options is AttributionOptions;
  ***REMOVED***
***REMOVED***
