import '../constants/strings.dart';
import '../models/guest.dart';
import '../models/guest_group.dart';

abstract class GuestRepository {
  final List<GuestGroup> guestGroups = <GuestGroup>[];

  void createGroup(
    List<Guest> guests, {
    String? name,
  });

  void removeGroup(GuestGroup group);
}
