import 'package:flutter/material.dart';

class GuestCreationListTile extends StatelessWidget {
  const GuestCreationListTile({super.key, required this.name, required this.onDelete, required this.isReserved});

  final String name;
  final Function() onDelete;
  final bool isReserved;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(name),
        Visibility(
        visible: isReserved,
        child: const Icon(
            Icons.check,
          )
        ),
        const Spacer(),
        IconButton(onPressed: () {
          onDelete();
        }, icon: const Icon(Icons.delete_forever_rounded))
      ],
    );
  }
}
