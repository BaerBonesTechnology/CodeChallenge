import '../models/guest.dart';
import '../models/guest_group.dart';

abstract class GuestRepository {
  List<GuestGroup> guestGroups = <GuestGroup>[];

  void createGroup(
    List<Guest> guests, {
    String? name,
  });

  Future<void> addGuestGroup(GuestGroup group);

  Future<void> clearGroup(GuestGroup group);

  Future<void> deleteGroup(GuestGroup group);

  Future<List<GuestGroup>> retrieveGroups();

  void updateGroup(GuestGroup group);

  bool verifyGroup(GuestGroup group);

}
