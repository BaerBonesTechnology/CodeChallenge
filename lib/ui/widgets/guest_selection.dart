import 'package:flutter/material.dart';

import '../../models/guest.dart';

class GuestSelector extends StatelessWidget {
  GuestSelector({super.key, required this.guest, required this.onChanged});

  final Guest guest;
  final Function(Guest guest) onChanged;
  final ValueNotifier<bool> selected = ValueNotifier(false);


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
            value: selected.value,
            onChanged: (value) {
              try {
                if (value != null) {
                  selected.value = value;
                } else {
                  throw Exception('Error Selecting Guest');
                }
                onChanged(guest);
              } catch (e) {
                // Add snackbar to show error
              }
            }),
        Text(guest.name)
      ],
    );
  }
}
