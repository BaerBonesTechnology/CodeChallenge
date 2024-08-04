// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Guest _$GuestFromJson(Map<String, dynamic> json) => Guest(
      name: json['name'] as String,
      isReserved: json['isReserved'] as bool,
      isPresent: json['isPresent'] as bool? ?? false,
      id: json['id'] as String?,
    );

Map<String, dynamic> _$GuestToJson(Guest instance) => <String, dynamic>{
      'name': instance.name,
      'isReserved': instance.isReserved,
      'isPresent': instance.isPresent,
      'id': instance.id,
    };
