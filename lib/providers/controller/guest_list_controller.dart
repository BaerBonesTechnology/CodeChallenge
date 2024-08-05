import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/guest_group.dart';
import '../../repo/guest_repository.dart';
import '../creation_view_providers.dart';
import '../guest_providers.dart';

class GuestListController extends StateNotifier<AsyncValue<List<GuestGroup>>> {
  GuestListController({required this.guestRepo})
      : super(const AsyncValue.loading());

  final GuestRepository guestRepo;

  Future<void> addGuestGroup(WidgetRef ref) async {
    final tempGroupList = ref.read(tempGroupListProvider);
    final currentGroup =
        ref.read(currentGroupNotifierProvider.notifier).getState();

    final group = currentGroup != null
        ? currentGroup.copyWith(
            reservedGuests:
                tempGroupList.where((guest) => guest.isReserved).toList(),
            unreservedGuests:
                tempGroupList.where((guest) => !guest.isReserved).toList(),
          )
        : GuestGroup(
            name: tempGroupList[0].name.split(' ')[0],
            reservedGuests:
                tempGroupList.where((guest) => guest.isReserved).toList(),
            unreservedGuests:
                tempGroupList.where((guest) => !guest.isReserved).toList(),
          );

    try {
      await guestRepo.addGuestGroup(group);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
    await _updateGroups();
  }

  Future<void> deleteGroup(GuestGroup group) async {
    try {
      await guestRepo.deleteGroup(group);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
    await _updateGroups();
  }

  Future<void> retrieveGroups() async {
    _updateGroups();
  }

  Future<void> _updateGroups() async {
    state = const AsyncValue.loading();
    try {
      final groups = await guestRepo.retrieveGroups();
      state = AsyncValue.data(groups);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
