import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import'package:the_d_list/providers/creation_view_providers.dart';
import 'package:the_d_list/repo/guest_repository.dart';

import '../../models/guest.dart';
import '../../models/guest_group.dart';
import '../guest_providers.dart';

class CurrentGroupNotifier extends StateNotifier<GuestGroup?> {
  CurrentGroupNotifier(super.state, {required this.guestRepo});

  final GuestRepository guestRepo;
  GuestGroup? getState() => state;void chooseGroup(GuestGroup group) {
    state = group;
  }

  void clear() {
    state = null;
  }

  Guest addGuest(WidgetRef ref,
      {required String name, required bool isReserved}) {
    state ??= GuestGroup(
        name: name.split(' ').last,
      );
    final newReservedList = List<Guest>.from(state?.reservedGuests ?? []);
    final newUnreservedList = List<Guest>.from(state?.unreservedGuests ?? []);

    final newGuest = Guest(name: name, isReserved: isReserved);
    isReserved
        ? newReservedList.add(newGuest)
        : newUnreservedList.add(newGuest);

    state = state?.copyWith(
        reservedGuests: newReservedList, unreservedGuests: newUnreservedList);
    final groupList = ref.read(tempGroupListProvider);

    final updatedList = [
      ...groupList,
      newGuest
    ];

    ref.read(tempGroupListProvider.notifier).state = updatedList;return newGuest;
  }

  void removeGuest(WidgetRef ref, {required Guest guest}) async {
    state?.reservedGuests.remove(guest);
    state?.unreservedGuests.remove(guest);
    ref.read(guestProviders).remove(guest);
    await guestRepo.updateGroup(state!);
  }

  bool markGuestPresent(WidgetRef ref, Guest guest) {
    if (state != null) {
      final group = state!;
      final guestList = guest.isReserved ? group.reservedGuests : group.unreservedGuests;
      final index = guestList.indexOf(guest);

      if (index != -1) {
        if (!ref.read(guestProviders).containsKey(guest)) {
          ref.read(guestProviders)[guest] =
              StateProvider((ref)=> guest.isPresent);
        }

        final guestProvider = ref.read(guestProviders)[guest]!;
        final newIsPresent = !ref.read(guestProvider);
        ref.read(guestProvider.notifier).state = newIsPresent;

        guestList[index] = guest.copyWith(isPresent: newIsPresent);
        state = group.copyWith(
          reservedGuests: guest.isReserved ? guestList : group.reservedGuests,
          unreservedGuests: guest.isReserved ? group.unreservedGuests : guestList,
        );

        if (!ref.read(guestProviders).containsKey(guest)) {
          ref.read(guestProviders)[guest] = StateProvider((ref) => guest.isPresent);
        }

        if (!guest.isReserved) {
          updateGroup();
        }
      }
    }

    return areGuestsCheckedIn();
  }

  bool areGuestsCheckedIn() {
    if (state == null) return false;
    return state!.reservedGuests.any((guest) => guest.isPresent) ||
        state!.unreservedGuests.any((guest) => guest.isPresent);
  }

  bool hasConflictedCheckin(){
    if(state == null) return false;
    return state!.reservedGuests.any((guest) => guest.isPresent) &&
    state!.unreservedGuests.any((guest) => guest.isPresent);
  }

  bool areGuestsCheckedInReserved(){
    if(state == null) return false;
    return areGuestsCheckedIn() ? state!.reservedGuests.any((guest) => guest.isPresent)&&
    ! state!.unreservedGuests.any((guest) => guest.isPresent) : false;
  }

  void updateGroup() async =>
      state != null ? guestRepo.updateGroup(state!) : DoNothingAction();
}