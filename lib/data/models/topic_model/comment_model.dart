// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class CommentModel {
  String? author;
  DateTime? date;
  String? text;
  List<dynamic>? likes;
  List<dynamic>? replies;
  CommentModel({
    this.author,
    this.date,
    this.text,
    this.likes,
    this.replies,
  });

  CommentModel copyWith({
    String? author,
    DateTime? date,
    String? text,
    List<dynamic>? likes,
    List<dynamic>? replies,
  }) {
    return CommentModel(
      author: author ?? this.author,
      date: date ?? this.date,
      text: text ?? this.text,
      likes: likes ?? this.likes,
      replies: replies ?? this.replies,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'author': author,
      'date': date?.millisecondsSinceEpoch,
      'text': text,
      'likes': likes,
      'replies': replies,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      author: map['author'] != null ? map['author'] as String : null,
      date: map['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['date'] as int)
          : null,
      text: map['text'] != null ? map['text'] as String : null,
      likes: map['likes'] != null
          ? List<dynamic>.from((map['likes'] as List<dynamic>))
          : null,
      replies: map['replies'] != null
          ? List<dynamic>.from((map['replies'] as List<dynamic>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CommentModel(author: $author, date: $date, text: $text, likes: $likes, replies: $replies)';
  }

  @override
  bool operator ==(covariant CommentModel other) {
    if (identical(this, other)) return true;

    return other.author == author &&
        other.date == date &&
        other.text == text &&
        listEquals(other.likes, likes) &&
        listEquals(other.replies, replies);
  }

  @override
  int get hashCode {
    return author.hashCode ^
        date.hashCode ^
        text.hashCode ^
        likes.hashCode ^
        replies.hashCode;
  }
}
