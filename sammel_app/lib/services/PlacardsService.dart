import 'dart:convert';
import 'dart:math';

import 'package:http_server/http_server.dart';
import 'package:sammel_app/model/Placard.dart';
import 'package:sammel_app/services/BackendService.dart';
import 'package:sammel_app/services/UserService.dart';

import 'ErrorService.dart';

abstract class AbstractPlacardsService extends BackendService {
  AbstractPlacardsService(AbstractUserService userService, Backend backend)
      : super(userService, backend);

  Future<List<Placard>> loadPlacards();

  Future<Placard?> createPlacard(Placard placard);

  deletePlacard(int id);

  takeDownPlacard(int id);
}

class PlacardsService extends AbstractPlacardsService {
  PlacardsService(AbstractUserService userService, Backend backend)
      : super(userService, backend);

  @override
  Future<Placard?> createPlacard(Placard placard) async {
    try {
      var response = await post('service/plakate/neu', jsonEncode(placard));
      return Placard.fromJson(response.body);
    } catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Eintragen von Plakat ist fehlgeschlagen.');
    }
  }

  @override
  deletePlacard(int id) async {
    try {
      return await delete('service/plakate/$id');
    } catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Löschen von Plakat ist fehlgeschlagen.');
    }
  }

  @override
  Future<List<Placard>> loadPlacards() async {
    HttpClientResponseBody response;
    final placards;
    try {
      response = await get('service/plakate');
      placards = (response.body as List)
          .map((jsonListLocation) => Placard.fromJson(jsonListLocation))
          .toList();
    } catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Plakate konnten nicht geladen werden.');
      return [];
    }
    return placards;
  }

  @override
  takeDownPlacard(int id) async {
    try {
      return await post('service/plakate/abgehangen/$id', jsonEncode({}));
    } catch (e, s) {
      ErrorService.handleError(e, s,
          context: 'Abhängen von Plakat ist fehlgeschlagen.');
    }
  }
}

class DemoPlacardsService extends AbstractPlacardsService {
  DemoPlacardsService(AbstractUserService userService)
      : super(userService, DemoBackend());
  List<Placard> placards = [
    Placard(1, 52.4722460, 13.3277830, '12161, Friedrich-Wilhelm-Platz 57', 11,
        false),
    Placard(2, 52.47102, 13.3282, "12161, Bundesallee 76", 12, false),
    Placard(3, 52.4709, 13.32744, "12161, Goßlerstraße 29", 13, false)
  ];

  @override
  Future<Placard> createPlacard(Placard placard) {
    if (placard.id == null || placard.id == 0) {
      var maxId = placards
          .map((p) => p.id)
          .fold(0, (int? v, int? e) => max(v!, e == null ? 0 : e));
      placard.id = maxId + 1;
    }
    placards.add(placard);
    return Future.value(placard);
  }

  @override
  deletePlacard(int id) {
    if (!placards.map((e) => e.id).contains(id)) return;

    var placard = placards.firstWhere((pl) => pl.id == id);
    placards.remove(placard);
  }

  @override
  Future<List<Placard>> loadPlacards() => Future.value(placards);

  @override
  takeDownPlacard(int id) {
    var placard = placards.where((placard) => placard.id == id).first;
    placard.abgehangen = true;

    return placard;
  }
}
