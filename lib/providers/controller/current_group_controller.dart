import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/guest_group.dart';


part 'current_group_controller.g.dart';

@Riverpod(keepAlive: true)
class CurrentGroupController extends _$CurrentGroupController {
  @override
  GuestGroup? build() => null;

  void chooseGroup(GuestGroup group) {
    state = group;
  }

  void clear() {
    state = null;
  }
}