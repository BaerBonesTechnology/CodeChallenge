import 'package:flutter/material.dart';

class StickyHeader extends StatelessWidget {
  const StickyHeader({super.key, required this.label, required this.elevation});

  final double elevation;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      child: Container(
        alignment: Alignment.centerLeft,
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

}