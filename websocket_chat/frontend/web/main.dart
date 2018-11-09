import 'package:angel_websocket/browser.dart';
import 'package:angular/angular.dart';
import 'package:frontend/frontend.dart';
import 'main.template.dart' as self;

ComponentRef _app;

@GenerateInjector([
  FactoryProvider(WebSockets, createSocket),
])
final InjectorFactory rootInjector = self.rootInjector$Injector;

WebSockets createSocket() =>
    WebSockets(Uri.base.replace(scheme: 'ws', path: '/ws').toString());

void main() {
  _app = runApp(ChatAppComponentNgFactory);
}

Object host$onDestroy() {
  _app.destroy();
  return null;
}
