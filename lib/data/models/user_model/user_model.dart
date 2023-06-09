// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';

class UserModel {
  String? uid;
  String? username;
  String? email;
  String? phoneNumber;
  DateTime? dateOfBirth;
  String? profilePicture;
  List? followers;
  List? following;
  List? topics;
  bool? isAnonymous;
  UserModel({
    this.uid,
    this.username,
    this.email,
    this.phoneNumber,
    this.dateOfBirth,
    this.profilePicture,
    this.followers,
    this.following,
    this.topics,
    this.isAnonymous,
  });

  UserModel copyWith({
    String? uid,
    String? username,
    String? email,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? profilePicture,
    List? followers,
    List? following,
    List? topics,
    bool? isAnonymous,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      profilePicture: profilePicture ?? this.profilePicture,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      topics: topics ?? this.topics,
      isAnonymous: isAnonymous ?? this.isAnonymous,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth!.millisecondsSinceEpoch,
      'profilePicture': profilePicture,
      'followers': followers,
      'following': following,
      'topics': topics,
      'isAnonymous': isAnonymous,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String,
      dateOfBirth:
          DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth'] as int),
      profilePicture: map['profilePicture'] as String,
      followers: List.from((map['followers'] as List)),
      following: List.from((map['following'] as List)),
      topics: List.from((map['topics'] as List)),
      isAnonymous: map['isAnonymous'] as bool,
    );
  }

  @override
  String toString() {
    return 'User(uid: $uid, username: $username, email: $email, phoneNumber: $phoneNumber, dateOfBirth: $dateOfBirth, profilePicture: $profilePicture, followers: $followers, following: $following, topics: $topics, isAnonymous: $isAnonymous)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.username == username &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.dateOfBirth == dateOfBirth &&
        other.profilePicture == profilePicture &&
        listEquals(other.followers, followers) &&
        listEquals(other.following, following) &&
        listEquals(other.topics, topics) &&
        other.isAnonymous == isAnonymous;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        username.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        dateOfBirth.hashCode ^
        profilePicture.hashCode ^
        followers.hashCode ^
        following.hashCode ^
        topics.hashCode ^
        isAnonymous.hashCode;
  }
}
