import 'package:json_annotation/json_annotation.dart';

part 'guest.g.dart';

@JsonSerializable()
class Guest{
  Guest({required this.name, required this.isReserved});

  final String name;
  final bool isReserved;

  factory Guest.fromJson(Map<String, dynamic> json ) => _$GuestFromJson(json);

  Map<String, dynamic> toJson() => _$GuestToJson(this);
}