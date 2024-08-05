
import 'package:flutter/material.dart';

import '../sticky_header.dart';

class StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  StickyHeaderDelegate({
    this.elevation = 5,
    required this.label,
  });

  final double elevation;
  final String label;

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final currentElevation = shrinkOffset > 0 ? elevation : 0.0;
    return StickyHeader(
      elevation: currentElevation,
      label: label,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate is! StickyHeaderDelegate || oldDelegate.label != label;
  }
}
