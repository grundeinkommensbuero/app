import 'package:sammel_app/services/BenutzerService.dart';
import 'package:sammel_app/services/ServiceProvider.dart';
import 'package:sammel_app/services/ServiceProvider.dart' as prefix0;
import 'package:sammel_app/services/TermineService.dart';
import 'package:test/test.dart';

void main() {
  // TODO in beiden Modi prüfen
  test('liefert richtigen BenutzerService', () {
    var benutzerService = prefix0.ServiceProvider.benutzerService();
    if (ServiceProvider.DEMOMODUS) {
      expect(benutzerService is DemoBenutzerService, true);
    } else {
      expect(benutzerService is BenutzerService, true);
    }
  });
  test('liefert richtigen TermineService', () {
    var termineService = prefix0.ServiceProvider.termineService();
    if (ServiceProvider.DEMOMODUS) {
      expect(termineService is DemoTermineService, true);
    } else {
      expect(termineService is TermineService, true);
    }
  });
}
