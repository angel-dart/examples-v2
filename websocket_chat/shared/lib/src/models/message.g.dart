// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class Message extends _Message {
  Message(
      {this.id,
      @required this.userId,
      @required this.text,
      this.image,
      this.user,
      this.createdAt,
      this.updatedAt});

  @override
  final String id;

  @override
  final String userId;

  @override
  final String text;

  @override
  final String image;

  @override
  final User user;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  Message copyWith(
      {String id,
      String userId,
      String text,
      String image,
      User user,
      DateTime createdAt,
      DateTime updatedAt}) {
    return new Message(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        text: text ?? this.text,
        image: image ?? this.image,
        user: user ?? this.user,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  bool operator ==(other) {
    return other is _Message &&
        other.id == id &&
        other.userId == userId &&
        other.text == text &&
        other.image == image &&
        other.user == user &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return hashObjects([id, userId, text, image, user, createdAt, updatedAt]);
  }

  Map<String, dynamic> toJson() {
    return MessageSerializer.toMap(this);
  }
}
