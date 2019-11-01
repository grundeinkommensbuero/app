import 'package:flutter/material.dart';
import 'package:sammel_app/routes/TerminCard.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/services/ServiceProvider.dart';

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
  static final _termineService = ServiceProvider.termineService();
  List<Termin> termine = [];

  _TermineSeiteState() {
    ladeTermine();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Memory-Leak beheben
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
            child: ListView.builder(
                itemCount: termine.length,
                itemBuilder: (context, index) => ListTile(
                    title: TerminCard(termine[index]),
                    contentPadding: EdgeInsets.only(bottom: 0.1)))));
  }

  void ladeTermine() {
    _termineService.ladeTermine().then((termine) {
      setState(() {
        this.termine = termine;
      });
    });
  }
}
