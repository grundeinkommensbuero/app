const Mode mode = Mode.DEMO;

// Debug
const bool pullMode = false;
const bool clearButton = false;

enum Mode { LOCAL, DEMO, TEST, PROD }

get demoMode => mode == Mode.DEMO;

get localMode => mode == Mode.LOCAL;

String get host => hostMap[mode]!;

int get port => portMap[mode]!;

String get topicPrefix => topicPrefixMap[mode]!;

const String appAuth = 'MTpiOTdjNzU5Ny1mNjY5LTRmZWItOWJhMi0zMjE0YzE4MjIzMzk=';
const String prodKey = 'Produktiv-Verschüsselungs-Key goes here';

const geo = GeoProperties(
    boundLatMin: 52.324702,
    boundLatMax: 52.670823,
    boundLongMin: 13.126562,
    boundLongMax: 13.752095,
    zoomMin: 10.0,
    zoomMax: 18.0,
    initCenterLat: 52.5170365,
    initCenterLong: 13.3888599,
    initZoom: 12.0);

const hostMap = {
  Mode.DEMO: 'none',
  Mode.LOCAL: '10.0.2.2',
  Mode.TEST: 'dwe.idash.org',
  Mode.PROD: 'dwenteignen.party',
};

const portMap = {
  Mode.DEMO: -1,
  Mode.LOCAL: 18443,
  Mode.TEST: 443,
  Mode.PROD: 443,
};

const topicPrefixMap = {
  Mode.DEMO: 'demo.',
  Mode.LOCAL: 'local.',
  Mode.TEST: 'test.',
  Mode.PROD: '',
};

class GeoProperties {
  final double boundLatMin;
  final double boundLatMax;
  final double boundLongMin;
  final double boundLongMax;
  final double zoomMin;
  final double zoomMax;
  final double initCenterLat;
  final double initCenterLong;
  final double initZoom;

  const GeoProperties(
      {required this.boundLatMin,
      required this.boundLatMax,
      required this.boundLongMin,
      required this.boundLongMax,
      required this.zoomMin,
      required this.zoomMax,
      required this.initCenterLat,
      required this.initCenterLong,
      required this.initZoom});
}
