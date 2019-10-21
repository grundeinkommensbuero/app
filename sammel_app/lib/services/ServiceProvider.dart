import 'package:sammel_app/services/BenutzerService.dart';
import 'package:sammel_app/services/TermineService.dart';

class ServiceProvider {
  static bool DEMOMODUS = true;

  static benutzerService() =>
      DEMOMODUS ? DemoBenutzerService() : BenutzerService();

  static termineService() =>
      DEMOMODUS ? DemoTermineService() : TermineService();
***REMOVED***
