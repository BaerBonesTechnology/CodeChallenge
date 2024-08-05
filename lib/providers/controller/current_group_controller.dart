import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/guest.dart';
import '../../models/guest_group.dart';
import '../../repo/guest_repository.dart';
import '../creation_view_providers.dart';
import '../guest_providers.dart';

class CurrentGroupNotifier extends StateNotifier<GuestGroup?> {
  CurrentGroupNotifier(super.state, {required this.guestRepo}) {
    guestRepo.retrieveGroups();
  }

  GuestGroup? getState() => state;
  final GuestRepository guestRepo;

  Guest addGuest(WidgetRef ref,
      {required String name, required bool isReserved}) {
    state ??= GuestGroup(name: name.split(' ').last);

    final newGuest = Guest(name: name, isReserved: isReserved);

    if (isReserved) {
      state =
          state!.copyWith(reservedGuests: [...state!.reservedGuests, newGuest]);
    } else {
      state = state!
          .copyWith(unreservedGuests: [...state!.unreservedGuests, newGuest]);
    }

    _updateTempGroupList(ref);

    return newGuest;
  }

  bool areGuestsCheckedIn() {
    if (state == null) return false;
    return state!.reservedGuests.any((guest) => guest.isPresent) ||
        state!.unreservedGuests.any((guest) => guest.isPresent);
  }

  bool areGuestsCheckedInReserved() {
    if (state == null) return false;
    return areGuestsCheckedIn()
        ? state!.reservedGuests.any((guest) => guest.isPresent) &&
            !state!.unreservedGuests.any((guest) => guest.isPresent)
        : false;
  }

  void chooseGroup(WidgetRef ref, GuestGroup group) {
    ref.read(tempGroupListProvider.notifier).state = [];
    clear();
    state = group;
    setUpTempGuestList(ref, group: group);
  }

  void clear() {
    state = null;
  }

  bool hasConflictedCheckIn() {
    if (state == null) return false;
    return state!.reservedGuests.any((guest) => guest.isPresent) &&
        state!.unreservedGuests.any((guest) => guest.isPresent);
  }

  void markGuestPresent(WidgetRef ref, Guest guest) {
    if (state != null) {
      final group = state!;
      final guestList =
          guest.isReserved ? group.reservedGuests : group.unreservedGuests;
      final index = guestList.indexOf(guest);

      if (index != -1) {
        if (!ref.read(guestProviders).containsKey(guest)) {
          ref.read(guestProviders)[guest] =
              StateProvider((ref) => guest.isPresent);
        }

        final guestProvider = ref.read(guestProviders)[guest]!;
        final newIsPresent = !ref.read(guestProvider);
        ref.read(guestProvider.notifier).state = newIsPresent;

        guestList[index] = guest.copyWith(isPresent: newIsPresent);
        state = group.copyWith(
          reservedGuests: guest.isReserved ? guestList : group.reservedGuests,
          unreservedGuests:
              !guest.isReserved ? guestList : group.unreservedGuests,
        );

        if (!ref.read(guestProviders).containsKey(guest)) {
          ref.read(guestProviders)[guest] =
              StateProvider((ref) => guest.isPresent);
        }
        updateGroup(ref);
      }
    }
    ref.read(isEnabledProvider.notifier).state =
        state!.unreservedGuests.any((element) => element.isPresent) ||
            state!.reservedGuests.any((element) => element.isPresent);
  }

  void removeGuest(WidgetRef ref, {required index}) {
    ref.read(tempGroupListProvider).removeAt(index);
    ref.read(tempGroupListProvider.notifier).state =
        ref.read(tempGroupListProvider);
    state = state!.copyWith(
        unreservedGuests: ref
            .read(tempGroupListProvider)
            .where((guest) => !guest.isReserved)
            .toList(),
        reservedGuests: ref
            .read(tempGroupListProvider)
            .where((guest) => guest.isReserved)
            .toList());
  }

  void setUpTempGuestList(WidgetRef ref,
      {required GuestGroup group, bool guestsPresent = false}) {
    if (state != null) {
      if (state!.reservedGuests.isNotEmpty ||
          state!.unreservedGuests.isNotEmpty) {
        var groupList = <Guest>[];
        if (!guestsPresent) {
          groupList.addAll(group.reservedGuests);
          groupList.addAll(group.unreservedGuests);
        } else {
          final newGroup = state;
          group.reservedGuests
              .where((guest) => guest.isPresent)
              .forEach((guest) {
            final index = newGroup!.reservedGuests.indexOf(guest);
            newGroup.reservedGuests.removeAt(index);
          });
          group.unreservedGuests
              .where((guest) => guest.isPresent)
              .forEach((guest) {
            final index = newGroup!.reservedGuests.indexOf(guest);
            newGroup.reservedGuests.removeAt(index);
          });
          ref.read(currentGroupNotifierProvider.notifier).state = newGroup;
          groupList = newGroup != null
              ? [...newGroup.reservedGuests, ...newGroup.unreservedGuests]
              : [];
          updateGroup(ref);
        }
        ref.read(tempGroupListProvider.notifier).state = groupList;
      }
    }
  }

  void updateGroup(WidgetRef ref) async {
    state != null ? guestRepo.updateGroup(state!) : DoNothingAction();
  }

  void _updateTempGroupList(WidgetRef ref, {GuestGroup? group}) {
    ref.read(tempGroupListProvider.notifier).state =
        group != null ? group.getFullList() : state!.getFullList();
  }
}
