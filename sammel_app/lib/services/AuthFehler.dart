import 'package:sammel_app/services/RestFehler.dart';

class AuthFehler extends RestFehler {
  String reason;

  AuthFehler(String reason) : super(reason);

  AuthFehler.fromJson(Map<String, dynamic> json) : super.fromJson(json);
***REMOVED***
