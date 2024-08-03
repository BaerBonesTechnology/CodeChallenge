import '../models/guest.dart';
import '../models/guest_group.dart';

abstract class GuestRepository {
  final List<GuestGroup> guestGroups = <GuestGroup>[];

  void createGroup(
    List<Guest> guests, {
    String? name,
  });

  Future<void> addGuestGroup(GuestGroup group);

  Future<void> clearGroup(GuestGroup group);

  Future<void> deleteGroup(GuestGroup group);

  Future<List<GuestGroup>> retrieveGroups();

  Future<void> updateGroup(GuestGroup group);

}
