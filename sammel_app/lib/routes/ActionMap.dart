import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/shared/DweTheme.dart';

class ActionMap extends StatefulWidget {
  final List<Termin> termine;
  final Function openActionDetails;
  final Function isMyAction;

  ActionMap(this.termine, this.isMyAction, this.openActionDetails, {Key key})
      : super(key: key);

  @override
  ActionMapState createState() => ActionMapState();
}

class ActionMapState extends State<ActionMap> {
  ActionMapState();

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(52.5170365, 13.3888599),
        zoom: 10.0,
        maxZoom: 19.0,
      ),
      layers: [
        TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']),
        MarkerLayerOptions(
            markers: widget.termine
                .where((action) =>
                    action.lattitude != null && action.longitude != null)
                .map((action) => ActionMarker(action,
                    myAction: widget.isMyAction(action.id),
                    onTap: widget.openActionDetails))
                .toList()),
      ],
    );
  }
}

class ActionMarker extends Marker {
  bool myAction = false;
  Function onTap;

  ActionMarker(Termin action, {this.myAction, this.onTap})
      : super(
          width: 30.0,
          height: 30.0,
          point: LatLng(action.lattitude, action.longitude),
          builder: (context) => FlatButton(
              key: Key('action marker'),
              onPressed: () => onTap(context, action),
              color: DweTheme.actionColor(action.ende, myAction),
              shape: CircleBorder(
                  side: BorderSide(color: DweTheme.purple, width: 1.0)),
              padding: EdgeInsets.all(0),
              child: Image.asset(action.getAsset(centered: true))),
        );
}
