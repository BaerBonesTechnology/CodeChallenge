import '../../../models/guest.dart';
import '../../../models/guest_group.dart';
import '../guest_repository.dart';

class FakeGuestRepositoryImpl extends GuestRepository {
  FakeGuestRepositoryImpl() : super();

  @override
  void createGroup(List<Guest> guests, {String? name}) {
    final group = GuestGroup(
      name: name ?? guests[0].name.split(' ').last,
      reservedGuests: guests.where((element) => element.isReserved).toList(),
      unreservedGuests: guests.where((element) => !element.isReserved).toList(),
    );
    addGuestGroup(group);
  }

  @override
  Future<void> addGuestGroup(GuestGroup group)async {
    guestGroups.add(group);
  }

  @override
  Future<void> clearGroup(GuestGroup group) async {
    final index = guestGroups.indexOf(group);
    if (index != -1) {
      guestGroups[index] = group.copyWith(cleared: true);
    }
  }

  @override
  Future<void> deleteGroup(GuestGroup group) async {
    guestGroups.remove(group);
  }

  @override
  Future<List<GuestGroup>> retrieveGroups() async {
    return guestGroups.where((element) => !element.cleared).toList();
  }

  @override
  void updateGroup(GuestGroup group) {
    final index = guestGroups.indexWhere((element) => element.id == group.id);
    if (index != -1) {
      guestGroups[index] = group;
    }
  }

  @override
  bool verifyGroup(GuestGroup group) {
    final reservedTestGroup =
    group.reservedGuests.where((element) => !element.isReserved);
    final unreservedTestGroup =
    group.unreservedGuests.where((element) => element.isReserved);

    if (reservedTestGroup.isEmpty && unreservedTestGroup.isEmpty) {
      return true;
    } else {
      for (var guest in reservedTestGroup) {
        group.reservedGuests.remove(guest);
      }
      for (var guest in unreservedTestGroup) {
        group.unreservedGuests.remove(guest);
      }
      return verifyGroup(group);
    }
  }
}