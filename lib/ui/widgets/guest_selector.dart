import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_d_list/constants/keys.dart';

import '../../models/guest.dart';
import '../../providers/guest_providers.dart';

class GuestSelector extends ConsumerWidget {
  const GuestSelector({
    super.key,
    required this.groupSize,
    required this.guest,
    required this.index,
    required this.onChanged,
  });

  final int groupSize;
  final Guest guest;
  final int index;
  final Function(Guest guest) onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guestProvider = ref
        .watch(guestProviders)
        .putIfAbsent(guest, () => StateProvider((ref) => false));
    final checked = ref.watch(guestProvider);

    return Semantics(
      key: guestItemKey(guest.name),
      label: guest.name,
      tooltip: 'checkbox',
      checked: checked,
      maxValueLength: groupSize,
      currentValueLength: index,
      enabled: true,
      child: GestureDetector(
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
                value: checked,
                onChanged: (value) {
                  if (value != null) {
                    onChanged(guest);
                    ref.read(isEnabledProvider.notifier).state = false;
                  }
                },
              ),
              Text(guest.name),
            ],
          ),
        ),
      ),
    );
  }
}
