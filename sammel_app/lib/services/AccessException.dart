import 'package:sammel_app/services/RestFehler.dart';

class AccessException extends RestFehler {
  AccessException(String message) : super(message);

  AccessException.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}
