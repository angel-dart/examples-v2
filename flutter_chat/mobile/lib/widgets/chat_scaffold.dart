import 'dart:async';
import 'package:angel_websocket/flutter.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';

class ChatScaffold extends StatefulWidget {
  final WebSockets app;

  const ChatScaffold({Key key, @required this.app}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatScaffoldState();
}

class _ChatScaffoldState extends State<ChatScaffold> {
  var messages = <Message>[];
  var users = Set<User>();
  var _subs = <StreamSubscription>[];

  @override
  void initState() {
    super.initState();

    // Listen for an incoming message
    _subs.add(widget.app.on['message'].listen((data) {}));

    // Listen for when the server sends the message list
    _subs.add(widget.app.on['messages'].listen((data) {}));

    // Listen for when a user joins the room
    _subs.add(widget.app.on['user_joined'].listen((data) {}));

    // Listen for when a user leaves the room
    _subs.add(widget.app.on['user_left'].listen((data) {}));

    // Listen for when the server sends the user list
    _subs.add(widget.app.on['users'].listen((data) {}));
  }

  @override
  void deactivate() {
    _subs.forEach((s) => s.cancel());
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Angel + Flutter'),
      ),
    );
  }
}
