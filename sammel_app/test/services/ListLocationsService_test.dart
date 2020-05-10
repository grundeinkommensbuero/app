
import 'package:flutter_test/flutter_test.dart';
import 'package:sammel_app/model/ListLocation.dart';
import 'package:sammel_app/services/ListLocationService.dart';

import '../TestdataStorage.dart';
import '../shared/Mocks.dart';

  void main() {
  // nöig wegen dem Laden des Zertifikats
  TestWidgetsFlutterBinding.ensureInitialized();
  var service = DemoListLocationService();
  service.client = MockHttpClient();

  test('returns list locations', () async {
    List<ListLocation> result = await service.getActiveListLocations();
    expect(result.length, 3);

    expect(result[0].id, curry36().id);
    expect(result[0].name, curry36().name);
    expect(result[0].street, curry36().street);
    expect(result[0].number, curry36().number);
    expect(result[0].latitude, curry36().latitude);
    expect(result[0].longitude, curry36().longitude);

    expect(result[1].id, cafeKotti().id);
    expect(result[1].name, cafeKotti().name);
    expect(result[1].street, cafeKotti().street);
    expect(result[1].number, cafeKotti().number);
    expect(result[1].latitude, cafeKotti().latitude);
    expect(result[1].longitude, cafeKotti().longitude);

    expect(result[2].id, zukunft().id);
    expect(result[2].name, zukunft().name);
    expect(result[2].street, zukunft().street);
    expect(result[2].number, zukunft().number);
    expect(result[2].latitude, zukunft().latitude);
    expect(result[2].longitude, zukunft().longitude);
  ***REMOVED***);
***REMOVED***