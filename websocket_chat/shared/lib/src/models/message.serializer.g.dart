// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// SerializerGenerator
// **************************************************************************

abstract class MessageSerializer {
  static Message fromMap(Map map) {
    if (map['user_id'] == null) {
      throw new FormatException("Missing required field 'user_id' on Message.");
    }

    if (map['text'] == null) {
      throw new FormatException("Missing required field 'text' on Message.");
    }

    return new Message(
        id: map['id'] as String,
        userId: map['user_id'] as String,
        text: map['text'] as String,
        image: map['image'] as String,
        user: map['user'] != null
            ? UserSerializer.fromMap(map['user'] as Map)
            : null,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        updatedAt: map['updated_at'] != null
            ? (map['updated_at'] is DateTime
                ? (map['updated_at'] as DateTime)
                : DateTime.parse(map['updated_at'].toString()))
            : null);
  }

  static Map<String, dynamic> toMap(Message model) {
    if (model == null) {
      return null;
    }
    if (model.userId == null) {
      throw new FormatException("Missing required field 'user_id' on Message.");
    }

    if (model.text == null) {
      throw new FormatException("Missing required field 'text' on Message.");
    }

    return {
      'id': model.id,
      'user_id': model.userId,
      'text': model.text,
      'image': model.image,
      'user': UserSerializer.toMap(model.user),
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String()
    };
  }
}

abstract class MessageFields {
  static const List<String> allFields = const <String>[
    id,
    userId,
    text,
    image,
    user,
    createdAt,
    updatedAt
  ];

  static const String id = 'id';

  static const String userId = 'user_id';

  static const String text = 'text';

  static const String image = 'image';

  static const String user = 'user';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';
}
