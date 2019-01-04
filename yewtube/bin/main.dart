import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';
import 'package:logging/logging.dart';
import 'package:yewtube/yewtube.dart' as yewtube;

main() async {
  var app = Angel(), http = AngelHttp(app);
  app.logger = Logger('yewtube')
    ..onRecord.listen((rec) {
      print(rec);
      if (rec.error != null) print(rec.error);
      if (rec.stackTrace != null) print(rec.stackTrace);
    });

  await app.configure(yewtube.configureServer);
  await http.startServer('127.0.0.1', 3000);
  print('Yewtube listening at ${http.uri}');
}
