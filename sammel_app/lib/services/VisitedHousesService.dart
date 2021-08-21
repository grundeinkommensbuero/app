import 'dart:convert';

import 'package:http_server/http_server.dart';
import 'package:latlong2/latlong.dart';
import 'package:sammel_app/model/Building.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/DistanceHelper.dart';

import 'ErrorService.dart';
import 'GeoService.dart';
import 'VisitedHouseView.dart';

abstract class AbstractVisitedHousesService extends BackendService {
  late GeoService geoService;

  Map<int, VisitedHouse> localBuildingMap = {***REMOVED***

  Future<List<VisitedHouse>> loadVisitedHouses();

  Future<VisitedHouse?> createVisitedHouse(VisitedHouse house);

  AbstractVisitedHousesService(
      AbstractUserService userService, GeoService geoService, Backend backend)
      : super(userService, backend) {
    this.geoService = geoService;
  ***REMOVED***

  @override
  Future<VisitedHouse?> getVisitedHouseOfPoint(
      LatLng point, bool checkOnServer) async {
    VisitedHouse? visitedHousOnPoint = getBuildingForPointLocal(point);
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
    ***REMOVED***
    if (osmId == null) {
      //in this case we create the osm id by the center
      osmId = point.hashCode;
    ***REMOVED***
    return getBuildingFromJson(osmId, point, shape);
  ***REMOVED***

  VisitedHouse? getBuildingFromJson(
      int osmId, LatLng point, List<LatLng> shape) {
    if (localBuildingMap.containsKey(osmId)) {
      return localBuildingMap[osmId];
    ***REMOVED*** else {
      return VisitedHouse(osmId, point.latitude, point.longitude, shape, []);
    ***REMOVED***
  ***REMOVED***

  VisitedHouseView getBuildingsInArea(BoundingBox bbox) {
    //TODO: it only checks for local buildings atm
    //TODO: take a bit more clever data format
    List<SelectableVisitedHouse> buildingsInRoi = localBuildingMap.values
        .where((building) => building.bbox.intersect(bbox))
        .map((building) => SelectableVisitedHouse.fromVisitedHouse(building))
        .toList();

    return VisitedHouseView(bbox, buildingsInRoi);
  ***REMOVED***

  VisitedHouse? getBuildingForPointLocal(LatLng point) =>
      // ignore: unnecessary_cast // nötig für Null-Ergebnis
      localBuildingMap.values.map((house) => house as VisitedHouse?).firstWhere(
          (building) =>
              building!.bbox.containsPoint(point) && building.inside(point),
          orElse: () => null);

  VisitedHouse editVisitedHouse(VisitedHouse house) {
    var addEvents = house.visitationEvents;
    var deleteEvents = Set();

    VisitedHouse? building = localBuildingMap[house.osmId];

    if (building != null) {
      var currentIds = building.visitationEvents.map((e) => e.id).toSet();
      var newIds = house.visitationEvents.map((e) => e.id).toSet();
      deleteEvents = currentIds.difference(newIds);
      addEvents = addEvents
          .where((element) => !currentIds.contains(element.id))
          .toList();
    ***REMOVED***
    for (var deleteEvent in deleteEvents) {
      deleteVisitedHouse(deleteEvent);
    ***REMOVED***

    for (var addEvent in addEvents) {
      VisitedHouse houseWithWventOnly = VisitedHouse(house.osmId,
          house.latitude, house.longitude, house.shape, [addEvent]);
      var h = createVisitedHouse(houseWithWventOnly);
      h.then((value) => addEvent.id = value?.visitationEvents.last.id);
    ***REMOVED***
    if (house.visitationEvents.isNotEmpty) {
      house.visitationEvents
          .sort((a, b) => a.datum.difference(b.datum).inSeconds > 0
              ? 1
              : a.datum.difference(b.datum).inSeconds < 0
                  ? -1
                  : 0);
      localBuildingMap[house.osmId] = house;
    ***REMOVED*** else {
      localBuildingMap.remove(house.osmId);
    ***REMOVED***

    return house;
  ***REMOVED***

  getAllHouses() {
    return localBuildingMap.values.toList();
  ***REMOVED***

  deleteVisitedHouse(int id) async {***REMOVED***
***REMOVED***

class VisitedHousesService extends AbstractVisitedHousesService {
  late GeoService geoService;

  VisitedHousesService(
      GeoService geoService, AbstractUserService userService, Backend backend)
      : super(userService, geoService, backend);

  @override
  Future<VisitedHouse?> createVisitedHouse(VisitedHouse house) async {
    try {
      var response =
          await post('service/besuchteHaeuser/neu', jsonEncode(house));
      return VisitedHouse.fromJson(response.body);
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Eintragen von Besuchtem Haus ist fehlgeschlagen.');
    ***REMOVED***
  ***REMOVED***

  @override
  deleteVisitedHouse(int id) async {
    try {
      return await delete('service/besuchteHaeuser/$id');
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Löschen von Besuchtem Haus ist fehlgeschlagen.');
    ***REMOVED***
  ***REMOVED***

  @override
  Future<List<VisitedHouse>> loadVisitedHouses() async {
    HttpClientResponseBody response;
    try {
      response = await get('service/besuchteHaeuser');
    ***REMOVED*** catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Besuchte Häuser konnten nicht geladen werden.');
      return [];
    ***REMOVED***

    final houses = (response.body as List)
        .map((jsonHouse) => VisitedHouse.fromJson(jsonHouse))
        .toList();

    for (VisitedHouse house in houses) {
      VisitedHouse? localHouse = localBuildingMap[house.osmId];
      if (localHouse != null) {
        var idx = localHouse.visitationEvents.indexWhere(
            (element) => element.id == house.visitationEvents.first.id);
        if (idx == -1) {
          localHouse.visitationEvents.add(house.visitationEvents.first);
        ***REMOVED*** else {
          localHouse.visitationEvents[idx] = house.visitationEvents.first;
        ***REMOVED***
      ***REMOVED*** else {
        localBuildingMap[house.osmId] = house;
      ***REMOVED***
    ***REMOVED***

    return this.getAllHouses();
  ***REMOVED***
***REMOVED***

var s1 = [
  {'lat': 52.5204094, 'lon': 13.3687217***REMOVED***,
  {'lat': 52.5204086, 'lon': 13.3680145***REMOVED***,
  {'lat': 52.5204089, 'lon': 13.3678788***REMOVED***,
  {'lat': 52.5204099, 'lon': 13.3677085***REMOVED***,
  {'lat': 52.5204104, 'lon': 13.3676495***REMOVED***,
  {'lat': 52.5206084, 'lon': 13.3679925***REMOVED***,
  {'lat': 52.5206114, 'lon': 13.3679974***REMOVED***,
  {'lat': 52.5206187, 'lon': 13.3680081***REMOVED***,
  {'lat': 52.5206179, 'lon': 13.3680836***REMOVED***,
  {'lat': 52.5206187, 'lon': 13.3687223***REMOVED***,
  {'lat': 52.5204767, 'lon': 13.3687249***REMOVED***,
  {'lat': 52.5204758, 'lon': 13.3688658***REMOVED***,
  {'lat': 52.5206182, 'lon': 13.3688652***REMOVED***,
  {'lat': 52.5206176, 'lon': 13.3693935***REMOVED***,
  {'lat': 52.5204761, 'lon': 13.3693966***REMOVED***,
  {'lat': 52.5204768, 'lon': 13.3695387***REMOVED***,
  {'lat': 52.5206174, 'lon': 13.3695316***REMOVED***,
  {'lat': 52.5206179, 'lon': 13.3706762***REMOVED***,
  {'lat': 52.52047, 'lon': 13.3706844***REMOVED***,
  {'lat': 52.52047, 'lon': 13.370648***REMOVED***,
  {'lat': 52.5204065, 'lon': 13.3706481***REMOVED***,
  {'lat': 52.5204063, 'lon': 13.3695382***REMOVED***,
  {'lat': 52.5202293, 'lon': 13.3695436***REMOVED***,
  {'lat': 52.5200722, 'lon': 13.3695426***REMOVED***,
  {'lat': 52.5199124, 'lon': 13.3695358***REMOVED***,
  {'lat': 52.5199138, 'lon': 13.3706514***REMOVED***,
  {'lat': 52.5198519, 'lon': 13.3706515***REMOVED***,
  {'lat': 52.5198519, 'lon': 13.3706825***REMOVED***,
  {'lat': 52.5197022, 'lon': 13.3706828***REMOVED***,
  {'lat': 52.5197014, 'lon': 13.369536***REMOVED***,
  {'lat': 52.5198416, 'lon': 13.3695358***REMOVED***,
  {'lat': 52.5198412, 'lon': 13.3693948***REMOVED***,
  {'lat': 52.519701, 'lon': 13.3693986***REMOVED***,
  {'lat': 52.5197007, 'lon': 13.3688791***REMOVED***,
  {'lat': 52.5198481, 'lon': 13.3688788***REMOVED***,
  {'lat': 52.5198479, 'lon': 13.3687133***REMOVED***,
  {'lat': 52.519705, 'lon': 13.3687135***REMOVED***,
  {'lat': 52.5197032, 'lon': 13.3660429***REMOVED***,
  {'lat': 52.5197021, 'lon': 13.3656432***REMOVED***,
  {'lat': 52.5198057, 'lon': 13.366007***REMOVED***,
  {'lat': 52.5199159, 'lon': 13.3663634***REMOVED***,
  {'lat': 52.5199159, 'lon': 13.3665685***REMOVED***,
  {'lat': 52.5199161, 'lon': 13.3671573***REMOVED***,
  {'lat': 52.519914, 'lon': 13.3687215***REMOVED***,
  {'lat': 52.5201746, 'lon': 13.3687225***REMOVED***,
  {'lat': 52.5204094, 'lon': 13.3687217***REMOVED***
];

class DemoVisitedHousesService extends AbstractVisitedHousesService {
  List<VisitedHouse> visitedHouses = [
    VisitedHouse(1, 52.52014, 13.36911,
        s1.map((e) => LatLng(e['lat'] ?? 0.0, e['lon'] ?? 0)).toList(), [
      VisitedHouseEvent(
          1,
          'Willy-Brandt-Straße 1, Tiergarten, Mitte, Berlin, 10557',
          "Westfluegel",
          12,
          DateTime(2021, 7, 16))
    ]),
    VisitedHouse(2, 52.4964133, 13.3617511, [], [
      VisitedHouseEvent(2, 'Potsdamer Straße 143, 10783 Berlin', '', 12,
          DateTime(2021, 7, 17))
    ]),
    VisitedHouse(3, 52.5065, 13.35125, [], [
      VisitedHouseEvent(
          3,
          'Klingelhöferstraße 8,Botschaftsviertel, Tiergarten, Mitte, Berlin, 10785',
          'Haupteingang',
          11,
          DateTime(2021, 7, 19))
    ])
  ];
  var maxId = 3;

  DemoVisitedHousesService(
      AbstractUserService userService, GeoService geoService)
      : super(userService, geoService, DemoBackend()) {
    localBuildingMap = {for (VisitedHouse v in visitedHouses) v.osmId: v***REMOVED***
  ***REMOVED***

  @override
  Future<VisitedHouse> createVisitedHouse(VisitedHouse house) {
    house.visitationEvents.last.id = maxId;
    maxId += 1;
    //visitedHouses.add(VisitedHouse.clone(house));
    return Future.value(house);
  ***REMOVED***

  @override
  Future<List<VisitedHouse>> loadVisitedHouses() => Future.value(visitedHouses);
***REMOVED***
