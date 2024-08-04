import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/guest.dart';
import '../../providers/guest_providers.dart';

class GuestSelector extends ConsumerWidget {
  const GuestSelector(
      {super.key, required this.guest, required this.onChanged});

  final Guest guest;
  final Function(Guest guest) onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guestProvider = ref
        .watch(guestProviders)
        .putIfAbsent(guest, () => StateProvider((ref) => false));

    return GestureDetector(
      onTap: () {
        onChanged(guest);
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.045,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              activeColor: Colors.green,
              value: ref.watch(guestProvider),
              onChanged: (value) {
                if (value != null) {
                  onChanged(guest);
                }
              },
            ),
            Text(guest.name),
          ],
        ),
      ),
    );
  }
}
