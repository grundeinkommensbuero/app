import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sammel_app/model/Evaluation.dart';
import 'package:sammel_app/shared/DweTheme.dart';

enum ValidationState { not_validated, error, ok }

class Option<T1, T2> {
  final T1 text;
  final T2 value;

  Option(this.text, this.value);
}

class EvaluationData {
  int unterschriften = 0;
  int bewertung = 0;
  double stunden = 0.0;
  String kommentar = '';
  String situation = '';

  EvaluationData();

  var validated = {
    'unterschriften': ValidationState.not_validated,
    'bewertung': ValidationState.not_validated,
    'stunden': ValidationState.not_validated,
    'kommentar': ValidationState.ok,
    'situation': ValidationState.ok,
    'finish_pressed': false
  };
}

// ignore: must_be_immutable
class EvaluationForm extends StatefulWidget {
  Function onFinish;
  int terminId;

  EvaluationForm({this.onFinish, Key key, this.terminId}) : super(key: key) {
    if (onFinish == null) onFinish = (_) {};
  }

  @override
  EvaluationFormState createState() => EvaluationFormState(this.terminId);
}

class EvaluationFormState extends State<EvaluationForm> {
  int terminId;
  EvaluationData evaluation = EvaluationData();

  EvaluationFormState(this.terminId) : super();

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
                motivationText,
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

  static Widget motivationText = Column(key: Key('motivation text'), children: [
    Text(
      'Erzähl uns, was ihr erreicht habt! \n',
      style: TextStyle(fontWeight: FontWeight.bold),
    ).tr(),
    Text(
      'Deine Rückmeldung hilft Deinem Kiez-Team, die effektivsten Sammelaktionen zu erkennen. Außerdem können andere Teams von euren Erfahrungen lernen.',
      textScaleFactor: 1.0,
    ).tr()
  ]);

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

  Future<String> showNumberInputDialog(
      String current_value, String title, String description, Key key) {
    String current_input = current_value;
    TextFormField input_field = TextFormField(
      initialValue: current_value ?? '',
      keyboardType: TextInputType.number,
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

    // set up the AlertDialog

    // show the dialog
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              key: key,
              title: Text(title).tr(),
              content: input_widget,
              actions: [
                FlatButton(
                  child: Text("Abbrechen").tr(),
                  onPressed: () {
                    Navigator.pop(context, current_value);
                  },
                ),
                FlatButton(
                  child: Text("Fertig").tr(),
                  onPressed: () {
                    Navigator.pop(context, current_input);
                  },
                ),
              ],
            ));
  }

  Future<String> showRadioInputDialog(String current_value, String title,
      String description, List<Option<String, String>> options, Key key) {
    String current_input = current_value;
    current_input = 'One';

    void _onValueChange(String value) {
      setState(() {
        current_input = value;
      });
    }

    MyRadioInput input_field = new MyRadioInput(
      onValueChange: _onValueChange,
      initialValue: current_input,
      options: options,
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

  void unterschriftenSelection() async {
    var ergebnis = await showNumberInputDialog(
        // should be number input
        this.evaluation.unterschriften.toString(),
        'Anzahl Deiner Unterschriften',
        'Wie viele Unterschriften hast Du persönlich gesammelt?',
        Key('unterschriften input dialog'));
    setState(() {
      this.evaluation.unterschriften =
          int.tryParse(ergebnis) ?? this.evaluation.unterschriften;
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
        this.evaluation.bewertung.toString(),
        'Spaßfaktor',
        'Wie fandest Du die Aktion?',
        [
          Option('sehr cool', '5'),
          Option('gut', '4'),
          Option('ganz okay', '3'),
          Option('mäßig', '2'),
          Option('doof', '1')
        ],
        Key('bewertung input dialog'));
    setState(() {
      this.evaluation.bewertung =
          int.tryParse(ergebnis) ?? this.evaluation.bewertung;
      validateAllInput();
    });
  }

  Widget bewertungButtonCaption(EvaluationData evaluation) {
    Text text;
    if (this.evaluation.validated['bewertung'] == ValidationState.ok) {
      text = Text('${evaluation.bewertung}').tr();
    } else {
      text = Text('Wie fandest Du die Aktion?',
              style: TextStyle(color: DweTheme.purple))
          .tr();
    }
    return build_text_row(text, this.evaluation.validated['bewertung']);
  }

  void stundenSelection() async {
    var ergebnis = await showNumberInputDialog(
        // should be number input
        this.evaluation.stunden.toString(),
        'Wie viele Stunden warst Du sammeln?',
        'Auf die nächste halbe Stunde gerundet',
        Key('stunden input dialog'));
    setState(() {
      this.evaluation.stunden =
          double.tryParse(ergebnis) ?? this.evaluation.stunden;
      validateAllInput();
    });
  }

  Widget stundenButtonCaption(EvaluationData evaluation) {
    Text text;
    if (this.evaluation.validated['stunden'] == ValidationState.ok) {
      text = Text('{} Stunden').plural(evaluation.stunden);
    } else {
      text = Text('Wie viele Stunden habt ihr gesammelt?',
              style: TextStyle(color: DweTheme.purple))
          .tr();
    }
    return build_text_row(text, this.evaluation.validated['stunden']);
  }

  void kommentarSelection() async {
    var ergebnis = await showTextInputDialog(
        // should be number input
        this.evaluation.kommentar,
        'Kommentar',
        'Optional: Sonstige Anmerkungen zu den Daten?',
        Key('kommentar input dialog'));
    setState(() {
      this.evaluation.kommentar = ergebnis;
      validateAllInput();
    });
  }

  Widget kommentarButtonCaption(EvaluationData evaluation) {
    Text text;
    if (this.evaluation.kommentar != '') {
      text = Text('Anmerkungen: ${evaluation.kommentar}').tr();
    } else {
      text = Text('Optional: Muss man noch etwas zu den obigen Daten wissen?',
              style: TextStyle(color: DweTheme.purple))
          .tr();
    }
    return build_text_row(text, this.evaluation.validated['kommentar']);
  }

  void situationSelection() async {
    var ergebnis = await showTextInputDialog(
        // should be number input
        this.evaluation.situation.toString(),
        'Situation',
        'Wie war die Situation? (Wetter, Veranstaltung in der Nähe, besonderer Anlass, ...)',
        Key('situation input dialog'));
    setState(() {
      this.evaluation.situation = ergebnis;
      validateAllInput();
    });
  }

  Widget situationButtonCaption(EvaluationData evaluation) {
    Text text;
    if (this.evaluation.situation != '') {
      text = Text('Situation: ${evaluation.situation}').tr();
    } else {
      text = Text('Optional: Wie war die Situation?',
              style: TextStyle(color: DweTheme.purple))
          .tr();
    }
    return build_text_row(text, this.evaluation.validated['situation']);
  }

  void validateAllInput() {
    validateInt(evaluation.unterschriften, 'unterschriften');
    validateInt(evaluation.bewertung, 'bewertung');
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

  void validateDouble(field, name) {
    this.evaluation.validated[name] =
        (field != null && field is double && field > 0)
            ? ValidationState.ok
            : ValidationState.error;
  }

  void validateInt(field, name) {
    this.evaluation.validated[name] = (field != null && field is int)
        ? ValidationState.ok
        : ValidationState.error;
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
            this.terminId,
            evaluation.unterschriften,
            evaluation.bewertung,
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

class MyRadioInput extends StatefulWidget {
  const MyRadioInput({this.onValueChange, this.initialValue, this.options});

  final String initialValue;
  final void Function(String) onValueChange;
  final List<Option<String, String>> options;

  State createState() => new MyRadioInputState();
}

class MyRadioInputState extends State<MyRadioInput> {
  String _selectedValue;
  List<Option<String, String>> options;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  Widget build(BuildContext context) {
    return new Column(
        children: widget.options.map((option) {
      print('building children');
      return RadioListTile<String>(
        title: Text(option.text).tr(),
        value: option.value,
        groupValue: _selectedValue,
        onChanged: (String value) {
          setState(() {
            _selectedValue = value;
          });
          widget.onValueChange(value);
        },
      );
    }).toList());
  }
}
