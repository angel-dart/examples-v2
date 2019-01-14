import 'dart:convert';
import 'dart:typed_data';
import 'package:angel_serialize/angel_serialize.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'user.dart';
part 'message.g.dart';

@Serializable(autoIdAndDateFields: false)
abstract class _Message {
  @required
  User get user;

  Uint8List get imageBytes;

  String get text;

  DateTime get timestamp;
}
