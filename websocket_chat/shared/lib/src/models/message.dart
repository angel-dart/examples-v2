import 'package:angel_model/angel_model.dart';
import 'package:angel_serialize/angel_serialize.dart';
import 'package:angel_validate/angel_validate.dart';
import 'package:meta/meta.dart';
import 'user.dart';
part 'message.g.dart';
part 'message.serializer.g.dart';

final messageValidator = Validator({
  requireField(MessageFields.userId): isNonEmptyString,
  MessageFields.image: [
    requiredWithout([MessageFields.text]),
  ],
  MessageFields.text: [
    requiredWithout([MessageFields.image]),
  ],
});

@serializable
abstract class _Message extends Model {
  @required
  String get userId;

  @required
  String get text;

  String get image;

  User get user;
}
