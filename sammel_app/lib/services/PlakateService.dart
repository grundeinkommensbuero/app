import 'package:sammel_app/model/Placcard.dart';
import 'package:sammel_app/services/BackendService.dart';


abstract class AbstractPlakateService extends BackendService {
  AbstractPlakateService(Backend backend): super(backend);

  Future<List<Placcard>> loadPlaccards();

}