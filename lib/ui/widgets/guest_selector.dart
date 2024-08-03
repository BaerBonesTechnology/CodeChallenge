import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/guest.dart';
import '../../providers/guest_providers.dart';

class GuestSelector extends ConsumerWidget {
  const GuestSelector({super.key, required this.guest, required this.onChanged});

  final Guest guest;
  final Function(Guest guest) onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guestProvider = ref.watch(guestProviders).putIfAbsent(
        guest, () => StateProvider((ref) => guest.isPresent));
    final isPresent = ref.watch(guestProvider);


    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: isPresent, // Use guest.isPresent directly
          onChanged: (value) {
            if (value != null) {
              ref.read(guestProvider.notifier).state = value;
              onChanged(guest.copyWith(isPresent: value));
            }
          },
        ),
        Text(guest.name),
      ],
    );
  }
}