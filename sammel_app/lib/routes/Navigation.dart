import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/routes/ActionEditor.dart';
import 'package:sammel_app/shared/DweTheme.dart';

import 'TermineSeite.dart';

class Navigation extends StatefulWidget {
  Navigation() : super(key: Key('navigation'));

  @override
  State<StatefulWidget> createState() => NavigationState();
}

class NavigationState extends State<Navigation>
    with SingleTickerProviderStateMixin {
  int navigation = 0;
  List<int> history = [];
  GlobalKey actionPage = GlobalKey(debugLabel: 'action page');
  AnimationController _controller;
  Animation<Offset> _slide;
  Animation<double> _fade;
  bool swipeUp = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _fade = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
  }

  @override
  Widget build(BuildContext context) {
    var pages = [
      TermineSeite(key: actionPage),
      ActionEditor(onFinish: newActionCreated, key: Key('action creator'))
    ];
    List<String> titles = ['Aktionen', 'Zum Sammeln aufrufen'];

    _slide = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, swipeUp ? -0.3 : 0.3),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    return WillPopScope(
      onWillPop: () => navigateBack(),
      child: Scaffold(
          drawerScrimColor: Colors.black26,
          drawer: buildDrawer(),
          appBar: AppBar(
              title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(titles[navigation]),
              Image.asset('assets/images/logo.png', width: 50.0)
            ],
          )),
          body: Container(
            color: DweTheme.yellowLight,
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                  position: _slide,
                  child: IndexedStack(children: pages, index: navigation)),
            ),
          )),
    );
  }

  SizedBox buildDrawer() {
    return SizedBox(
        width: 200.0,
        child: Drawer(
            child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.5, 1.0],
                    colors: <Color>[DweTheme.yellow, Colors.yellowAccent],
                  ),
                ),
                child: ListView(
                  padding:
                      EdgeInsets.symmetric(vertical: 40.0, horizontal: 0.0),
                  children: <Widget>[
                    Image.asset("assets/images/dwe.png"),
                    SizedBox(
                      height: 25.0,
                    ),
                    menuEntry(
                        key: Key('action page button'),
                        title: 'Aktionen',
                        subtitle:
                            'Aktionen in einer Liste oder Karte anschauen',
                        index: 0),
                    menuEntry(
                        key: Key('action creator button'),
                        title: 'Zum Sammeln einladen',
                        subtitle: 'Eine Sammel-Aktion ins Leben rufen',
                        index: 1),
                    menuEntry(
                        title: 'Fragen und Antworten',
                        subtitle: 'Tipps, Tricks und Argumentationshilfen',
                        index: 0),
                  ],
                ))));
  }

  Container menuEntry(
      {Key key, String title = '', String subtitle = '', int index = 0}) {
    var selected = navigation == index;
    return Container(
        key: key,
        padding: EdgeInsets.symmetric(vertical: selected ? 15.0 : 10.0),
        decoration: BoxDecoration(
            color: selected ? DweTheme.purple : Colors.transparent),
        child: ListTile(
            title: Text(
              title,
              style: selected
                  ? DweTheme.menuCaptionSelected
                  : DweTheme.menuCaption,
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(color: selected ? Colors.amber : Colors.black54),
            ),
            onTap: () {
              if (navigation != index) {
                history.add(navigation);
                switchPage(index);
              }
              Navigator.pop(context);
            }));
  }

  void switchPage(int index) async {
    await setState(() => swipeUp = index > navigation);
    await _controller.forward();
    await setState(() {
      navigation = index;
      swipeUp = !swipeUp;
    });
    await _controller.reverse();
  }

  newActionCreated(List<Termin> actions) {
    addActionsToActionPage(actions);
    navigateToActionPage();
  }

  void addActionsToActionPage(List<Termin> actions) {
    actions.forEach((action) => (actionPage.currentState as TermineSeiteState)
        .createAndAddAction(actions[0]));
  }

  Future<bool> navigateBack() async {
    var closeApp = false;
    if (history.isEmpty)
      closeApp = true;
    else {
      switchPage(history.last);
      history.removeLast();
    }
    return closeApp;
  }

  void navigateToActionPage() {
    switchPage(0);
    history.removeLast();
  }
}
