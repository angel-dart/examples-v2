import 'package:angel_production/angel_production.dart';
import 'package:backend/backend.dart' as backend;

main() async {
  var runner = Runner('websocket_chat', backend.configureServer);
  return await runner.run(['-j1']);
}
