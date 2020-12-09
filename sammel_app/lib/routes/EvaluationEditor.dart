import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:quiver/strings.dart';
import 'package:sammel_app/model/Evaluation.dart';
import 'package:sammel_app/model/Ort.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/model/TerminDetails.dart';
import 'package:sammel_app/model/User.dart';
import 'package:sammel_app/services/StammdatenService.dart';
import 'package:sammel_app/services/UserService.dart';
import 'package:sammel_app/shared/ChronoHelfer.dart';
import 'package:sammel_app/shared/DweTheme.dart';
import 'package:sammel_app/shared/LocationPicker.dart';
import 'package:sammel_app/shared/showMultipleDatePicker.dart';
import 'package:sammel_app/shared/showTimeRangePicker.dart';
import 'package:sammel_app/shared/showUsernameDialog.dart';

import 'VenueDialog.dart';

enum ValidationState { not_validated, error, ok }

class EvaluationData {
  //  TODO
  // expand
  int unterschriften = 0;
  int teilnehmende = 0;
  double stunden = 0.0;
  String kommentar = '';
  String erkenntnisse = '';

  EvaluationData();
  var validated = {
    'unterschriften': ValidationState.not_validated,
    'teilnehmende': ValidationState.not_validated,
    'stunden': ValidationState.not_validated,
    'kommentar': ValidationState.not_validated,
    'erkenntnisse': ValidationState.not_validated,
    'finish_pressed': false
  };
}

// ignore: must_be_immutable
class EvaluationEditor extends StatefulWidget {
  Function onFinish;

  EvaluationEditor({this.onFinish, Key key}) : super(key: key) {
    if (onFinish == null) onFinish = (Evaluation _) {}; // TODO unclear if this is necessary or what it does
  }

  @override
  EvaluationEditorState createState() => EvaluationEditorState();
}

class EvaluationEditorState extends State<EvaluationEditor> {
  EvaluationData evaluation = EvaluationData();

  EvaluationEditorState() : super();

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
                          'Ergebnis',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        InputButton(
                            onTap: unterschriftenSelection,
                            child: unterschriftenButtonCaption(this.evaluation)),
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
                              'Teilnehmer:innen',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            InputButton(
                                onTap: teilnehmendeSelection,
                                child: teilnehmendeButtonCaption(this.evaluation)),
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
                            ),
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
                              'Anmerkung',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            InputButton(
                                onTap: kommentarSelection,
                                child: kommentarButtonCaption(this.evaluation)),
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
                              'Erkenntnisse',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            InputButton(
                                onTap: erkenntnisseSelection,
                                child: erkenntnisseButtonCaption(this.evaluation)),
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
                child: Text('Abbrechen'),
                onPressed: () {
                  setState(() => evaluation = EvaluationData());
                  Navigator.maybePop(context);
                }),
            RaisedButton(
                key: Key('evaluation editor finish button'),
                child: Text('Fertig'),
                onPressed: () => finishPressed())
          ]),
        ));
  }

  static Widget motivationText = Column(key: Key('motivation text'), children: [
    Text(
      'Erzähl uns, was ihr erreicht habt! \n',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    Text(
      'Deine Evaluierung hilft Deinem Kiez-Team, die effektivsten Sammelaktionen zu erkennen. Außerdem können andere Teams von euren Erfahrungen lernen.',
      textScaleFactor: 1.0,
    )
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
        Text(description),
        SizedBox(height: 10),
        input_field
      ]));
    } else {
      input_widget = input_field;
    }

    Widget cancelButton = FlatButton(
      child: Text("Abbrechen"),
      onPressed: () {
        Navigator.pop(context, current_value);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Fertig"),
      onPressed: () {
        Navigator.pop(context, current_input);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      key: key,
      title: Text(title),
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
            Text(description),
            SizedBox(height: 10),
            input_field
          ]));
    } else {
      input_widget = input_field;
    }

    Widget cancelButton = FlatButton(
      child: Text("Abbrechen"),
      onPressed: () {
        Navigator.pop(context, current_value);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Fertig"),
      onPressed: () {
        Navigator.pop(context, current_input);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      key: key,
      title: Text(title),
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
    var ergebnis = await showNumberInputDialog( // should be number input
        this.evaluation.unterschriften.toString(),
        'Anzahl Unterschriften',
        'Wie viele Unterschriften habt ihr gesammelt?',
        Key('unterschriften input dialog'));
    setState(() {
      this.evaluation.unterschriften = int.tryParse(ergebnis) ?? this.evaluation.unterschriften;
      validateAllInput();
    });
  }

  Widget unterschriftenButtonCaption(EvaluationData evaluation) {
    Text text;
    if (this.evaluation.validated['unterschriften'] == ValidationState.ok) {
      text = Text('${evaluation.unterschriften} Unterschriften');
    } else {
      text = Text('Wie viel habt ihr gesammelt?',
          style: TextStyle(color: DweTheme.purple));
    }
    return build_text_row(text, this.evaluation.validated['unterschriften']);
  }

  void teilnehmendeSelection() async {
    var ergebnis = await showNumberInputDialog( // should be number input
        this.evaluation.teilnehmende.toString(),
        'Anzahl Teilnehmende',
        'Wie viele Leute haben mitgemacht?',
        Key('teilnehmende input dialog'));
    setState(() {
      this.evaluation.teilnehmende = int.tryParse(ergebnis) ?? this.evaluation.unterschriften;
      validateAllInput();
    });
  }

  Widget teilnehmendeButtonCaption(EvaluationData evaluation) {
    Text text;
    if (this.evaluation.validated['unterschriften'] == ValidationState.ok) {
      text = Text('${evaluation.teilnehmende} Teilnehmer:innen');
    } else {
      text = Text('Wie viele haben mitgemacht?',
          style: TextStyle(color: DweTheme.purple));
    }
    return build_text_row(text, this.evaluation.validated['teilnehmende']);
  }

  void stundenSelection() async {
    var ergebnis = await showNumberInputDialog( // should be number input
        this.evaluation.stunden.toString(),
        'Wie viele Stunden wart ihr sammeln?',
        'Auf die nächste halbe Stunde gerundet',
        Key('stunden input dialog'));
    setState(() {
      this.evaluation.stunden = double.tryParse(ergebnis) ?? this.evaluation.stunden;
      validateAllInput();
    });
  }

  Widget stundenButtonCaption(EvaluationData evaluation) {
    Text text;
    if (this.evaluation.validated['stunden'] == ValidationState.ok) {
      text = Text('${evaluation.stunden} Stunden');
    } else {
      text = Text('Wie viele Stunden habt ihr gesammelt?',
          style: TextStyle(color: DweTheme.purple));
    }
    return build_text_row(text, this.evaluation.validated['stunden']);
  }

  void kommentarSelection() async {
    var ergebnis = await showTextInputDialog( // should be number input
        this.evaluation.kommentar,
        'Kommentar',
        'Optional: Anmerkung zu den Daten?',
        Key('kommentar input dialog'));
    setState(() {
      this.evaluation.kommentar = ergebnis;
      validateAllInput();
    });
  }

  Widget kommentarButtonCaption(EvaluationData evaluation) {
    Text text;
    if (this.evaluation.validated['kommentar'] == ValidationState.ok) {
      text = Text('Anmerkung: ${evaluation.kommentar}');
    } else {
      text = Text('Optional: Muss man noch etwas zu den obigen Daten wissen?',
          style: TextStyle(color: DweTheme.purple));
    }
    return build_text_row(text, this.evaluation.validated['kommentar']);
  }

  void erkenntnisseSelection() async {
    var ergebnis = await showTextInputDialog( // should be number input
        this.evaluation.erkenntnisse.toString(),
        'erkenntnisse',
        'Was habt ihr gelernt? Was hat gut, was hat nicht so gut funktioniert? Was würdet ihr gerne mit anderen Sammel-Teams teilen?',
        Key('erkenntnisse input dialog'));
    setState(() {
      this.evaluation.erkenntnisse = ergebnis;
      validateAllInput();
    });
  }

  Widget erkenntnisseButtonCaption(EvaluationData evaluation) {
    Text text;
    if (this.evaluation.validated['erkenntnisse'] == ValidationState.ok) {
      text = Text('Erkenntnisse: ${evaluation.erkenntnisse}');
    } else {
      text = Text('Optional: Was habt ihr gelernt?',
          style: TextStyle(color: DweTheme.purple));
    }
    return build_text_row(text, this.evaluation.validated['erkenntnisse']);
  }

  void validateAllInput() {
    validateInt(evaluation.unterschriften, 'unterschriften');
    validateInt(evaluation.teilnehmende, 'teilnehmende');
    validateInt(evaluation.stunden, 'stunden');

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
    this.evaluation.validated[name] =
    (field != null && field is int && field > 0)
        ? ValidationState.ok
        : ValidationState.error;
  }

  finishPressed() async {
    setState(() {
      evaluation.validated['finish_pressed'] = true;
      validateAllInput();
    });
    if (evaluation.validated['all'] == ValidationState.ok) {
      var name =
          (await Provider.of<AbstractUserService>(context).user.first).name;
      if (isBlank(name)) {
        var name = await showUsernameDialog(context: context);
        if (name == null) return;
      }
      validateAllInput();
      if (evaluation.validated['all'] == ValidationState.ok) {
        widget.onFinish(evaluation);
        setState(() => evaluation = EvaluationData()); // reset Form for next use
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
