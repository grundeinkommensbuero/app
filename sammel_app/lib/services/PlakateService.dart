import 'package:sammel_app/model/Placcard.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/UserService.dart';

abstract class AbstractPlakateService extends BackendService {
  AbstractPlakateService(AbstractUserService userService, Backend backend)
      : super(userService, backend);

  Future<List<Placcard>> loadPlaccards();

  Placcard createPlaccard(Placcard placcard);

  deletePlaccard(int id);
***REMOVED***

class PlakateService extends AbstractPlakateService {
  PlakateService(AbstractUserService userService, Backend backend)
      : super(userService, backend) {***REMOVED***

  @override
  Placcard createPlaccard(Placcard placcard) {
    // TODO: implement createPlaccard
    throw UnimplementedError();
  ***REMOVED***

  @override
  deletePlaccard(int id) {
    // TODO: implement deletePlaccard
    throw UnimplementedError();
  ***REMOVED***

  @override
  Future<List<Placcard>> loadPlaccards() {
    // TODO: implement loadPlaccards
    throw UnimplementedError();
  ***REMOVED***
***REMOVED***

class DemoPlakateService extends AbstractPlakateService {
  DemoPlakateService(AbstractUserService userService, Backend backend)
      : super(userService, backend) {***REMOVED***

  @override
  Placcard createPlaccard(Placcard placcard) {
    // TODO: implement createPlaccard
    throw UnimplementedError();
  ***REMOVED***

  @override
  deletePlaccard(int id) {
    // TODO: implement deletePlaccard
    throw UnimplementedError();
  ***REMOVED***

  @override
  Future<List<Placcard>> loadPlaccards() {
    // TODO: implement loadPlaccards
    throw UnimplementedError();
  ***REMOVED***
***REMOVED***
