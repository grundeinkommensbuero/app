import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:sammel_app/shared/DweTheme.dart';

Future showVenueDialog(BuildContext context, String initDescription,
    LatLng initCoordinates, LatLng center) {
  Marker marker = initCoordinates != null ? VenueMarker(initCoordinates) : null;
  Venue venue = Venue(initDescription ?? '', initCoordinates);

  return showDialog(
    context: context,
    builder: (BuildContext context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
              key: Key('treffpunkt input dialog'),
              title: Text('Treffpunkt'),
              content: SingleChildScrollView(
                  child: ListBody(children: [
                    Text(
                      'Wähle auf der Karte einen Treffpunkt aus.',
                      textScaleFactor: 0.9,
                    ),
                    Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: DweTheme.yellowBright, width: 2.0)),
                    child: SizedBox(
                        height: 300.0,
                        width: 300.0,
                        child: FlutterMap(
                            options: MapOptions(
                                center:
                                    center ?? LatLng(52.5170365, 13.3888599),
                                zoom: center != null ? 14.0 : 10.0,
                                maxZoom: 19.0,
                                onTap: (LatLng point) => setDialogState(() {
                                      venue.coordinates = point;
                                      marker = VenueMarker(point);
                                    })),
                            layers: [
                              TileLayerOptions(
                                  urlTemplate:
                                      "https://{s}.tile.openstreetmap.de/{z}/{x}/{y}.png",
                                  subdomains: ['a', 'b', 'c']),
                              MarkerLayerOptions(
                                  markers: marker == null ? [] : [marker])
                            ]))),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Du kannst auch eine eigene Beschreibung angeben, '
                  'z.B. "Unter der Weltzeituhr" oder "Tempelhofer Feld, '
                  'Eingang Kienitzstraße":',
                  textScaleFactor: 0.9,
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  initialValue: initDescription ?? '',
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (input) => venue.description = input,
                ),
              ])),
              actions: [
                FlatButton(
                  child: Text("Abbrechen"),
                  onPressed: () {
                    Navigator.pop(
                        context, Venue(initDescription, initCoordinates));
                  },
                ),
                FlatButton(
                  child: Text("Fertig"),
                  onPressed: () {
                    Navigator.pop(context, venue);
                  },
                ),
              ],
            )),
  );
}

class VenueMarker extends Marker {
  VenueMarker(LatLng point)
      : super(
            point: point,
            builder: (context) => DecoratedBox(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: DweTheme.yellow,
                    boxShadow: [
                      BoxShadow(blurRadius: 4.0, offset: Offset(-2.0, 2.0))
                    ]),
                child: Icon(Icons.supervised_user_circle, size: 30.0)));
}

class Venue {
  String description;
  LatLng coordinates;

  Venue(this.description, this.coordinates);
}
