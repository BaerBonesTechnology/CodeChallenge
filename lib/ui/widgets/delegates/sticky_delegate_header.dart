import 'package:flutter/cupertino.dart';

import '../sticky_header.dart';

class StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  StickyHeaderDelegate({
    this.elevation = 5,
    required this.label,
  });

  final String label;
  final double elevation;

  @override
  double get minExtent => 50;

  @override
  double get maxExtent => 50;

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
