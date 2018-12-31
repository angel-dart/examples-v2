import 'package:angel_auth/angel_auth.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';
import 'package:angel_static/angel_static.dart';
import 'package:auth/auth.dart';
import 'package:file/local.dart';

main() async {
  var app = new Angel();
  var auth = new AngelAuth<User>(jwtKey: 'abcdefghijklmnopqrstuvwxyz012345');
  var fs = const LocalFileSystem();
  var vDir = new VirtualDirectory(app, fs, source: fs.directory('web'));
  var users = [
    new User('thosakwe', 'foobar'),
    new User('angel-dart', 'framework'),
  ];

  // Add functions to (de)serialize a user for the purposes of representation within a token.
  // In a real application, instead of serializing the user itself, you can just return its ID,
  // and when deserializing, perform a database lookup.
  auth.serializer = (u) => u.serialize();
  auth.deserializer =
      (serialized) => new User.deserialize(serialized.toString());

  // Tell the authenticator how to validate a username+password auth attempt.
  // Return `null` on a failed attempt.
  auth.strategies['pw'] = new LocalAuthStrategy((username, password) {
    var user = users.firstWhere((u) => u.username == username);
    return user.validate(password) ? user : null;
  });

  // On every request, allow the authenticator to try to parse a JWT.
  // If it succeeds, a `User` instance will be injected into the request container.
  app.fallback(auth.decodeJwt);

  // Only authenticated users can access /secret.html.
  //
  // Place an auth guard in front of it, to deny guests from
  // viewing critical content.
  app.get('/secret.html', requireAuthentication<User>());

  // Create a /login POST endpoint; it'll log a user in, and redirect to /secret.html.
  app.post(
    '/login',
    auth.authenticate(
      'pw',
      new AngelAuthOptions<User>(successRedirect: '/secret.html'),
    ),
  );

  // The rest of the interface consists of static files; serve them.
  app.fallback(vDir.handleRequest);

  // Error handling.
  var oldHandler = app.errorHandler;

  app.errorHandler = (e, req, res) {
    if (e.statusCode == 403) {
      res.redirect('/forbidden.html');
    } else {
      if (e.statusCode == 500) print('Fatal: ${e.error}\n${e.stackTrace}');
      return oldHandler(e, req, res);
    }
  };

  // Mount the server.
  var http = new AngelHttp(app);
  await http.startServer('127.0.0.1', 3000);
  print('Listening at http://127.0.0.1:3000');
}
