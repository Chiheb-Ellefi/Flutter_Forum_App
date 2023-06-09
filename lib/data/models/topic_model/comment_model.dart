// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CommentModel {
  String? author;
  DateTime? date;
  String? text;
  int? likes;
  bool? isLiked;
  int? replies;
  CommentModel({
    this.author,
    this.date,
    this.text,
    this.likes,
    this.isLiked,
    this.replies,
  });

  CommentModel copyWith({
    String? author,
    DateTime? date,
    String? text,
    int? likes,
    bool? isLiked,
    int? replies,
  }) {
    return CommentModel(
      author: author ?? this.author,
      date: date ?? this.date,
      text: text ?? this.text,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      replies: replies ?? this.replies,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'author': author,
      'date': date?.millisecondsSinceEpoch,
      'text': text,
      'likes': likes,
      'isLiked': isLiked,
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
      likes: map['likes'] != null ? map['likes'] as int : null,
      isLiked: map['isLiked'] != null ? map['isLiked'] as bool : null,
      replies: map['replies'] != null ? map['replies'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CommentModel(author: $author, date: $date, text: $text, likes: $likes, isLiked: $isLiked, replies: $replies)';
  }

  @override
  bool operator ==(covariant CommentModel other) {
    if (identical(this, other)) return true;

    return other.author == author &&
        other.date == date &&
        other.text == text &&
        other.likes == likes &&
        other.isLiked == isLiked &&
        other.replies == replies;
  }

  @override
  int get hashCode {
    return author.hashCode ^
        date.hashCode ^
        text.hashCode ^
        likes.hashCode ^
        isLiked.hashCode ^
        replies.hashCode;
  }
}
