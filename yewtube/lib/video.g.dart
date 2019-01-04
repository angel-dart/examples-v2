// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.dart';

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class Video extends _Video {
  Video(
      {this.id,
      this.title,
      this.description,
      this.filePath,
      this.mimeType,
      this.createdAt,
      this.updatedAt});

  @override
  final String id;

  @override
  final String title;

  @override
  final String description;

  @override
  final String filePath;

  @override
  final String mimeType;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  Video copyWith(
      {String id,
      String title,
      String description,
      String filePath,
      String mimeType,
      DateTime createdAt,
      DateTime updatedAt}) {
    return new Video(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        filePath: filePath ?? this.filePath,
        mimeType: mimeType ?? this.mimeType,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  bool operator ==(other) {
    return other is _Video &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.filePath == filePath &&
        other.mimeType == mimeType &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return hashObjects(
        [id, title, description, filePath, mimeType, createdAt, updatedAt]);
  }

  Map<String, dynamic> toJson() {
    return VideoSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

abstract class VideoSerializer {
  static Video fromMap(Map map) {
    return new Video(
        id: map['id'] as String,
        title: map['title'] as String,
        description: map['description'] as String,
        filePath: map['file_path'] as String,
        mimeType: map['mime_type'] as String,
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

  static Map<String, dynamic> toMap(_Video model) {
    if (model == null) {
      return null;
    }
    return {
      'id': model.id,
      'title': model.title,
      'description': model.description,
      'file_path': model.filePath,
      'mime_type': model.mimeType,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String()
    };
  }
}

abstract class VideoFields {
  static const List<String> allFields = const <String>[
    id,
    title,
    description,
    filePath,
    mimeType,
    createdAt,
    updatedAt
  ];

  static const String id = 'id';

  static const String title = 'title';

  static const String description = 'description';

  static const String filePath = 'file_path';

  static const String mimeType = 'mime_type';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';
}
