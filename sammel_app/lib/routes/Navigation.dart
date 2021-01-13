import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:sammel_app/model/ChatChannel.dart';
import 'package:sammel_app/model/Termin.dart';
import 'package:sammel_app/routes/ActionEditor.dart';
import 'package:sammel_app/routes/ProfilePage.dart';
import 'package:sammel_app/services/ChatMessageService.dart';
import 'package:sammel_app/services/ErrorService.dart';
import 'package:sammel_app/services/PushSendService.dart';
import 'package:sammel_app/services/StorageService.dart';
import 'package:sammel_app/shared/DweTheme.dart';

import 'ChatPage.dart';
import 'ChatWindow.dart';
import 'FAQ.dart';
import 'TermineSeite.dart';

class Navigation extends StatefulWidget {
  var clearButton = false;
  GlobalKey actionPage;
  var globalChat = null;

  Navigation(this.actionPage, [this.clearButton])
      : super(key: Key('navigation'));

  @override
  State<StatefulWidget> createState() => NavigationState();
***REMOVED***

class NavigationState extends State<Navigation>
    with SingleTickerProviderStateMixin {
  int navigation = 0;
  List<int> history = [];
  AnimationController _animationController;
  Animation<Offset> _slide;
  Animation<double> _fade;
  bool swipeUp = false;
  FAQ faq;
  ChatPage chatPage;
  final int chatPageIndex = 3;
  AbstractPushSendService pushService;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _fade = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    // Error-Service kann am Ende des ersten Builds Dialoge zeigen
    SchedulerBinding.instance
        .addPostFrameCallback((_) => ErrorService.setContext(context));
  ***REMOVED***

  @override
  Widget build(BuildContext context) {
    var pages = [
      TermineSeite(key: widget.actionPage),
      ActionEditor(onFinish: newActionCreated, key: Key('action creator')),
      faq = FAQ(),
      chatPage = ChatPage(),
      ProfilePage()
    ];
    List<String> titles = [
      'Aktionen'.tr(),
      'Zum Sammeln aufrufen'.tr(),
      'Tipps und Argumente'.tr(),
      'News'.tr(),
      'Profil'.tr(),
    ];

    _slide = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, swipeUp ? -0.3 : 0.3),
    ).animate(CurvedAnimation(
      parent: _animationController,
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
          ),
          floatingActionButton: widget.clearButton == true
              ? FloatingActionButton(
                  heroTag: 'clearButtonHero',
                  onPressed: () => Provider.of<StorageService>(context)
                      .clearAllPreferences(),
                  child: Icon(Icons.delete_forever),
                  foregroundColor: Colors.red,
                )
              : null),
    );
  ***REMOVED***

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
                        key: Key('action page navigation button'),
                        title: 'Aktionen'.tr(),
                        subtitle:
                            'Aktionen in einer Liste oder Karte anschauen'.tr(),
                        index: 0),
                    menuEntry(
                        key: Key('action creator navigation button'),
                        title: 'Zum Sammeln einladen'.tr(),
                        subtitle: 'Eine Sammel-Aktion ins Leben rufen'.tr(),
                        index: 1),
                    menuEntry(
                        key: Key('faq navigation button'),
                        title: 'Fragen und Antworten'.tr(),
                        subtitle: 'Tipps, Tricks und Argumentationshilfen'.tr(),
                        index: 2),
                    menuEntry(
                        key: Key('global chat button'),
                        title: 'News'.tr(),
                        subtitle: "Neues vom Volksbegehren und der Kampagne".tr(),
                        index: 3),
                    menuEntry(
                        key: Key('profile navigation button'),
                        title: 'Dein Profil'.tr(),
                        subtitle:
                        'Dein Name, dein Kiez und deine Einstellungen'.tr(),
                        index: 4),

                  ],
                ))));
  ***REMOVED***

  Widget menuEntry(
      {Key key, String title = '', String subtitle = '', int index = 0***REMOVED***) {
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
              ***REMOVED***
              Navigator.pop(context);
            ***REMOVED***));
  ***REMOVED***

  void switchPage(int index) async {
    print("setting state ${index***REMOVED*** ${chatPageIndex***REMOVED*** ${index == chatPageIndex***REMOVED***");
    chatPage.isActive = index == chatPageIndex;
    print(chatPage);
    print("chatpage is active ${chatPage.isActive***REMOVED***");
    setState(() => swipeUp = index > navigation);
    await _animationController.forward();
    setState(() {
      if (navigation == chatPageIndex && index != chatPageIndex)
      {
        Provider.of<ChatMessageService>(context).getTopicChannel("global").then((value) => maybeDispose(value));
      ***REMOVED***
      navigation = index;
      swipeUp = !swipeUp;
    ***REMOVED***);
    await _animationController.reverse();

    primaryFocus.unfocus(); // sonst nimmt man die Tastatur mit
  ***REMOVED***

  newActionCreated(List<Termin> actions) {
    addActionsToActionPage(actions);
    navigateToActionPage();
  ***REMOVED***

  void addActionsToActionPage(List<Termin> actions) {
    actions.forEach((action) =>
        (widget.actionPage.currentState as TermineSeiteState)
            .createAndAddAction(action));
  ***REMOVED***

  Future<bool> navigateBack() async {
    var closeApp = false;
    if (history.isEmpty)
      closeApp = true;
    else {
      switchPage(history.last);
      history.removeLast();
    ***REMOVED***
    return closeApp;
  ***REMOVED***

  void navigateToActionPage() {
    switchPage(0);
    history.removeLast();
  ***REMOVED***

  maybeDispose(TopicChatChannel value) {
    var cls = value.ccl as State<StatefulWidget>;
    if (cls == null)
      {
        return;
      ***REMOVED***
    if(ModalRoute.of(cls?.context)?.settings.name == "/"){
      value.dispose_widget();
    ***REMOVED***
  ***REMOVED***
***REMOVED***
