import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'guest.dart';

part 'guest_group.g.dart';

@JsonSerializable()
class GuestGroup {
  GuestGroup(
    this.id, {
    required this.name,
    this.reservedGuests = const <Guest>[],
    this.unreservedGuests = const <Guest>[],
  });
  final String id;
  final String name;
  final List<Guest> reservedGuests;
  final List<Guest> unreservedGuests;

  factory GuestGroup.fromJson(Map<String, dynamic> json) =>
      _$GuestGroupFromJson(json);

  Map<String, dynamic> toJson() => _$GuestGroupToJson(this);

  GuestGroup? copyWith({
    String? id,
    String? name,
    List<Guest>? reservedGuests,
    List<Guest>? unreservedGuests,
  }) {
    return GuestGroup(
      id ?? this.id,
      name: name ?? this.name,
      reservedGuests: reservedGuests ?? this.reservedGuests,
      unreservedGuests: unreservedGuests ?? this.unreservedGuests,
    );
  }
}
