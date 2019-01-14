import 'dart:convert';
import 'dart:typed_data';
import 'package:angel_serialize/angel_serialize.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
part 'user.g.dart';

@Serializable(autoIdAndDateFields: false)
abstract class _User {
  @required
  String get name;

  @required
  Uint8List get avatarBytes;
}
