import 'package:angel_auth/angel_auth.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';
import 'package:angel_static/angel_static.dart';
import 'package:auth/auth.dart';
import 'package:file/local.dart';
import 'package:logging/logging.dart';

main() async {
  var app = Angel();

  // Note: the `secureCookies` flag is important during development,
  // IF you are using cookies.
  //
  // `localhost` cannot use `Secure` cookies, if it's not over HTTPS, which it often isn't.
  var auth = AngelAuth<User>(
      jwtKey: 'abcdefghijklmnopqrstuvwxyz012345',
      secureCookies: app.isProduction);

  var fs = LocalFileSystem();

  /// Using a `CachingVirtualDirectory` can improve page load times.
  var vDir = CachingVirtualDirectory(app, fs, source: fs.directory('web'));

  var users = [
    User('thosakwe', 'foobar'),
    User('angel-dart', 'framework'),
  ];

  // Add functions to (de)serialize a user for the purposes of representation within a token.
  // In a real application, instead of serializing the user itself, you can just return its ID,
  // and when deserializing, perform a database lookup.
  auth.serializer = (u) => u.serialize();
  auth.deserializer = (serialized) => User.deserialize(serialized.toString());

  // Tell the authenticator how to validate a username+password auth attempt.
  // Return `null` on a failed attempt.
  auth.strategies['pw'] = LocalAuthStrategy((username, password) {
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

  // In addition, already logged in users should be sent home when they try log in again.
  app.get('/login.html', (req, res) {
    if (req.container.has<User>()) {
      res.redirect('/');
    } else {
      return true;
    }
  });

  // Create a /login POST endpoint; it'll log a user in, and redirect to /secret.html.
  app.post(
    '/login',
    auth.authenticate(
      'pw',
      AngelAuthOptions<User>(successRedirect: '/secret.html'),
    ),
  );

  // The rest of the interface consists of static files; serve them.
  app.fallback(vDir.handleRequest);
  app.fallback((req, res) => throw AngelHttpException.notFound());

  // Error handling.
  var oldHandler = app.errorHandler;

  app.errorHandler = (e, req, res) {
    if (e.statusCode == 401) {
      return res.redirect('/login.html');
    } else if (e.statusCode == 403) {
      return res.redirect('/forbidden.html');
    } else {
      if (e.statusCode == 500) print('Fatal: ${e.error}\n${e.stackTrace}');
      return oldHandler(e, req, res);
    }
  };

  // Add logging.
  app.logger = Logger('example')
    ..onRecord.listen((rec) {
      print(rec);
      if (rec.error != null) print(rec.error);
      if (rec.stackTrace != null) print(rec.stackTrace);
    });

  // Mount the server.
  var http = AngelHttp(app);
  await http.startServer('127.0.0.1', 3000);
  print('Listening at http://127.0.0.1:3000');
}
