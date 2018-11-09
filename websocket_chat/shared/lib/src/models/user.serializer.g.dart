// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// SerializerGenerator
// **************************************************************************

abstract class UserSerializer {
  static User fromMap(Map map) {
    if (map['name'] == null) {
      throw new FormatException("Missing required field 'name' on User.");
    }

    if (map['avatar'] == null) {
      throw new FormatException("Missing required field 'avatar' on User.");
    }

    return new User(
        id: map['id'] as String,
        name: map['name'] as String,
        avatar: map['avatar'] as String,
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

  static Map<String, dynamic> toMap(User model) {
    if (model == null) {
      return null;
    }
    if (model.name == null) {
      throw new FormatException("Missing required field 'name' on User.");
    }

    if (model.avatar == null) {
      throw new FormatException("Missing required field 'avatar' on User.");
    }

    return {
      'id': model.id,
      'name': model.name,
      'avatar': model.avatar,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String()
    };
  }
}

abstract class UserFields {
  static const List<String> allFields = const <String>[
    id,
    name,
    avatar,
    createdAt,
    updatedAt
  ];

  static const String id = 'id';

  static const String name = 'name';

  static const String avatar = 'avatar';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';
}
