// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class TopicModel {
  String? uid;
  String? title;
  String? description;
  String? author;
  DateTime? date;
  double? rating;
  int? raters;
  List<dynamic>? tags;
  List<dynamic>? files;
  String? authorUid;
  bool? notifEnabled;
  double? rate;
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
    this.authorUid,
    this.notifEnabled,
    this.rate,
  });

  TopicModel copyWith({
    String? uid,
    String? title,
    String? description,
    String? author,
    DateTime? date,
    double? rating,
    int? raters,
    List<dynamic>? tags,
    List<dynamic>? files,
    String? authorUid,
    bool? notifEnabled,
    double? rate,
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
      authorUid: authorUid ?? this.authorUid,
      notifEnabled: notifEnabled ?? this.notifEnabled,
      rate: rate ?? this.rate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'title': title,
      'description': description,
      'author': author,
      'date': date?.millisecondsSinceEpoch,
      'rating': rating,
      'raters': raters,
      'tags': tags,
      'files': files,
      'authorUid': authorUid,
      'notifEnabled': notifEnabled,
      'rate': rate,
    };
  }

  factory TopicModel.fromMap(Map<String, dynamic> map) {
    return TopicModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      author: map['author'] != null ? map['author'] as String : null,
      date: map['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['date'] as int)
          : null,
      rating: map['rating'] != null ? map['rating'] as double : null,
      raters: map['raters'] != null ? map['raters'] as int : null,
      tags: map['tags'] != null
          ? List<dynamic>.from((map['tags'] as List<dynamic>))
          : null,
      files: map['files'] != null
          ? List<dynamic>.from((map['files'] as List<dynamic>))
          : null,
      authorUid: map['authorUid'] != null ? map['authorUid'] as String : null,
      notifEnabled:
          map['notifEnabled'] != null ? map['notifEnabled'] as bool : null,
      rate: map['rate'] != null ? map['rate'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TopicModel.fromJson(String source) =>
      TopicModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TopicModel(uid: $uid, title: $title, description: $description, author: $author, date: $date, rating: $rating, raters: $raters, tags: $tags, files: $files, authorUid: $authorUid, notifEnabled: $notifEnabled, rate: $rate)';
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
        listEquals(other.files, files) &&
        other.authorUid == authorUid &&
        other.notifEnabled == notifEnabled &&
        other.rate == rate;
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
        files.hashCode ^
        authorUid.hashCode ^
        notifEnabled.hashCode ^
        rate.hashCode;
  }
}
