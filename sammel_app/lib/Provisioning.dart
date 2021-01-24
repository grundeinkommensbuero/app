const Mode mode = Mode.DEMO;
const version = '0.5.3+25';

// Debug
const bool pullMode = false;
const bool clearButton = false;

enum Mode { LOCAL, DEMO, TEST, PROD }

get demoMode => mode == Mode.DEMO;

get testMode => mode == Mode.TEST;

String get host => hostMap[mode];

int get port => portMap[mode];

String get topicPrefix => topicPrefixMap[mode];

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
