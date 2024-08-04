import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/strings.dart';
import '../../providers/guest_providers.dart';
import '../widgets/back_button.dart';

class ConfirmationView extends ConsumerWidget {
  const ConfirmationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentGroupManager = ref.read(currentGroupNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(confirmationScreenLabel),
        leading: DListBackButton(
          onPressed: () async {
            currentGroupManager.setUpTempGuestList(ref,
                group: currentGroupManager.getState()!,
                guestsPresent: true);
            ref.read(currentGroupNotifierProvider.notifier).updateGroup(ref);
            await ref.read(currentGroupNotifierProvider.notifier).guestRepo.retrieveGroups();
          },
        ),
      ),
      body: Center(
        child: Text(
          confirmationScreenMessage,
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}
