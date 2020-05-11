import 'package:http_server/http_server.dart';
import 'package:sammel_app/model/ListLocation.dart';

import 'RestFehler.dart';
import 'BackendService.dart';

abstract class AbstractListLocationService extends BackendService {
  Future<List<ListLocation>> getActiveListLocations();

  AbstractListLocationService([Backend backendMock]) : super(backendMock);
}

class ListLocationService extends AbstractListLocationService {
  List<ListLocation> cache;

  ListLocationService([Backend backendMock]) : super(backendMock);

  @override
  Future<List<ListLocation>> getActiveListLocations() async {
    if (cache != null) return cache;
    HttpClientResponseBody response =
        await get('/service/listlocations/actives');
    if (response.response.statusCode == 200) {
      final listLocations = (response.body as List)
          .map((jsonListLocation) => ListLocation.fromJson(jsonListLocation))
          .toList();
      cache = listLocations;
      return listLocations;
    } else {
      throw RestFehler("Unerwarteter Fehler: "
          "${response.response.statusCode} - ${response.body}");
    }
  }
}

class DemoListLocationService extends AbstractListLocationService {
  DemoListLocationService() : super(DemoBackend());
  List<ListLocation> listLocations = [
    ListLocation('1', 'Curry 36', 'Mehringdamm', '36', 52.4935584, 13.3877282),
    ListLocation(
        '2', 'Café Kotti', 'Adalbertstraße', '96', 52.5001477, 13.4181523),
    ListLocation('3', 'Zukunft', 'Laskerstraße', '5', 52.5016524, 13.4655402),
  ];

  @override
  Future<List<ListLocation>> getActiveListLocations() async {
    return listLocations;
  }
}
