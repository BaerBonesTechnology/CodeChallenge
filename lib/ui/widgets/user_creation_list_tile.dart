import 'package:flutter/material.dart';

class GuestCreationListTile extends StatelessWidget {
  const GuestCreationListTile({super.key, required this.name, required this.onDelete});

  final String name;
  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(name),
        const Spacer(),
        IconButton(onPressed: () => onDelete(), icon: const Icon(Icons.delete_outline))
      ],
    );
  }
}
