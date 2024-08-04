import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_d_list/providers/guest_providers.dart';
import 'package:the_d_list/ui/widgets/backButton.dart';

import '../../constants/strings.dart';

class ConfirmationView extends ConsumerWidget {
  const ConfirmationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentGroup = ref.read(currentGroupNotifierProvider);

    final presentGuests = List.from(currentGroup?.reservedGuests.where((guest) => guest.isPresent) ?? []); // Create a copy

    for (final guest in presentGuests) {// Iterate over the copy
      ref.read(currentGroupNotifierProvider.notifier).removeGuest(ref, guest: guest);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(confirmationScreenLabel),
        leading: const DListBackButton(),
      ),
      body: Center(
        child: Text(confirmationScreenMessage, style: Theme.of(context).textTheme.displayLarge,),
      ),
    );
  }
}
