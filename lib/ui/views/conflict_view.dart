import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_d_list/providers/guest_providers.dart';
import 'package:the_d_list/ui/widgets/backButton.dart';

import '../../constants/strings.dart';

class ConflictView extends ConsumerWidget {
  const ConflictView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //To be used for confirmation screen
    // final currentGroup = ref.read(currentGroupNotifierProvider);
    //
    // currentGroup?.reservedGuests.where((guest) => guest.isPresent).forEach(
    //     (guest){
    //       ref.read(currentGroupNotifierProvider.notifier).removeGuest(ref, guest: guest);
    //     }
    // );
    return Scaffold(
      appBar: AppBar(
        title: const Text(conflictScreenLabel),
        leading: const DListBackButton(),
      ),
      body: Center(
        child: Text(conflictScreenMessage, style: Theme.of(context).textTheme.displayLarge,),
      ),
    );
  }
}
