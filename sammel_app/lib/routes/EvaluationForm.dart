import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:sammel_app/model/Evaluation.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/shared/DweTheme.dart';

enum ValidationState { not_validated, error, ok }

const ratingOptions = {
  'sehr cool': 5,
  'gut': 4,
  'ganz okay': 3,
  'mäßig': 2,
  'doof': 1
};

class EvaluationData {
  int teilnehmer;
  int unterschriften;
  String bewertung;
  double stunden;
  String kommentar = '';
  String situation = '';
  bool ausgefallen = false;

  EvaluationData();

  var validated = {
    'teilnehmer': ValidationState.ok,
    'unterschriften': ValidationState.not_validated,
    'bewertung': ValidationState.not_validated,
    'stunden': ValidationState.ok,
    'kommentar': ValidationState.ok,
    'situation': ValidationState.ok,
    'finish_pressed': false
  };
}

// ignore: must_be_immutable
class EvaluationForm extends StatefulWidget {
  Function onFinish;
  final Termin action;

  EvaluationForm(this.action, {this.onFinish, Key key}) : super(key: key) {
    if (onFinish == null) onFinish = (_) {};
  }

  @override
  EvaluationFormState createState() => EvaluationFormState(this.action);
}

class EvaluationFormState extends State<EvaluationForm> {
  EvaluationData evaluation = EvaluationData();

  EvaluationFormState(Termin action) : super() {
    evaluation.teilnehmer = action.participants.length;
    evaluation.stunden =
        action.ende.difference(action.beginn).inHours.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: Container(
          decoration: BoxDecoration(color: DweTheme.yellowLight),
          child: ListView(
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 15.0, bottom: 50.0),
              children: <Widget>[
                motivationText(),
                SizedBox(height: 15),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(Icons.info_outline, size: 40.0),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                          'Anzahl Teilnehmer*innen',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ).tr(),
                        InputButton(
                            onTap: teilnehmerSelection,
                            child: teilnehmerButtonCaption(this.evaluation)),
                      ]))
                ]),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(Icons.info_outline, size: 40.0),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                          'Anzahl Unterschriften',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ).tr(),
                        InputButton(
                            onTap: unterschriftenSelection,
                            child:
                                unterschriftenButtonCaption(this.evaluation)),
                      ]))
                ]),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(Icons.info_outline, size: 40.0),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                          'Spaßfaktor',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ).tr(),
                        InputButton(
                            onTap: bewertungSelection,
                            child: bewertungButtonCaption(this.evaluation)),
                      ]))
                ]),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(Icons.info_outline, size: 40.0),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                          'Dauer',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ).tr(),
                        InputButton(
                            onTap: stundenSelection,
                            child: stundenButtonCaption(this.evaluation)),
                      ]))
                ]),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(Icons.info_outline, size: 40.0),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                          'Situation',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ).tr(),
                        InputButton(
                            onTap: situationSelection,
                            child: situationButtonCaption(this.evaluation)),
                      ]))
                ]),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(Icons.info_outline, size: 40.0),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                          'Anmerkungen',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ).tr(),
                        InputButton(
                            onTap: kommentarSelection,
                            child: kommentarButtonCaption(this.evaluation)),
                      ]))
                ]),
              ]),
        ),
        bottomSheet: Container(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(blurRadius: 5.0, color: Colors.black38)],
              color: DweTheme.yellow),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            RaisedButton(
                key: Key('evaluation editor cancel button'),
                child: Text('Abbrechen').tr(),
                onPressed: () {
                  setState(() => evaluation = EvaluationData());
                  Navigator.maybePop(context);
                }),
            RaisedButton(
                key: Key('evaluation editor finish button'),
                child: Text('Fertig').tr(),
                onPressed: () => finishPressed())
          ]),
        ));
  }

  static Widget motivationText() {
    return Column(key: Key('motivation text'), children: [
      Text(
        'Erzähl uns, was ihr erreicht habt! \n',
        style: TextStyle(fontWeight: FontWeight.bold),
      ).tr(),
      Text(
        'Deine Rückmeldung hilft Deinem Kiez-Team, die effektivsten Sammelaktionen zu erkennen. Außerdem können andere Teams von euren Erfahrungen lernen.',
        textScaleFactor: 1.0,
      ).tr()
    ]);
  }

  Future<String> showTextInputDialog(
      String current_value, String title, String description, Key key) {
    String current_input = current_value;
    TextFormField input_field = TextFormField(
      minLines: 3,
      initialValue: current_value,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
      ),
      onChanged: (current_input_) {
        current_input = current_input_;
      },
    );

    Widget input_widget;

    if (description != null) {
      input_widget = SingleChildScrollView(
          child: ListBody(children: [
        Text(description).tr(),
        SizedBox(height: 10),
        input_field
      ]));
    } else {
      input_widget = input_field;
    }

    Widget cancelButton = FlatButton(
      child: Text("Abbrechen").tr(),
      onPressed: () {
        Navigator.pop(context, current_value);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Fertig").tr(),
      onPressed: () {
        Navigator.pop(context, current_input);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      key: key,
      title: Text(title).tr(),
      content: input_widget,
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<String> showRadioInputDialog(
      String init, String title, String description, Key key) {
    String value = init;

    // show the dialog
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setDialogState) {
                Widget input = Column(
                    children: ratingOptions.keys
                        .map((option) => RadioListTile(
                              title: Text(option).tr(),
                              value: option,
                              groupValue: value,
                              onChanged: (selection) =>
                                  setDialogState(() => value = selection),
                            ))
                        .toList());

                if (description != null)
                  input = SingleChildScrollView(
                      child: ListBody(children: [
                    Text(description).tr(),
                    SizedBox(height: 10),
                    input
                  ]));

                return AlertDialog(
                  key: key,
                  title: Text(title).tr(),
                  content: input,
                  actions: [
                    FlatButton(
                      child: Text("Abbrechen").tr(),
                      onPressed: () => Navigator.pop(context, init),
                    ),
                    FlatButton(
                      child: Text("Fertig").tr(),
                      onPressed: () => Navigator.pop(context, value),
                    ),
                  ],
                );
              },
            ));
  }

  void teilnehmerSelection() async {
    var ergebnis = await showIntegerInputDialog(
        context,
        // should be number input
        this.evaluation.teilnehmer,
        'Anzahl Teilnehmer*innen',
        'Wie viele Leute waren bei der Aktion dabei?',
        Key('teilnehmer input dialog'));
    setState(() {
      this.evaluation.teilnehmer = ergebnis ?? this.evaluation.teilnehmer;
      validateAllInput();
    });
  }

  Widget teilnehmerButtonCaption(EvaluationData evaluation) {
    Text text;
    if (this.evaluation.validated['teilnehmer'] == ValidationState.ok) {
      text = Text('{} Teilnehmer').plural(evaluation.teilnehmer ?? 0);
    } else {
      text = Text('Wie viele Leute haben teilgenommen?',
              style: TextStyle(color: DweTheme.purple))
          .tr();
    }
    return build_text_row(text, this.evaluation.validated['teilnehmer']);
  }

  void unterschriftenSelection() async {
    var ergebnis = await showIntegerInputDialog(
        context,
        this.evaluation.unterschriften,
        'Anzahl Deiner Unterschriften',
        'Wie viele Unterschriften hast Du persönlich gesammelt?',
        Key('unterschriften input dialog'));
    setState(() {
      this.evaluation.unterschriften = ergebnis ?? this.evaluation.unterschriften;
      validateAllInput();
    });
  }

  Widget unterschriftenButtonCaption(EvaluationData evaluation) {
    Text text;
    if (this.evaluation.validated['unterschriften'] == ValidationState.ok) {
      text = Text('{} Unterschriften').plural(evaluation.unterschriften);
    } else {
      text = Text('Wie viel hast Du gesammelt?',
              style: TextStyle(color: DweTheme.purple))
          .tr();
    }
    return build_text_row(text, this.evaluation.validated['unterschriften']);
  }

  void bewertungSelection() async {
    var ergebnis = await showRadioInputDialog(
        this.evaluation.bewertung,
        'Spaßfaktor',
        'Wie fandest Du die Aktion?',
        Key('bewertung input dialog'));
    setState(() {
      this.evaluation.bewertung = ergebnis;
      validateAllInput();
    });
  }

  Widget bewertungButtonCaption(EvaluationData evaluation) {
    Text text;
    if (this.evaluation.validated['bewertung'] == ValidationState.ok) {
      text = Text(evaluation.bewertung).tr();
    } else {
      text = Text('Wie fandest Du die Aktion?',
              style: TextStyle(color: DweTheme.purple))
          .tr();
    }
    return build_text_row(text, this.evaluation.validated['bewertung']);
  }

  void stundenSelection() async {
    var ergebnis = await showIntegerInputDialog(
        context,
        // should be number input
        this.evaluation.stunden.round(),
        'Wie viele Stunden warst Du sammeln?',
        'Auf die nächste Stunde gerundet',
        Key('stunden input dialog'));
    setState(() {
      this.evaluation.stunden = ergebnis?.toDouble() ?? this.evaluation.stunden;
      validateAllInput();
    });
  }

  Widget stundenButtonCaption(EvaluationData evaluation) {
    Text text;
    if (this.evaluation.validated['stunden'] == ValidationState.ok) {
      text = Text('{} Stunden').plural(evaluation.stunden ?? 0);
    } else {
      text = Text('Wie viele Stunden habt ihr gesammelt?',
              style: TextStyle(color: DweTheme.purple))
          .tr();
    }
    return build_text_row(text, this.evaluation.validated['stunden']);
  }

  void kommentarSelection() async {
    var ergebnis = await showTextInputDialog(
        this.evaluation.kommentar,
        'Kommentar',
        'Optional: Sonstige Anmerkungen zu den Daten?',
        Key('kommentar input dialog'));
    setState(() {
      this.evaluation.kommentar = ergebnis ?? this.evaluation.kommentar;
      validateAllInput();
    });
  }

  Widget kommentarButtonCaption(EvaluationData evaluation) {
    Text text;
    if (this.evaluation.kommentar != '') {
      text = Text(evaluation.kommentar);
    } else {
      text = Text('Optional: Muss man noch etwas zu den Angaben wissen?',
              style: TextStyle(color: DweTheme.purple))
          .tr();
    }
    return build_text_row(text, this.evaluation.validated['kommentar']);
  }

  void situationSelection() async {
    var ergebnis = await showTextInputDialog(
        this.evaluation.situation,
        'Situation',
        'Wie war die Situation? (Wetter, Veranstaltung in der Nähe, besonderer Anlass, ...)',
        Key('situation input dialog'));
    setState(() {
      this.evaluation.situation = ergebnis ?? this.evaluation.situation;
      validateAllInput();
    });
  }

  Widget situationButtonCaption(EvaluationData evaluation) {
    Text text;
    if (this.evaluation.situation != '') {
      text = Text(evaluation.situation);
    } else {
      text = Text('Optional: Wie war die Situation?',
              style: TextStyle(color: DweTheme.purple))
          .tr();
    }
    return build_text_row(text, this.evaluation.validated['situation']);
  }

  void validateAllInput() {
    validateInt(evaluation.unterschriften, 'unterschriften');
    validateString(evaluation.bewertung, 'bewertung');
    validateDouble(evaluation.stunden, 'stunden');

    evaluation.validated['all'] = ValidationState.ok;
    for (var value in evaluation.validated.values) {
      if (value == ValidationState.error ||
          value == ValidationState.not_validated) {
        evaluation.validated['all'] = ValidationState.error;
        break;
      }
    }
  }

  void validateDouble(double field, name) {
    this.evaluation.validated[name] = (field != null && field > 0)
        ? ValidationState.ok
        : ValidationState.error;
  }

  void validateString(String field, name) {
    this.evaluation.validated[name] = field != null && field.isNotEmpty
        ? ValidationState.ok
        : ValidationState.error;
  }

  void validateInt(int field, name) {
    this.evaluation.validated[name] =
        field != null ? ValidationState.ok : ValidationState.error;
  }

  finishPressed() async {
    setState(() {
      evaluation.validated['finish_pressed'] = true;
      validateAllInput();
    });
    if (evaluation.validated['all'] == ValidationState.ok) {
      validateAllInput();
      if (evaluation.validated['all'] == ValidationState.ok) {
        widget.onFinish(Evaluation(
            widget.action.id,
            evaluation.teilnehmer,
            evaluation.unterschriften,
            ratingOptions[evaluation.bewertung],
            evaluation.stunden,
            evaluation.kommentar,
            evaluation
                .situation)); // maybe the Evaluation/EvaluationData two-tap is superfluous here
        setState(
            () => evaluation = EvaluationData()); // reset Form for next use
      }
    }
  }

  Row build_text_row(Text text, ValidationState valState) {
    List<Widget> w = [Flexible(child: text)];
    if (evaluation.validated['finish_pressed']) {
      if (valState == ValidationState.ok) {
        w.add(Icon(Icons.done, color: Colors.black));
      } else {
        w.add(Icon(Icons.error_outline));
      }
    }
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: w);
  }
}

class InputButton extends StatelessWidget {
  final Function onTap;
  final Widget child;
  final Key key;

  InputButton({this.onTap, this.child, this.key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
            padding: EdgeInsets.only(bottom: 8.0, top: 4.0),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.keyboard_arrow_right, size: 15),
              SizedBox(width: 5),
              Expanded(child: child),
            ])),
        onTap: onTap);
  }
}

Future<int> showIntegerInputDialog(
    BuildContext context, int init, String title, String description, Key key) {
  var controller = TextEditingController(text: init?.toString() ?? '');
  Widget content = Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Flexible(
        child: TextButton(
            child: Icon(Icons.remove_circle_outline),
            onPressed: () {
              final number = int.tryParse(controller.text);
              if (number == null) return;
              if (number < 1)
                return;
              else
                controller.text = (number - 1).toString();
            })),
    Flexible(
        child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 100.0, minWidth: 50.0),
            child: TextFormField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.center,
              controller: controller,
              onTap: () => controller.selection = TextSelection(
                  baseOffset: 0, extentOffset: controller.text.length),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
              // onChanged: (newValue) => controller.text = newValue,
            ))),
    Flexible(
        child: TextButton(
            child: Icon(Icons.add_circle_outline),
            onPressed: () {
              final number = int.tryParse(controller.text);
              if (number == null)
                controller.text = '1';
              else
                controller.text = (number + 1).toString();
            })),
  ]);

  if (description != null) {
    content = SingleChildScrollView(
        child: ListBody(
            children: [Text(description).tr(), SizedBox(height: 10), content]));
  }

  // show the dialog
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            key: key,
            title: Text(title).tr(),
            content: content,
            actions: [
              FlatButton(
                child: Text("Abbrechen").tr(),
                onPressed: () {
                  Navigator.pop(context, init);
                },
              ),
              FlatButton(
                child: Text("Fertig").tr(),
                onPressed: () {
                  Navigator.pop(context, int.tryParse(controller.text));
                },
              ),
            ],
          ));
}