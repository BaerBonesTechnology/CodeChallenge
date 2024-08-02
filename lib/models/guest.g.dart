// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Guest _$GuestFromJson(Map<String, dynamic> json) => Guest(
      name: json['name'] as String,
      isReserved: json['isReserved'] as bool,
    );

Map<String, dynamic> _$GuestToJson(Guest instance) => <String, dynamic>{
      'name': instance.name,
      'isReserved': instance.isReserved,
    };
