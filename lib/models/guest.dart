
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'guest.g.dart';

@JsonSerializable()
class Guest {
  Guest({
    String? id,
    this.isPresent = false,
    required this.isReserved,
    required this.name,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final bool isPresent;
  final bool isReserved;
  final String name;


  factory Guest.fromJson(Map<String, dynamic> json) => _$GuestFromJson(json);

  Map<String, dynamic> toJson() => _$GuestToJson(this);

  Guest copyWith({
    bool? isPresent,
    bool? isReserved,
    String? name,
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
