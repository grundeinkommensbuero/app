import 'package:flutter/material.dart';
import 'package:sammel_app/Routes/TermineSeite.dart';
import 'package:sammel_app/services/ServiceProvider.dart';
import '../services/BenutzerService.dart';

class LoginSeite extends StatefulWidget {
  LoginSeite({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginSeiteState createState() => _LoginSeiteState();
}

class _LoginSeiteState extends State<LoginSeite> {
  static const String _REGISTRIEREN = 'Registrieren';
  static const String _ANMELDEN = 'Anmelden';
  static double _padding = 8.0;
  bool _modus = false;
  static final _benutzerService = ServiceProvider.benutzerService();

  static Login _login = Login.ausName('', '');

  static final Widget benutzernameFeld = TextField(
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'Benutzername',
    ),
    onChanged: (inhalt) => _login.benutzer.name = inhalt,
  );

  static final Widget passwortFeld = TextField(
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'Passwort',
    ),
    onChanged: (inhalt) => _login.passwortHash = inhalt,
    obscureText: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            widget.title,
            style: TextStyle(
              color: Color.fromARGB(255, 129, 28, 98),
            ),
          ),
          Image.asset('assets/images/logo.png')
        ],
      )),
      body: Center(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Unterschriften sammeln und enteignen!\nUm diese App zu benutzen, musst du dich mit einem Benutzeraccount registrieren',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20.0,
            ),
            benutzernameFeld,
            SizedBox(
              height: _padding,
            ),
            passwortFeld,
            SizedBox(
              height: _padding,
            ),
            SwitchListTile(
              title: Text('Ich habe bereits einen Account'),
              value: _modus,
              onChanged: (bool hatAccount) => wechsleModus(hatAccount),
            )
          ],
        ),
      ),
      bottomSheet: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          child: Text(_modus ? _ANMELDEN : _REGISTRIEREN),
          color: Colors.amber,
          onPressed: () => _modus ? loginBenutzer() : legeBenutzerAn(),
          padding: EdgeInsets.all(20.0),
        ),
      ),
    );
  }

  wechsleModus(bool hatAccount) {
    setState(() {
      _modus = hatAccount;
    });
  }

  loginBenutzer() async {
    try {
      var authentifiziert =
          await _benutzerService.authentifziereBenutzer(_login);

      if (authentifiziert.erfolgreich) {
        navigiereZuMeldungenSeite();
      } else {
        if (context != null) {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Text("Computer sagt Nein"),
                  content: Text(authentifiziert.meldung),
                );
              });
        }
      }
    } catch (e, s) {
      print('Fehler: $e\n$s'); //TODO LOG
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text("Unerwarteter Fehler"),
              content: Text(e.toString()),
            );
          });
    }
  }

  void navigiereZuMeldungenSeite() {
    Navigator.push(context, MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return TermineSeite(title: 'Termine-Liste');
      },
    ));
  }

  legeBenutzerAn() async {
    try {
      await _benutzerService.legeBenutzerAn(_login);
      navigiereZuMeldungenSeite();
    } on LoginException catch (e) {
      print('Erwarteter Fehler: ${e.message}');
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text("Computer sagt Nein"),
              content: Text(e.message),
            );
          });
    } catch (e, s) {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text("Unerwarteter Fehler"),
              content: Text(e.message),
            );
          });
      print('Unerwarteter Fehler: $e, $s');
    }
  }
}
