import 'package:angel_model/angel_model.dart';
import 'package:angel_serialize/angel_serialize.dart';
import 'package:angel_validate/angel_validate.dart';
import 'package:meta/meta.dart';
part 'user.g.dart';
part 'user.serializer.g.dart';

final userValidator = Validator({
  requireFields([UserFields.name, UserFields.avatar]): isNonEmptyString,
});

@serializable
abstract class _User extends Model {
  @required
  String get name;

  @required
  String get avatar;
}
