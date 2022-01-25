import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/VisitedHouse.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/services/VisitedHouseView.dart';
import 'package:sammel_app/services/ErrorService.dart';
import 'package:sammel_app/services/GeoService.dart';
import 'package:sammel_app/services/VisitedHousesService.dart';
import 'package:sammel_app/shared/AttributionPlugin.dart';
import 'package:sammel_app/shared/CampaignTheme.dart';
import 'package:sammel_app/shared/NoRotation.dart';
import 'package:sammel_app/shared/ServerException.dart';

import '../Provisioning.dart';

addNewVisitation(
    BuildContext context, VisitedHouse? visitedHouse) async {
  if (visitedHouse != null) {
    //the last event is new. register at server
    var newHouse =
        Provider.of<AbstractVisitedHousesService>(context, listen: false)
            .editVisitedHouse(visitedHouse);
    return newHouse;
  } else
    return null;
}

showAddVisitationDialog(
    {required BuildContext context,
    required VisitedHouseView visitedHouseView,
    required double currentZoomFactor}) async {
  VisitedHouse? visitedHouse = await showDialog(
    context: context,
    builder: (context) => VisitedHouseCreatorDialog(visitedHouseView, currentZoomFactor),
  );
  return addNewVisitation(context, visitedHouse);
}

class VisitedHouseCreatorDialog extends StatefulWidget {
  late final LatLng? center;
  final VisitedHouseView visitedHouseView;
  final double currentZoomFactor;

  VisitedHouseCreatorDialog(this.visitedHouseView, this.currentZoomFactor)
      : super(key: Key('add visited house dialog'));

  @override
  State<StatefulWidget> createState() {
    return VisitedHouseCreatorState(visitedHouseView);
  }
}

class VisitedHouseCreatorState extends State<VisitedHouseCreatorDialog> {
  LocationMarker? marker;
  late TextEditingController visitedHouseController;
  late TextEditingController visitedHousePartController;
  @required
  late VisitedHouseView visitedHouseView;
  late LatLng center;

  var showLoadingIndicator = false;

  VisitedHouseCreatorState(VisitedHouseView visitedHouseView) {
    this.visitedHouseView = visitedHouseView;
    this.center = LatLng(
        0.5 * (visitedHouseView.bbox.maxLatitude + visitedHouseView.bbox.minLatitude),
        0.5 *
            (visitedHouseView.bbox.maxLongitude + visitedHouseView.bbox.minLongitude));
    visitedHouseController = TextEditingController(text: '');
    visitedHousePartController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    if (visitedHouseView.selectedHouse == null) houseSelected(this.center);
    return AlertDialog(
      title: Text('Besuchtes Haus').tr(),
      content: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.min, children: createWidgets())),
      actions: [
        TextButton(
          child: Text("Abbrechen").tr(),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
        TextButton(
          key: Key('venue dialog finish button'),
          child: Text("Fertig").tr(),
          onPressed: () {
            visitedHouseView.selectedHouse?.visitations.last.adresse =
                visitedHouseController.text;
            visitedHouseView.selectedHouse?.visitations.last.hausteil =
                visitedHousePartController.text;
            if (Provider.of<AbstractUserService>(context, listen: false)
                    .latestUser ==
                null) throw ServerException('Couldnt fetch user from server');
            Navigator.pop(context, visitedHouseView.selectedHouse);
          },
        ),
      ],
    );
  }

  List<Widget> createWidgets() {
    var widgets = [
      Text(
        'Wähle das Haus auf der Karte aus.',
        textScaleFactor: 0.9,
      ).tr(),
      SizedBox(
        height: 5.0,
      ),
      Container(
          decoration: BoxDecoration(
              border: Border.all(color: CampaignTheme.secondary, width: 1.0)),
          child:
              SizedBox(height: 300.0, width: 300.0, child: buildFlutterMap())),
      SizedBox(
        height: 5.0,
      ),
      SizedBox(
        height: 10.0,
      ),
      Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Adresse',
          ).tr()),
      TextFormField(
        key: Key('visited house adress input'),
        //  keyboardType: TextInputType.multiline,
        //onChanged: (input) => location.description = input,
        controller: visitedHouseController,
        maxLength: 120,
        decoration: InputDecoration(border: OutlineInputBorder()),
      ),
      Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Hausteil'.tr(),
          ).tr()),
      Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'zum Beispiel Vorderhaus, Seitenflügel, Aufgang B, Etage 1-3, etc.'
                .tr(),
            textScaleFactor: 0.8,
          ).tr()),
      TextFormField(
        key: Key('visited house part input'),
        controller: visitedHousePartController,
        maxLength: 120,
        decoration: InputDecoration(border: OutlineInputBorder()),
      )
    ];
    return widgets;
  }

  Widget buildFlutterMap() {
    var map = FlutterMap(
        key: Key('venue map'),
        options: MapOptions(
            center: center,
            zoom: widget.currentZoomFactor < 17 ? 17 : widget.currentZoomFactor,
            interactiveFlags: noRotationNoMove,
            swPanBoundary: LatLng(
                visitedHouseView.bbox.minLatitude, visitedHouseView.bbox.minLongitude),
            nePanBoundary: LatLng(
                visitedHouseView.bbox.maxLatitude, visitedHouseView.bbox.maxLongitude),
            maxZoom: geo.zoomMax,
            minZoom: geo.zoomMin,
            onTap: houseSelected,
            plugins: [AttributionPlugin()]),
        layers: [
          TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.de/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
          PolygonLayerOptions(
              polygons: visitedHouseView.buildDrawablePolygonsFromView(),
              polygonCulling: false),
          MarkerLayerOptions(markers: marker == null ? [] : [marker!]),
          AttributionOptions(),
        ]);
    if (showLoadingIndicator) {
      return Stack(children: [
        map,
        Opacity(
            opacity: 0.7,
            child: Container(
                width: 300, height: 300, color: CampaignTheme.disabled)),
        Center(
            child: SizedBox(
                width: 50,
                height: 50,
                child: LoadingIndicator(
                    indicatorType: Indicator.ballRotateChase,
                    color: CampaignTheme.primary)))
      ]);
    }
    return map;
  }

  houseSelected(LatLng point) async {
    setState(() => showLoadingIndicator = true);

    SelectableVisitedHouse? house = visitedHouseView.getHouseByPoint(point);
    //not in current view
    if (house == null) {
      var houseFromServer = await Provider.of<AbstractVisitedHousesService>(
              context,
              listen: false)
          .getVisitedHouseOfPoint(point, true)
          .catchError((e, s) {
        ErrorService.handleError(e, s);
        return null;
      });
      if (houseFromServer != null)
        house = SelectableVisitedHouse.fromVisitedHouse(houseFromServer);
    }
    if (!mounted) return;

    GeoData geoData = await Provider.of<GeoService>(context, listen: false)
        .getDescriptionToPoint(point);

    setState(() {
      if (house != null &&
          visitedHouseView.selectedHouse?.osmId != house.osmId) {
        visitedHouseView.selectedHouse = SelectableVisitedHouse.clone(house);
        visitedHouseView.selectedHouse?.selected = true;
        var userId = Provider.of<AbstractUserService>(context, listen: false)
            .latestUser!
            .id;
        if (userId != null)
          visitedHouseView.selectedHouse?.visitations
              .add(Visitation(null, '', '', userId, DateTime.now()));
        if(geoData.street != null)
          {
            if(geoData.number != null)
              {
                visitedHouseController.text = '${geoData.street} ${geoData.number}';
              }
            else
              {
                visitedHouseController.text = '${geoData.street}';
              }
          }
        showLoadingIndicator = false;
      }
    });
  }
}

class LocationMarker extends Marker {
  LocationMarker(LatLng point)
      : super(
            point: point,
            builder: (context) => DecoratedBox(
                key: Key('location marker'),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CampaignTheme.primary,
                    boxShadow: [
                      BoxShadow(blurRadius: 4.0, offset: Offset(-2.0, 2.0))
                    ]),
                child: Icon(Icons.supervised_user_circle, size: 30.0)));
}
