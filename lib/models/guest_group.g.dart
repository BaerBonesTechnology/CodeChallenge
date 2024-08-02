// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GuestGroup _$GuestGroupFromJson(Map<String, dynamic> json) => GuestGroup(
      name: json['name'] as String,
      reservedGuests: (json['reservedGuests'] as List<dynamic>?)
              ?.map((e) => Guest.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Guest>[],
      unreservedGuests: (json['unreservedGuests'] as List<dynamic>?)
              ?.map((e) => Guest.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Guest>[],
    );

Map<String, dynamic> _$GuestGroupToJson(GuestGroup instance) =>
    <String, dynamic>{
      'name': instance.name,
      'reservedGuests': instance.reservedGuests,
      'unreservedGuests': instance.unreservedGuests,
    };
