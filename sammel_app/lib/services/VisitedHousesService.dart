import 'dart:convert';
import 'dart:io';

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

  /*
  deleteVisitedHouse(int id) {
    for(VisitedHouse vh in localBuildingMap.values)
    {
      for(VisitedHouseEvent vhe in vh.visitation_events)
      {
        if(id == vhe.id)
        {
          if(vh.visitation_events.length == 1)
          {
            var res = localBuildingMap.remove(vh.osm_id);
            print(res);
          ***REMOVED***
          else{
            vh.visitation_events.remove(vhe);
          ***REMOVED***
          return;
        ***REMOVED***
      ***REMOVED***
    ***REMOVED***
  ***REMOVED****/

  @override
  Future<VisitedHouse?> getVisitedHouseOfPoint(
      LatLng point, bool check_on_server) async {
    VisitedHouse? vh_of_point = getBuildingForPointLocal(point);
    if (vh_of_point != null) {
      return vh_of_point;
    ***REMOVED***
    if (!check_on_server) {
      return null;
    ***REMOVED***
    Future<List> s_future = geoService.getPolygonAndDescriptionOfPoint(point);
    List s = await s_future;
    GeoData gd = s[1];
    List<LatLng>? shape = s[0];
    var osm_id = s[2];
    if (shape == null) {
      //no shape found take small bbox around point. problem is that we want a box that is drawn as square
      double lat_5m = DistanceHelper.getLatDiffFromM(point, 5.0);
      double lng_5m = DistanceHelper.getLongDiffFromM(point, 15.0);
      shape = [
        LatLng(point.latitude - lat_5m, point.longitude - lng_5m),
        LatLng(point.latitude + lat_5m, point.longitude - lng_5m),
        LatLng(point.latitude + lat_5m, point.longitude + lng_5m),
        LatLng(point.latitude - lat_5m, point.longitude + lng_5m)
      ];
    ***REMOVED***
    if (osm_id == null) {
      //in this case we create the osm id by the center
      osm_id = point.hashCode;
    ***REMOVED***
    return getBuildingFromJson(osm_id, point, gd, shape);
  ***REMOVED***

  VisitedHouse? getBuildingFromJson(
      int osm_id, LatLng point, GeoData geo_data, List<LatLng> shape) {
    if (localBuildingMap.containsKey(osm_id)) {
      return localBuildingMap[osm_id];
    ***REMOVED*** else {
      //TODO: Change to myself here
      return VisitedHouse(osm_id, point.latitude, point.longitude,
          '${geo_data.street***REMOVED*** ${geo_data.number***REMOVED***', shape, []);
    ***REMOVED***
  ***REMOVED***

  VisitedHouseView getBuildingsInArea(BoundingBox bbox) {
    //TODO: it only checks for local buildings atm
    //TODO: take a bit more clever data format
    List<SelectableVisitedHouse> buildings_in_roi = [];
    for (VisitedHouse building in localBuildingMap.values) {
      if (building.bbox.intersect(bbox)) {
        buildings_in_roi.add(SelectableVisitedHouse.fromVisitedHouse(building));
      ***REMOVED***
    ***REMOVED***
    VisitedHouseView vhv = VisitedHouseView(bbox, buildings_in_roi);
    return vhv;
  ***REMOVED***

  VisitedHouse? getBuildingForPointLocal(LatLng point) {
    for (VisitedHouse building in localBuildingMap.values) {
      if (building.bbox.containsPoint(point)) {
        if (building.inside(point)) {
          return building;
        ***REMOVED***
      ***REMOVED***
    ***REMOVED***
    return null;
  ***REMOVED***

  VisitedHouse editVisitedHouse(VisitedHouse house) {
    var add_events = house.visitation_events;
    var delete_events = Set();

    VisitedHouse? building = localBuildingMap[house.osm_id];

    if (building != null) {
      var current_ids = building.visitation_events.map((e) => e.id).toSet();
      var new_ids = house.visitation_events.map((e) => e.id).toSet();
      delete_events = current_ids.difference(new_ids);
      add_events = add_events
          .where((element) => !current_ids.contains(element.id))
          .toList();
    ***REMOVED***
    for (var delete_event in delete_events) {
      deleteVisitedHouse(delete_event);
    ***REMOVED***

    for (var add_event in add_events) {
      VisitedHouse house_with_event_only = VisitedHouse(
          house.osm_id,
          house.latitude,
          house.longitude,
          house.adresse,
          house.shape,
          [add_event]);
      var h = createVisitedHouse(house_with_event_only);
      h.then((value) => add_event.id = value?.visitation_events.last.id);
    ***REMOVED***
    if (house.visitation_events.isNotEmpty) {
      house.visitation_events
          .sort((a, b) => a.datum.difference(b.datum).inSeconds > 0
              ? 1
              : a.datum.difference(b.datum).inSeconds < 0
                  ? -1
                  : 0);
      localBuildingMap[house.osm_id] = house;
    ***REMOVED*** else {
      localBuildingMap.remove(house.osm_id);
    ***REMOVED***

    return house;
  ***REMOVED***

  getAllHouses() {
    return localBuildingMap.values.toList();
  ***REMOVED***

  deleteVisitedHouse(int id) async {***REMOVED***
***REMOVED***

class VisitedHousesService extends AbstractVisitedHousesService {
  late HttpClient httpClient;
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
      VisitedHouse? local_house = localBuildingMap[house.osm_id];
      if (local_house != null) {
        var idx = local_house.visitation_events.indexWhere(
            (element) => element.id == house.visitation_events.first.id);
        if (idx == -1) {
          local_house.visitation_events.add(house.visitation_events.first);
        ***REMOVED*** else {
          local_house.visitation_events[idx] = house.visitation_events.first;
        ***REMOVED***
      ***REMOVED*** else {
        localBuildingMap[house.osm_id] = house;
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
    VisitedHouse(
        1,
        52.52014,
        13.36911,
        'Willy-Brandt-Straße 1, Tiergarten, Mitte, Berlin, 10557',
        s1.map((e) => LatLng(e['lat'] ?? 0.0, e['lon'] ?? 0)).toList(),
        [VisitedHouseEvent(1, "Westfluegel", 12, DateTime(2021, 7, 16))]),
    /*
    VisitedHouse(
        2,
        52.4964133,
        13.3617511,
        'Potsdamer Straße 143, 10783 Berlin',
        null,
        DateTime(2021, 7, 17),
        12,
        ''),
    VisitedHouse(
        3,
        52.5065,
        13.35125,
        'Klingelhöferstraße 8,Botschaftsviertel, Tiergarten, Mitte, Berlin, 10785',
        'Haupteingang',
        DateTime(2021, 7, 19),
        11,
        '')*/
  ];
  var maxId = 10;

  DemoVisitedHousesService(
      AbstractUserService userService, GeoService geoService)
      : super(userService, geoService, DemoBackend()) {
    localBuildingMap = {for (VisitedHouse v in visitedHouses) v.osm_id: v***REMOVED***
  ***REMOVED***

  @override
  Future<VisitedHouse> createVisitedHouse(VisitedHouse house) {
    house.visitation_events.last.id = maxId;
    maxId += 1;
    return Future.value(house);
  ***REMOVED***

  @override
  Future<List<VisitedHouse>> loadVisitedHouses() => Future.value(visitedHouses);
***REMOVED***
