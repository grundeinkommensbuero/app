import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/ErrorService.dart';
import 'package:sammel_app/services/UserService.dart';

class PushUpdateService extends BackendService {
  PushUpdateService(AbstractUserService userService, Backend backend)
      : super(userService, backend);

  Future<List<Map<String, dynamic>>?> getLatestPushMessages() async {
    try {
      return get('service/push/pull').then((response) =>
              (response.body as List).cast<Map<String, dynamic>>());
    } catch (e, s) {
      ErrorService.handleError(e, s,
          context: "Fehler beim Nachladen von Nachrichten");
    }
  }
}
