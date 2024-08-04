import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'guest.dart';

part 'guest_group.g.dart';

@JsonSerializable()
class GuestGroup {
  GuestGroup({
    String? id,
    this.cleared = false,
    required this.name,
    this.reservedGuests = const <Guest>[],
    this.unreservedGuests = const <Guest>[],
  }) : id = id ?? const Uuid().v4();

  final bool cleared;
  final String? id;
  final String name;
  final List<Guest> reservedGuests;
  final List<Guest> unreservedGuests;

  factory GuestGroup.fromJson(Map<String, dynamic> json) =>
      _$GuestGroupFromJson(json);

  Map<String, dynamic> toJson() => _$GuestGroupToJson(this);

  GuestGroup copyWith({
    bool? cleared,
    String? name,
    List<Guest>? reservedGuests,
    List<Guest>? unreservedGuests,
  }) {
    return GuestGroup(
      id: id,
      cleared: cleared ?? this.cleared,
      name: name ?? this.name,
      reservedGuests: reservedGuests ?? this.reservedGuests,
      unreservedGuests: unreservedGuests ?? this.unreservedGuests,
    );
  }

  List<Guest> getFullList() => [...reservedGuests, ...unreservedGuests];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Guest && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
