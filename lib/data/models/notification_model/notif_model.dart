// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NotificationModel {
  String? notified;
  String? notifier;
  DateTime? date;
  String? notification;
  String? uid;
  NotificationModel({
    this.notified,
    this.notifier,
    this.date,
    this.notification,
    this.uid,
  });

  NotificationModel copyWith({
    String? notified,
    String? notifier,
    DateTime? date,
    String? notification,
    String? uid,
  }) {
    return NotificationModel(
      notified: notified ?? this.notified,
      notifier: notifier ?? this.notifier,
      date: date ?? this.date,
      notification: notification ?? this.notification,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'notified': notified,
      'notifier': notifier,
      'date': date?.millisecondsSinceEpoch,
      'notification': notification,
      'uid': uid,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      notified: map['notified'] != null ? map['notified'] as String : null,
      notifier: map['notifier'] != null ? map['notifier'] as String : null,
      date: map['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['date'] as int)
          : null,
      notification:
          map['notification'] != null ? map['notification'] as String : null,
      uid: map['uid'] != null ? map['uid'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationModel(notified: $notified, notifier: $notifier, date: $date, notification: $notification, uid: $uid)';
  }

  @override
  bool operator ==(covariant NotificationModel other) {
    if (identical(this, other)) return true;

    return other.notified == notified &&
        other.notifier == notifier &&
        other.date == date &&
        other.notification == notification &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    return notified.hashCode ^
        notifier.hashCode ^
        date.hashCode ^
        notification.hashCode ^
        uid.hashCode;
  }
}
