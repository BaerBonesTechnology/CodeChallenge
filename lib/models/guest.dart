import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'guest.g.dart';

@JsonSerializable()
class Guest {
  Guest({
    required this.name,
    required this.isReserved,
    this.isPresent = false,
    String? id,
  }) : id = id ?? const Uuid().v4();

  final String name;
  final bool isReserved;
  final bool isPresent;
  final String id;

  factory Guest.fromJson(Map<String, dynamic> json) => _$GuestFromJson(json);

  Map<String, dynamic> toJson() => _$GuestToJson(this);

  Guest copyWith({
    String? name,
    bool? isReserved,
    bool? isPresent,
  }) {
    return Guest(
        id: id,
        name: name ?? this.name,
        isReserved: isReserved ?? this.isReserved,
        isPresent: isPresent ?? this.isPresent);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Guest && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
