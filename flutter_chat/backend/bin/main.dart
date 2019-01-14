import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';
import 'package:angel_websocket/server.dart';
import 'package:common/common.dart';
import 'package:logging/logging.dart';

main() async {
  var app = Angel(), http = AngelHttp(app);
  var ws = AngelWebSocket(app, sendErrors: !app.isProduction);

  // Mount the necessary routes
  app.get('/ws', ws.handleRequest);
  app.fallback((req, res) => throw AngelHttpException.notFound());

  // Think of socket.io - this callback is called whenever a client connects.
  //
  // For the sake of this example, assume all data is valid.
  ws.onConnection.listen((socket) {
    var req = socket.request;

    // Let everyone know when the user signs on.
    socket.on['sign_in'].listen((data) {
      if (!req.container.has<User>()) {
        var user = UserSerializer.fromMap(data);
        req.container.registerSingleton(user);
        socket.send('signed_in', user);
        ws.batchEvent(WebSocketEvent(eventName: 'user_joined', data: user));
      }
    });

    // Listen for when the user sends a message, and simply broadcast it to the world.
    socket.on['message'].listen((data) {
      if (req.container.has<User>()) {
        // Make sure they are signed in
        var user = req.container.make<User>();
        var message = MessageSerializer.fromMap(data);

        // Attach user info to the message
        message = message.copyWith(user: user);

        // Broadcast it
        ws.batchEvent(WebSocketEvent(eventName: 'message', data: message));
      }
    });

    // Broadcast an event when the user leaves.
    socket.onClose.listen((_) {
      if (req.container.has<User>()) {
        var user = req.container.make<User>();
        ws.batchEvent(WebSocketEvent(eventName: 'user_left', data: user));
      }
    });
  });

  app.logger = Logger('backend')
    ..onRecord.listen((rec) {
      print(rec);
      if (rec.error != null) print(rec.error);
      if (rec.stackTrace != null) print(rec.stackTrace);
    });

  await http.startServer('127.0.0.1', 3000);
  print('Listening at ${http.uri}');
}
