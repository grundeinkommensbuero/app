const Mode mode = Mode.DEMO;

// Debug
const bool pullMode = false;
const bool clearButton = false;

enum Mode { LOCAL, DEMO, TEST, PROD }

get demoMode => mode == Mode.DEMO;

get localMode => mode == Mode.LOCAL;

String get host => hostMap[mode];

int get port => portMap[mode];

String get topicPrefix => topicPrefixMap[mode];

const String appAuth = 'MTpiOTdjNzU5Ny1mNjY5LTRmZWItOWJhMi0zMjE0YzE4MjIzMzk=';
const String prodKey = 'Produktiv-Verschüsselungs-Key goes here';

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
