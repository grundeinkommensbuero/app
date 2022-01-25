import 'dart:convert';

import 'package:http_server/http_server.dart';
import 'package:latlong2/latlong.dart';
import 'package:sammel_app/model/VisitedHouse.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/DistanceHelper.dart';

import 'ErrorService.dart';
import 'GeoService.dart';
import 'VisitedHouseView.dart';

abstract class AbstractVisitedHousesService extends BackendService {
  late GeoService geoService;

  Map<int, VisitedHouse> localHousesMap = {};

  Future<List<VisitedHouse>> loadVisitedHouses();

  Future<VisitedHouse?> createVisitedHouse(VisitedHouse house);

  AbstractVisitedHousesService(AbstractUserService userService,
      GeoService geoService, Backend backend)
      : super(userService, backend) {
    this.geoService = geoService;
  }

  Future<VisitedHouse?> getVisitedHouseOfPoint(LatLng point,
      bool checkOnServer) async {
    VisitedHouse? visitedHousOnPoint = getVisitedHouseForPointLocal(point);
    if (visitedHousOnPoint != null) return visitedHousOnPoint;

    if (!checkOnServer) return null;

    List polygonAndDesc =
    await geoService.getPolygonAndDescriptionOfPoint(point);
    List<LatLng>? shape = polygonAndDesc[0];
    var osmId = polygonAndDesc[1];
    if (shape == null) {
      //no shape found take small bbox around point. problem is that we want a box that is drawn as square
      double lat5m = DistanceHelper.getLatDiffFromM(point, 5.0);
      double lng5m = DistanceHelper.getLongDiffFromM(point, 5.0);
      shape = [
        LatLng(point.latitude - lat5m, point.longitude - lng5m),
        LatLng(point.latitude + lat5m, point.longitude - lng5m),
        LatLng(point.latitude + lat5m, point.longitude + lng5m),
        LatLng(point.latitude - lat5m, point.longitude + lng5m)
      ];
    }
    if (osmId == null) {
      //in this case we create the osm id by the center
      osmId = point.hashCode;
    }
    return getVistitedHouseFromJson(osmId, point, shape);
  }

  VisitedHouse? getVistitedHouseFromJson(int osmId, LatLng point,
      List<LatLng> shape) {
    if (localHousesMap.containsKey(osmId)) {
      return localHousesMap[osmId];
    } else {
      return VisitedHouse(osmId, point.latitude, point.longitude, shape, []);
    }
  }

  VisitedHouseView getVisitedHousesInArea(BoundingBox bbox) {
    List<SelectableVisitedHouse> housesInRoi = localHousesMap.values
        .where((house) => house.bbox.intersect(bbox))
        .map((house) => SelectableVisitedHouse.fromVisitedHouse(house))
        .toList();

    return VisitedHouseView(bbox, housesInRoi);
  }

  VisitedHouse? getVisitedHouseForPointLocal(LatLng point) =>
      // ignore: unnecessary_cast
  localHousesMap.values.map((house) => house as VisitedHouse?).firstWhere(
          (house) => house!.bbox.containsPoint(point) && house.inside(point),
      orElse: () => null);

  VisitedHouse editVisitedHouse(VisitedHouse house) {
    List<Visitation> newVisitationList = house.visitations;
    Set<int> deleteVisitations = Set();

    print('localHousesMap: ${localHousesMap.values.map((value) => '${value
        .osmId} ${value.visitations.map((e) => e.id)}')}');
    VisitedHouse? localHouse = localHousesMap[house.osmId];

    if (localHouse != null) {
      var currentEventIds = localHouse.visitations.map((e) => e.id!).toSet();
      print('currentIds: ${currentEventIds}');
      var newVisitationIds = newVisitationList.map((e) => e.id).toSet();
      print('newIds: ${newVisitationIds}');
      deleteVisitations = currentEventIds.difference(newVisitationIds);
      newVisitationList = newVisitationList
          .where((element) => !currentEventIds.contains(element.id))
          .toList();
    }
    print('deleteVisitations: ${deleteVisitations}');
    for (var deleteVisitation in deleteVisitations) {
      print('Lösche Event ${deleteVisitation}');
      deleteVisitedHouse(deleteVisitation);
    }

    for (var addEvent in newVisitationList) {
      VisitedHouse houseWithEventOnly = VisitedHouse(house.osmId,
          house.latitude, house.longitude, house.shape, [addEvent]);
      var h = createVisitedHouse(houseWithEventOnly);
      h.then((value) => addEvent.id = value?.visitations.last.id);
    }
    print('Events von Haus ${house.osmId}: ${house.visitations.map((e) => e
        .id)}');
    if (house.visitations.isNotEmpty) {
      house.visitations.sort((a, b) =>
      a.datum
          .difference(b.datum)
          .inSeconds > 0
          ? 1
          : a.datum
          .difference(b.datum)
          .inSeconds < 0
          ? -1
          : 0);
      localHousesMap[house.osmId] = house;
    } else {
      print('Lösche Haus ${house.osmId}');
      localHousesMap.remove(house.osmId);
    }

    return house;
  }

  List<VisitedHouse> getAllHouses() {
    return localHousesMap.values.toList();
  }

  Future deleteVisitedHouse(int id);
}

class VisitedHousesService extends AbstractVisitedHousesService {
  late GeoService geoService;

  VisitedHousesService(GeoService geoService, AbstractUserService userService,
      Backend backend)
      : super(userService, geoService, backend);

  @override
  Future<VisitedHouse?> createVisitedHouse(VisitedHouse house) async {
    try {
      var response =
      await post('service/besuchteHaeuser/neu', jsonEncode(house));
      return VisitedHouse.fromJson(response.body);
    } catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Eintragen von Besuchtem Haus ist fehlgeschlagen.');
    }
  }

  @override
  deleteVisitedHouse(int id) async {
    try {
      await delete('service/besuchteHaeuser/$id');
    } catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Löschen von Besuchtem Haus ist fehlgeschlagen.');
    }
  }

  @override
  Future<List<VisitedHouse>> loadVisitedHouses() async {
    HttpClientResponseBody response;
    try {
      response = await get('service/besuchteHaeuser');
    } catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Besuchte Häuser konnten nicht geladen werden.');
      return [];
    }

    final houses = (response.body as List)
        .map((jsonHouse) => VisitedHouse.fromJson(jsonHouse))
        .toList();

    for (VisitedHouse house in houses) {
      VisitedHouse? localHouse = localHousesMap[house.osmId];
      if (localHouse != null) {
        var idx = localHouse.visitations
            .indexWhere((element) => element.id == house.visitations.first.id);
        if (idx == -1) {
          localHouse.visitations.add(house.visitations.first);
        } else {
          localHouse.visitations[idx] = house.visitations.first;
        }
      } else {
        localHousesMap[house.osmId] = house;
      }
    }

    return this.getAllHouses();
  }
}

var s1 = [
  {'lat': 52.5204094, 'lon': 13.3687217},
  {'lat': 52.5204086, 'lon': 13.3680145},
  {'lat': 52.5204089, 'lon': 13.3678788},
  {'lat': 52.5204099, 'lon': 13.3677085},
  {'lat': 52.5204104, 'lon': 13.3676495},
  {'lat': 52.5206084, 'lon': 13.3679925},
  {'lat': 52.5206114, 'lon': 13.3679974},
  {'lat': 52.5206187, 'lon': 13.3680081},
  {'lat': 52.5206179, 'lon': 13.3680836},
  {'lat': 52.5206187, 'lon': 13.3687223},
  {'lat': 52.5204767, 'lon': 13.3687249},
  {'lat': 52.5204758, 'lon': 13.3688658},
  {'lat': 52.5206182, 'lon': 13.3688652},
  {'lat': 52.5206176, 'lon': 13.3693935},
  {'lat': 52.5204761, 'lon': 13.3693966},
  {'lat': 52.5204768, 'lon': 13.3695387},
  {'lat': 52.5206174, 'lon': 13.3695316},
  {'lat': 52.5206179, 'lon': 13.3706762},
  {'lat': 52.52047, 'lon': 13.3706844},
  {'lat': 52.52047, 'lon': 13.370648},
  {'lat': 52.5204065, 'lon': 13.3706481},
  {'lat': 52.5204063, 'lon': 13.3695382},
  {'lat': 52.5202293, 'lon': 13.3695436},
  {'lat': 52.5200722, 'lon': 13.3695426},
  {'lat': 52.5199124, 'lon': 13.3695358},
  {'lat': 52.5199138, 'lon': 13.3706514},
  {'lat': 52.5198519, 'lon': 13.3706515},
  {'lat': 52.5198519, 'lon': 13.3706825},
  {'lat': 52.5197022, 'lon': 13.3706828},
  {'lat': 52.5197014, 'lon': 13.369536},
  {'lat': 52.5198416, 'lon': 13.3695358},
  {'lat': 52.5198412, 'lon': 13.3693948},
  {'lat': 52.519701, 'lon': 13.3693986},
  {'lat': 52.5197007, 'lon': 13.3688791},
  {'lat': 52.5198481, 'lon': 13.3688788},
  {'lat': 52.5198479, 'lon': 13.3687133},
  {'lat': 52.519705, 'lon': 13.3687135},
  {'lat': 52.5197032, 'lon': 13.3660429},
  {'lat': 52.5197021, 'lon': 13.3656432},
  {'lat': 52.5198057, 'lon': 13.366007},
  {'lat': 52.5199159, 'lon': 13.3663634},
  {'lat': 52.5199159, 'lon': 13.3665685},
  {'lat': 52.5199161, 'lon': 13.3671573},
  {'lat': 52.519914, 'lon': 13.3687215},
  {'lat': 52.5201746, 'lon': 13.3687225},
  {'lat': 52.5204094, 'lon': 13.3687217}
];

class DemoVisitedHousesService extends AbstractVisitedHousesService {
  List<VisitedHouse> visitedHousesOnStart = [
    VisitedHouse(1, 52.52014, 13.36911,
        s1.map((e) => LatLng(e['lat'] ?? 0.0, e['lon'] ?? 0)).toList(), [
          Visitation(
              1, 'Willy-Brandt-Straße 1, Tiergarten, Mitte, Berlin, 10557',
              "Westfluegel", 12, DateTime(2021, 7, 16))
        ]),
    VisitedHouse(2, 52.4964133, 13.3617511, [], [
      Visitation(2, 'Potsdamer Straße 143, 10783 Berlin', '', 12,
          DateTime(2021, 7, 17))
    ]),
    VisitedHouse(3, 52.5065, 13.35125, [], [
      Visitation(
          3,
          'Klingelhöferstraße 8,Botschaftsviertel, Tiergarten, Mitte, Berlin, 10785',
          'Haupteingang',
          11,
          DateTime(2021, 7, 19))
    ])
  ];
  var maxId = 3;

  DemoVisitedHousesService(AbstractUserService userService,
      GeoService geoService)
      : super(userService, geoService, DemoBackend()) {
    localHousesMap = {for (var house in visitedHousesOnStart) house.osmId: house};
  }

  @override
  Future<VisitedHouse> createVisitedHouse(VisitedHouse house) {
    print('### Häuser vorher: ${visitedHousesOnStart.map((e) =>
        e.visitations.map((e) => e.id))}');
    house.visitations.last.id = maxId += 1;
    house.osmId = maxId;
    var newHouse = VisitedHouse.clone(house);
    visitedHousesOnStart.add(newHouse);
    print('### Häuser nachher: ${visitedHousesOnStart.map((e) =>
        e.visitations.map((e) => e.id))}');
    return Future.value(newHouse);
  }

  @override
  Future<List<VisitedHouse>> loadVisitedHouses() => Future.value(visitedHousesOnStart);

  @override
  deleteVisitedHouse(int id) async {
    // Löschen im Server unnötig}
  }
}