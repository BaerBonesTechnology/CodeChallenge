import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/guest_group.dart';
import '../../repo/guest_repository.dart';

class GuestListController extends StateNotifier<AsyncValue<List<GuestGroup>>> {
  GuestListController({required this.guestRepo})
      : super(const AsyncValue.loading());

  final GuestRepository guestRepo;

  Future<void> retrieveGroups() async {
    state = const AsyncValue.loading();
    try {
      final groups = await guestRepo.retrieveGroups();
      state = AsyncValue.data(groups);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addGuestGroup(GuestGroup group) async {
    try {
      state = const AsyncValue.loading();
      await guestRepo.addGuestGroup(group);
      final updatedGroups =
          await guestRepo.retrieveGroups(); // Fetch updated groups
      state = AsyncValue.data(updatedGroups); // Update state with new data
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
