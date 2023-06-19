// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ReportModel {
  String? reporter;
  String? reported;
  List<dynamic>? reasons;
  ReportModel({
    this.reporter,
    this.reported,
    this.reasons,
  });

  ReportModel copyWith({
    String? reporter,
    String? reported,
    List<dynamic>? reasons,
  }) {
    return ReportModel(
      reporter: reporter ?? this.reporter,
      reported: reported ?? this.reported,
      reasons: reasons ?? this.reasons,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reporter': reporter,
      'reported': reported,
      'reasons': reasons,
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      reporter: map['reporter'] != null ? map['reporter'] as String : null,
      reported: map['reported'] != null ? map['reported'] as String : null,
      reasons: map['reasons'] != null
          ? List<dynamic>.from((map['reasons'] as List<dynamic>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReportModel.fromJson(String source) =>
      ReportModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ReportModel(reporter: $reporter, reported: $reported, reasons: $reasons)';

  @override
  bool operator ==(covariant ReportModel other) {
    if (identical(this, other)) return true;

    return other.reporter == reporter &&
        other.reported == reported &&
        listEquals(other.reasons, reasons);
  }

  @override
  int get hashCode => reporter.hashCode ^ reported.hashCode ^ reasons.hashCode;
}
