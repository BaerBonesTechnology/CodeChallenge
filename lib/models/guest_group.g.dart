// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GuestGroup _$GuestGroupFromJson(Map<String, dynamic> json) => GuestGroup(
      json['id'] as String,
      name: json['name'] as String,
      reservedGuests: (json['reservedGuests'] is List<dynamic>)
          ? (json['reservedGuests'] as List<dynamic>)
              .map((e) => Guest.fromJson(e as Map<String, dynamic>))
              .toList()
          : (json['reservedGuests'] is String)
              ? (jsonDecode(json['reservedGuests'] as String) as List<dynamic>)
                  .map((e) => Guest.fromJson(e as Map<String, dynamic>))
                  .toList()
              : const <Guest>[],
      unreservedGuests: (json['unreservedGuests'] is List<dynamic>)
          ? (json['unreservedGuests'] as List<dynamic>)
              .map((e) => Guest.fromJson(e as Map<String, dynamic>))
              .toList()
          : (json['unreservedGuests'] is String)
              ? (jsonDecode(json['unreservedGuests'] as String)
                      as List<dynamic>)
                  .map((e) => Guest.fromJson(e as Map<String, dynamic>))
                  .toList()
              : const <Guest>[],
    );

Map<String, dynamic> _$GuestGroupToJson(GuestGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'reservedGuests':
          instance.reservedGuests.map((guest) => guest.toJson()).toList(),
      'unreservedGuests':
          instance.unreservedGuests.map((guest) => guest.toJson()).toList(),
    };
