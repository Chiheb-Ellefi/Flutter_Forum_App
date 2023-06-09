// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:my_project/data/models/topic_model/comment_model.dart';

class TopicModel {
  String? uid;
  String? title;
  String? description;
  String? author;
  DateTime? date;
  double? rating;
  int? raters;
  List<String>? tags;
  List<String>? files;
  List<CommentModel>? comments;
  TopicModel({
    this.uid,
    this.title,
    this.description,
    this.author,
    this.date,
    this.rating,
    this.raters,
    this.tags,
    this.files,
  });

  TopicModel copyWith({
    String? uid,
    String? title,
    String? description,
    String? author,
    DateTime? date,
    double? rating,
    int? raters,
    List<String>? tags,
    List<String>? files,
  }) {
    return TopicModel(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      description: description ?? this.description,
      author: author ?? this.author,
      date: date ?? this.date,
      rating: rating ?? this.rating,
      raters: raters ?? this.raters,
      tags: tags ?? this.tags,
      files: files ?? this.files,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'title': title,
      'description': description,
      'author': author,
      'date': date!.millisecondsSinceEpoch,
      'rating': rating,
      'raters': raters,
      'tags': tags,
      'files': files,
    };
  }

  factory TopicModel.fromMap(Map<String, dynamic> map) {
    return TopicModel(
      uid: map['uid'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      author: map['author'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      rating: map['rating'] as double,
      raters: map['raters'] as int,
      tags: List<String>.from(
          (map['tags'] as List<dynamic>).map<String>((tag) => tag.toString())),
      files: List<String>.from((map['files'] as List<dynamic>)
          .map<String>((file) => file.toString())),
    );
  }

  String toJson() => json.encode(toMap());

  factory TopicModel.fromJson(String source) =>
      TopicModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TopicModel(uid: $uid, title: $title, description: $description, author: $author, date: $date, rating: $rating, raters: $raters, tags: $tags, files: $files)';
  }

  @override
  bool operator ==(covariant TopicModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.title == title &&
        other.description == description &&
        other.author == author &&
        other.date == date &&
        other.rating == rating &&
        other.raters == raters &&
        listEquals(other.tags, tags) &&
        listEquals(other.files, files);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        title.hashCode ^
        description.hashCode ^
        author.hashCode ^
        date.hashCode ^
        rating.hashCode ^
        raters.hashCode ^
        tags.hashCode ^
        files.hashCode;
  }
}
