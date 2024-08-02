import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/keys.dart';
import '../../models/guest_group.dart';

class GuestGroupSelection extends StatelessWidget {
  const GuestGroupSelection({super.key, required this.group, required this.onDelete, required this.onSelect});

  final GuestGroup group;
  final Function(GuestGroup group) onDelete;
  final Function(GuestGroup group) onSelect;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect(group),
      child: Dismissible(
        background: Container(color: Colors.red,),
        key: guestGroupItemKey(group.name),
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
           onDelete(group);
          }
        },
        child: Card(
          child: Text(group.name),
        ),
      ),
    );
  }
}
