import 'package:flutter/material.dart';

import '../../constants/keys.dart';
import '../../models/guest_group.dart';

class GuestGroupSelection extends StatefulWidget {
  const GuestGroupSelection(
      {super.key,
      required this.group,
      required this.onDelete,
      required this.onEditSwipe,
      required this.onSelect});

  final GuestGroup group;
  final Function(GuestGroup group) onDelete;
  final Function(GuestGroup group) onEditSwipe;
  final Function(GuestGroup group) onSelect;

  @override
  State<GuestGroupSelection> createState() => _GuestGroupSelectionState();
}

class _GuestGroupSelectionState extends State<GuestGroupSelection> {
  @override
  Widget build(BuildContext context) {
    return context.mounted
        ? GestureDetector(
            onTap: () => widget.onSelect(widget.group),
            child: Dismissible(
              background: Container(
                color: Colors.red,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  Future.value(true);
                } else {
                  widget.onEditSwipe(widget.group);
                }
              },
              direction: DismissDirection.horizontal,
              secondaryBackground: Container(
                color: Colors.blueGrey,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              key: guestGroupItemKey(widget.group.name),
              onDismissed: (direction) => widget.onDelete(widget.group),
              child: Card(
                elevation: 0,
                shape: const RoundedRectangleBorder(),
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.group.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : const CircularProgressIndicator();
  }
}
