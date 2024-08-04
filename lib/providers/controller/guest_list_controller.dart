import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/guest_group.dart';
import '../../repo/guest_repository.dart';

class GuestListController extends StateNotifier<AsyncValue<List<GuestGroup>>> {
  GuestListController({required this.guestRepo}): super(const AsyncValue.loading());

  final GuestRepository guestRepo;

  Future<void> _updateGroups() async {
    state = const AsyncValue.loading();
    try {
      final groups = await guestRepo.retrieveGroups();
      state = AsyncValue.data(groups);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> retrieveGroups() async {
    _updateGroups();
  }

  Future<void> addGuestGroup(GuestGroup group) async {
    await _updateGroups();
    try {
      await guestRepo.addGuestGroup(group);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteGroup(GuestGroup group) async {
    await _updateGroups();
    try {
      await guestRepo.deleteGroup(group);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}