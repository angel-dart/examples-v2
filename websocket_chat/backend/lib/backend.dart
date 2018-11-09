import 'dart:async';
import 'dart:io';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_proxy/angel_proxy.dart';
import 'package:angel_static/angel_static.dart';
import 'package:angel_websocket/server.dart';
import 'package:file/local.dart';
import 'package:http/io_client.dart' as http;
import 'package:path/path.dart' as p;
import 'package:shared/shared.dart';

Future configureServer(Angel app) async {
  // Initialize a WebSocket driver.
  var driver = new AngelWebSocket(app);
  await app.configure(driver.configureServer);

  // Listen for WebSocket connections...
  app.get('/ws', driver.handleRequest);

  // Create in-memory stores to store our messages and users.
  var userService =
      new MapService().map(UserSerializer.fromMap, UserSerializer.toMap);
  var messageService =
      new MapService().map(MessageSerializer.fromMap, MessageSerializer.toMap);

  // In development, proxy to `pub run build_runner serve`.
  if (!app.isProduction) {
    var proxy = Proxy(
      http.IOClient(),
      Uri.parse('http://localhost:8080'),
      recoverFrom404: false,
      recoverFromDead: false,
    );
    app.fallback(proxy.handleRequest);
  } else {
    // In production, serve our built assets from frontend/build/web.
    var fs = const LocalFileSystem();
    var assetPath = p.join(
        p.dirname(p.fromUri(Platform.script)), // root/backend/bin
        '..', // root/backend
        '..', // root,
        'frontend',
        'build',
        'web');
    var assetDir = fs.directory(assetPath);
    var vDir = CachingVirtualDirectory(app, fs, source: assetDir);
    app.fallback(vDir.handleRequest);
  }

  // Throw a 404 if no file matched.
  app.fallback((req, res) => throw AngelHttpException.notFound());

  // When a WebSocket connects, listen to it...
  driver.onConnection.listen((socket) {
    // Listen for when the user tries to register a new account.
    socket.on['register'].listen((data) async {
      // Validate the map, imperative-style. Then deserialize it.
      var user = UserSerializer.fromMap(userValidator.enforce(data));

      // Try to find an existing user. If there is, just return that user.
      try {
        user = await userService.findOne({
          'query': {
            UserFields.name: user.name,
          }
        });
      } on AngelHttpException {
        // If the lookup returns empty, a notFound exception is thrown.
        // In this case, just create and send back a new user.
        user = await userService.create(user);
      }

      // Broadcast to all users that someone has just joined.
      driver.batchEvent(WebSocketEvent(eventName: 'new_user', data: user));

      // Finally, just fire an event that the client should listen for.
      // This is how the client will know when they have entered the chat.
      socket.send('registered', user);
    });

    // Listen for when a message is sent.
    socket.on['message'].listen((data) async {
      // Deserialize/validate the message.
      var message = MessageSerializer.fromMap(messageValidator.enforce(data));

      // We want to broadcast the message. But, we want clients to know who sent the message.
      // We need to query our store for the corresponding user.
      //
      // Note that this query will throw if the user does not exist, which is logical behavior.
      message = message.copyWith(
        user: await userService.read(message.id),
      );

      // Insert the message into the store.
      message = await messageService.create(message);

      // Broadcast to all users.
      driver
          .batchEvent(WebSocketEvent(eventName: 'new_message', data: message));
    });

    // Lastly, listen for when the client wants a list of all messages.
    socket.on['fetch_messages'].listen((_) async {
      // Fetch the list of messages, and send it back in a separate event.
      socket.send('fetched_messages', await messageService.index());
    });
  });
}
