import 'package:angel_websocket/browser.dart';
import 'package:angular/angular.dart';
import 'chat_component.dart';

@Component(
    selector: 'chat-app',
    templateUrl: 'chat_app_component.html',
    directives: [ChatComponent, NgIf])
class ChatAppComponent implements OnInit {
  final WebSockets app;
  var loading = true, errored = false;

  ChatAppComponent(this.app);

  @override
  void ngOnInit() {
    app.connect().then((_) {
      loading = false;
    }).catchError((error) {
      print(error);
      errored = true;
    });
  }
}
