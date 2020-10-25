import 'package:http_server/http_server.dart';
import 'package:sammel_app/model/ListLocation.dart';
import 'package:sammel_app/services/ErrorService.dart';

import 'BackendService.dart';

abstract class AbstractListLocationService extends BackendService {
  Future<List<ListLocation>> getActiveListLocations();

  AbstractListLocationService(userService, [Backend backendMock])
      : super(userService, backendMock);
***REMOVED***

class ListLocationService extends AbstractListLocationService {
  List<ListLocation> cache;

  ListLocationService(userService, [Backend backendMock])
      : super(userService, backendMock);

  @override
  Future<List<ListLocation>> getActiveListLocations() async {
    if (cache != null) return cache;
    HttpClientResponseBody response;
    try {
      response = await get('/service/listlocations/actives');
    ***REMOVED*** catch (e) {
      ErrorService.handleError(e);
      return [];
    ***REMOVED***
    final listLocations = (response.body as List)
        .map((jsonListLocation) => ListLocation.fromJson(jsonListLocation))
        .toList();
    cache = listLocations;
    return listLocations;
  ***REMOVED***
***REMOVED***

class DemoListLocationService extends AbstractListLocationService {
  DemoListLocationService(userService) : super(userService, DemoBackend());
  List<ListLocation> listLocations = [
    ListLocation('1', 'Curry 36', 'Mehringdamm', '36', 52.4935584, 13.3877282),
    ListLocation(
        '2', 'Café Kotti', 'Adalbertstraße', '96', 52.5001477, 13.4181523),
    ListLocation('3', 'Zukunft', 'Laskerstraße', '5', 52.5016524, 13.4655402),
  ];

  @override
  Future<List<ListLocation>> getActiveListLocations() async {
    return listLocations;
  ***REMOVED***
***REMOVED***
