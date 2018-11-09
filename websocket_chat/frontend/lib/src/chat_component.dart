import 'package:angular/angular.dart';
import 'user_list_component.dart';

@Component(
    selector: 'x-chat',
    templateUrl: 'chat_component.html',
    directives: [UserListComponent])
class ChatComponent {}
