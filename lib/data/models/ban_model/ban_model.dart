// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BanModel {
  String? banned;
  DateTime? duration;
  BanModel({
    this.banned,
    this.duration,
  });

  BanModel copyWith({
    String? banned,
    DateTime? duration,
  }) {
    return BanModel(
      banned: banned ?? this.banned,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'banned': banned,
      'duration': duration?.millisecondsSinceEpoch,
    };
  }

  factory BanModel.fromMap(Map<String, dynamic> map) {
    return BanModel(
      banned: map['banned'] != null ? map['banned'] as String : null,
      duration: map['duration'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['duration'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BanModel.fromJson(String source) =>
      BanModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'BanModel(banned: $banned, duration: $duration)';

  @override
  bool operator ==(covariant BanModel other) {
    if (identical(this, other)) return true;

    return other.banned == banned && other.duration == duration;
  }

  @override
  int get hashCode => banned.hashCode ^ duration.hashCode;
}
