import 'package:json_annotation/json_annotation.dart';

import 'guest.dart';

part 'guest_group.g.dart';

@JsonSerializable()
class GuestGroup {
  GuestGroup({required this.name, this.reservedGuests = const <Guest>[], this.unreservedGuests = const <Guest>[],});
  final String name;
  final List<Guest> reservedGuests;
  final List<Guest> unreservedGuests;

  factory GuestGroup.fromJson(Map<String, dynamic> json) => _$GuestGroupFromJson(json);

  Map<String, dynamic> toJson() => _$GuestGroupToJson(this);
}