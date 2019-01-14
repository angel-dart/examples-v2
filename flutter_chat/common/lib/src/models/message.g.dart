// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class Message implements _Message {
  const Message(
      {@required this.user, this.imageBytes, this.text, this.timestamp});

  @override
  final User user;

  @override
  final Uint8List imageBytes;

  @override
  final String text;

  @override
  final DateTime timestamp;

  Message copyWith(
      {User user, Uint8List imageBytes, String text, DateTime timestamp}) {
    return new Message(
        user: user ?? this.user,
        imageBytes: imageBytes ?? this.imageBytes,
        text: text ?? this.text,
        timestamp: timestamp ?? this.timestamp);
  }

  bool operator ==(other) {
    return other is _Message &&
        other.user == user &&
        const ListEquality().equals(other.imageBytes, imageBytes) &&
        other.text == text &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return hashObjects([user, imageBytes, text, timestamp]);
  }

  Map<String, dynamic> toJson() {
    return MessageSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

abstract class MessageSerializer {
  static Message fromMap(Map map) {
    if (map['user'] == null) {
      throw new FormatException("Missing required field 'user' on Message.");
    }

    return new Message(
        user: map['user'] != null
            ? UserSerializer.fromMap(map['user'] as Map)
            : null,
        imageBytes: map['image_bytes'] is Uint8List
            ? (map['image_bytes'] as Uint8List)
            : (map['image_bytes'] is Iterable<int>
                ? new Uint8List.fromList(
                    (map['image_bytes'] as Iterable<int>).toList())
                : (map['image_bytes'] is String
                    ? new Uint8List.fromList(
                        base64.decode(map['image_bytes'] as String))
                    : null)),
        text: map['text'] as String,
        timestamp: map['timestamp'] != null
            ? (map['timestamp'] is DateTime
                ? (map['timestamp'] as DateTime)
                : DateTime.parse(map['timestamp'].toString()))
            : null);
  }

  static Map<String, dynamic> toMap(_Message model) {
    if (model == null) {
      return null;
    }
    if (model.user == null) {
      throw new FormatException("Missing required field 'user' on Message.");
    }

    return {
      'user': UserSerializer.toMap(model.user),
      'image_bytes':
          model.imageBytes == null ? null : base64.encode(model.imageBytes),
      'text': model.text,
      'timestamp': model.timestamp?.toIso8601String()
    };
  }
}

abstract class MessageFields {
  static const List<String> allFields = const <String>[
    user,
    imageBytes,
    text,
    timestamp
  ];

  static const String user = 'user';

  static const String imageBytes = 'image_bytes';

  static const String text = 'text';

  static const String timestamp = 'timestamp';
}
