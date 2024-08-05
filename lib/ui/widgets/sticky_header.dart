import 'package:flutter/material.dart';

import '../../constants/padding_value.dart';
import '../../constants/strings.dart';

class StickyHeader extends StatelessWidget {
  const StickyHeader({super.key, required this.label, required this.elevation});

  final double elevation;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      readOnly: true,
      header: true,
      tooltip: headingToolTip,
      label: label,
      child: Material(
        elevation: elevation,
        child: Container(
          alignment: Alignment.centerLeft,
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: PaddingValue.defaultPaddingHorizontal,
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
