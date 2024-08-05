import 'package:flutter/material.dart';

import '../../constants/font_size.dart';
import '../../constants/keys.dart';
import '../../constants/padding_value.dart';
import '../../models/guest_group.dart';

class GuestGroupSelection extends StatefulWidget {
  const GuestGroupSelection({
    super.key,
    required this.group,
    this.hint,
    required this.onDelete,
    required this.onEditSwipe,
    required this.onSelect,
  });

  final GuestGroup group;
  final String? hint;
  final Function(GuestGroup group) onDelete;
  final Function(GuestGroup group) onEditSwipe;
  final Function(GuestGroup group) onSelect;

  @override
  State<GuestGroupSelection> createState() => _GuestGroupSelectionState();
}

class _GuestGroupSelectionState extends State<GuestGroupSelection> {
  @override
  Widget build(BuildContext context) {
    final count = widget.group.getFullList().length;

    return context.mounted
        ? MergeSemantics(
            child: Semantics(
              key: guestGroupItemKey(widget.group.name),
              button: true,
              enabled: true,
              onTap: () => widget.onSelect(widget.group),
              onTapHint: widget.hint,
              child: GestureDetector(
                onTap: () => widget.onSelect(widget.group),
                child: Dismissible(
                  background: Container(
                    color: Colors.red,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: PaddingValue.small,
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
                      return Future.value(true); // Return true to dismiss
                    } else {
                      widget.onEditSwipe(widget.group);
                      return Future.value(false);
                    }
                  },
                  direction: DismissDirection.horizontal,
                  secondaryBackground: Container(
                    color: Colors.blueGrey,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: PaddingValue.small,
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
                            padding: PaddingValue.small,
                            child: Text(
                              widget.group.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: FontSize.medium,
                              ),
                            ),
                          ),
                          Text(
                            'Guest Count: $count',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.black38),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : const CircularProgressIndicator();
  }
}
