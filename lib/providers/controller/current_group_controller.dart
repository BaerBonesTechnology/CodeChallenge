import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_d_list/repo/guest_repository.dart';
import 'package:uuid/uuid.dart';

import '../../models/guest.dart';
import '../../models/guest_group.dart';
import '../guest_providers.dart';

class CurrentGroupNotifier extends StateNotifier<GuestGroup?> {
  CurrentGroupNotifier(super.state, {required this.guestRepo});

  final GuestRepository guestRepo;
  GuestGroup? getState() => state;

  void chooseGroup(GuestGroup group) {
    state = group;
  }

  void clear() {
    state = null;
  }

  Guest addGuest({required String name, required bool isReserved}) {
   if(state == null){
     final id = const Uuid().v1();
     state = GuestGroup(id, name: name.split(' ').last,);
   }
   final newReservedList = List<Guest>.from(state?.reservedGuests ?? []);
   final newUnreservedList = List<Guest>.from(state?.unreservedGuests ?? []);

   final newGuest =  Guest(name: name, isReserved: isReserved);
   isReserved ? newReservedList.add(newGuest)
       : newUnreservedList.add(newGuest);

   state = state?.copyWith(
     reservedGuests: newReservedList,
     unreservedGuests: newUnreservedList
   );

   return newGuest;
  }

  void removeGuest(Guest guest) {
    guest.isReserved ? state?.reservedGuests.remove(guest)
        : state?.unreservedGuests.remove(guest);
  }
  void markGuestPresent(WidgetRef ref, Guest guest) async {
    if (state != null) {
      final group = state!;
      if (guest.isReserved) {
        final index = group.reservedGuests.indexOf(guest);
        if (index != -1) {
          if (!ref.read(guestProviders).containsKey(guest)) {
            ref.read(guestProviders)[guest] =
                StateProvider((ref) => guest.isPresent);
          }
          await guestRepo.updateGroup(group);
        }
      } else {
        final index = group.unreservedGuests.indexOf(guest);
        if (index != -1) {
          if (!ref.read(guestProviders).containsKey(guest)) {
            ref.read(guestProviders)[guest] =
                StateProvider((ref) => guest.isPresent);
          }
          await guestRepo.updateGroup(group);
        }
      }
    }
  }

  void updateGroup() async => state != null ? guestRepo.updateGroup(state!) : DoNothingAction();
}