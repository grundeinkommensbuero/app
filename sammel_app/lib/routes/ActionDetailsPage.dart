import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:sammel_app/shared/ExpandableConstrainedBox.dart';

enum TerminDetailsCommand { EDIT, DELETE, EVALUATE, CLOSE, FOCUS }

// ignore: must_be_immutable
class ActionDetailsPage extends StatefulWidget {
  final Termin action;
  Marker marker;

  ActionDetailsPage(this.action) {
    marker = Marker(
        anchorPos: AnchorPos.align(AnchorAlign.top),
        point: LatLng(action.latitude, action.longitude),
        builder: (context) => Icon(
              Icons.location_on,
              key: Key('action details map marker'),
              size: 30,
            ));
  }

  @override
  State<StatefulWidget> createState() {
    return ActionDetailsPageState();
  }
}

class ActionDetailsPageState extends State<ActionDetailsPage> {
  ActionDetailsPageState();

  var participator;

  @override
  Widget build(BuildContext context) {
    return Column(key: Key('action details page'), children: [
      // Time
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.access_time, size: 40.0),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Wann?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ).tr(),
          SelectableText(ChronoHelfer.formatDateOfDateTimeMitWochentag(
              widget.action.beginn)),
          SelectableText(ChronoHelfer.formatFromToTimeOfDateTimes(
              widget.action.beginn, widget.action.ende))
        ]))
      ]),
      SizedBox(
        height: 10.0,
      ),

      // Description
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.info_outline, size: 40.0),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Was?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ).tr(),
          ExpandableConstrainedBox(
            child: SelectableText(
              widget.action.details.beschreibung,
              // onTap: () => {},
              // TODO: SelectableText stiehlt ExpandableContraintBox den onTap
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
            maxHeight: 105.0,
            expandableCondition:
                widget.action.details.beschreibung.length > 200,
          )
        ]))
      ]),
      SizedBox(
        height: 10.0,
      ),

      // Contact
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.face, size: 40.0),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Wer?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ).tr(),
          ExpandableConstrainedBox(
            child: SelectableText(
              widget.action.details.kontakt,
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
            maxHeight: 105.0,
            expandableCondition: widget.action.details.kontakt.length > 200,
          )
        ]))
      ]),

      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.my_location, size: 40.0),
        SizedBox(
          width: 10.0,
        ),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Wo?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ).tr(),
          ExpandableConstrainedBox(
            child: SelectableText(
                tr('{kiez} in {bezirk}\n ⛒ Treffpunkt: {treffpunkt}',
                    namedArgs: {
                      'kiez': widget.action.ort.name,
                      'bezirk': widget.action.ort.ortsteil,
                      'treffpunkt': widget.action.details.treffpunkt,
                    }),
                style: TextStyle(fontWeight: FontWeight.normal)),
            maxHeight: 80,
            expandableCondition: widget.action.details.treffpunkt.length > 70,
          ),
        ]))
      ]),
      SizedBox(
        height: 10.0,
      ),
      InkWell(
        child: Container(
          height: 150.0,
          width: 250.0,
          decoration: BoxDecoration(
              border: Border.all(color: DweTheme.purple, width: 1.0)),
          child: FlutterMap(
            key: Key('action details map'),
            options: MapOptions(
                center: LatLng(widget.action.latitude, widget.action.longitude),
                zoom: 15,
                interactive: false),
            layers: [
              TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.de/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']),
              MarkerLayerOptions(markers: [widget.marker]),
            ],
          ),
        ),
        onTap: () => Navigator.pop(context, TerminDetailsCommand.FOCUS),
      ),
    ]);
  }
}
