import 'package:the_d_list/models/guest.dart';
import 'package:the_d_list/models/guest_group.dart';
import 'package:the_d_list/repo/guest_repository.dart';

class GuestRepositoryImpl extends GuestRepository{

  @override
  void createGroup(List<Guest> guests, {String? name}) {
    guestGroups.add(GuestGroup(
        name: name ?? guests[0].name.split(' ').last,
        reservedGuests:
        guests.where((element) => element.isReserved == true).toList(),
        unreservedGuests:
        guests.where((element) => element.isReserved == false).toList()));
  }

  @override
  void removeGroup(GuestGroup group) {
    guestGroups.remove(group);
  }
}