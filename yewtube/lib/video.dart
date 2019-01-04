import 'package:angel_model/angel_model.dart';
import 'package:angel_serialize/angel_serialize.dart';
part 'video.g.dart';

@serializable
abstract class _Video extends Model {
  String get title;

  String get description;

  String get filePath;

  String get mimeType;
}
