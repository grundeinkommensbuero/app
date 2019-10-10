import 'package:flutter/material.dart';
import 'package:sammel_app/Routes/TerminCard.dart';
import 'package:sammel_app/model/Termin.dart';
import '../services/TermineService.dart';

class TermineSeite extends StatefulWidget {
  TermineSeite({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TermineSeiteState createState() => _TermineSeiteState();
}

class _TermineSeiteState extends State<TermineSeite> {
  static final TextStyle style = TextStyle(
    color: Color.fromARGB(255, 129, 28, 98),
    fontSize: 15.0,
  );
  static final _termineService = TermineService();
  List<Termin> termine = [];

  @override
  Widget build(BuildContext context) {
    // TODO: Memory-Leak beheben
    ladeTermine();
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
                children:
                    termine.map((termin) => TerminCard(termin)).toList())));
  }

  void ladeTermine() {
    _termineService.ladeTermine().then((termine) {
      setState(() {
        this.termine = termine;
      });
    });
  }
}
