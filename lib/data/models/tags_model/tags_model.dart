// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class TagsModel {
  String? uid;
  List<dynamic>? tags;
  TagsModel({
    this.uid,
    this.tags,
  });

  TagsModel copyWith({
    String? uid,
    List<dynamic>? tags,
  }) {
    return TagsModel(
      uid: uid ?? this.uid,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'tags': tags,
    };
  }

  factory TagsModel.fromMap(Map<String, dynamic> map) {
    return TagsModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      tags: map['tags'] != null
          ? List<dynamic>.from((map['tags'] as List<dynamic>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TagsModel.fromJson(String source) =>
      TagsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TagsModel(uid: $uid, tags: $tags)';

  @override
  bool operator ==(covariant TagsModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid && listEquals(other.tags, tags);
  }

  @override
  int get hashCode => uid.hashCode ^ tags.hashCode;
}
