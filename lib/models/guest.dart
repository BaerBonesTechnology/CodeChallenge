import 'package:json_annotation/json_annotation.dart';

part 'guest.g.dart';

@JsonSerializable()
class Guest {
  Guest({required this.name, required this.isReserved, this.isPresent = false});

  final String name;
  final bool isReserved;
  final bool isPresent;

  factory Guest.fromJson(Map<String, dynamic> json) => _$GuestFromJson(json);

  Map<String, dynamic> toJson() => _$GuestToJson(this);

  Guest copyWith({
    String? name,
    bool? isReserved,
    bool? isPresent,
  }) {
    return Guest(
        name: name ?? this.name,
        isReserved: isReserved ?? this.isReserved,
        isPresent: isPresent ?? this.isPresent);
  }
}
