import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/router_endpoints.dart';
import '../../constants/strings.dart';
import '../../providers/guest_providers.dart';
import '../widgets/back_button.dart';
import '../widgets/bottom_action_button.dart';
import '../widgets/delegates/sticky_delegate_header.dart';
import '../widgets/guest_selector.dart';

class GuestSelectionView extends ConsumerStatefulWidget {
  const GuestSelectionView({super.key});

  @override
  ConsumerState createState() => _GuessSelectionViewState();
}

class _GuessSelectionViewState extends ConsumerState<GuestSelectionView> {
  late ScrollController _scrollController;
  double _headerHeight = 0;
  final _hasScrolled = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_headerHeight == 0) {
      _headerHeight = context.findRenderObject()?.semanticBounds.height ?? 0;
    } else {
      _hasScrolled.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentGroupManager =
        ref.watch(currentGroupNotifierProvider.notifier);
    final currentGroup = ref.watch(currentGroupNotifierProvider);
    final enabled = currentGroup?.getFullList().any((guest) => guest.isPresent);

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SafeArea(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  leading: DListBackButton(
                    onPressed: () {
                      currentGroupManager.clear();
                    },
                  ),
                  title: Semantics(
                    label: guestSelectionTitle,
                    tooltip: 'Heading',
                    child: const Text(
                      guestSelectionTitle,
                    ),
                  ),
                  pinned: false,
                  centerTitle: !_hasScrolled.value,
                ),
                SliverPersistentHeader(
                  delegate: StickyHeaderDelegate(label: reservedLabel),
                  pinned: true, // Keep the header visible even when scrolled
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, ndx) {
                    if (currentGroupManager.getState() == null) {
                      return const Center(
                        child: Text('No Reserved Guests'),
                      );
                    } else if (currentGroupManager
                        .getState()!
                        .reservedGuests
                        .isEmpty) {
                      return const Center(
                        child: Text('No Reserved Guests'),
                      );
                    } else if (!currentGroupManager
                        .getState()!
                        .reservedGuests[ndx]
                        .isReserved) {
                      return const SizedBox.shrink(); // Skip unreserved guests
                    }
                    return GuestSelector(
                        groupSize: currentGroupManager
                                .getState()!
                                .reservedGuests
                                .length -
                            1,
                        index: ndx,
                        guest:
                            currentGroupManager.getState()!.reservedGuests[ndx],
                        onChanged: (guest) {
                          currentGroupManager.markGuestPresent(ref, guest);
                        });
                  },
                          childCount: currentGroupManager
                                  .getState()
                                  ?.reservedGuests
                                  .length ??
                              0)),
                ),
                SliverPersistentHeader(
                    delegate: StickyHeaderDelegate(label: unreservedLabel),
                    pinned: true),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, ndx) {
                    if (currentGroupManager.getState() == null) {
                      return const Center(
                        child: Text('No Unreserved Guests'),
                      );
                    } else if (currentGroupManager
                        .getState()!
                        .unreservedGuests
                        .isEmpty) {
                      return const Center(
                        child: Text('No Unreserved Guests'),
                      );
                    }
                    return GuestSelector(
                        groupSize: currentGroupManager
                                .getState()!
                                .unreservedGuests
                                .length -
                            1,
                        index: ndx,
                        guest: currentGroupManager
                            .getState()!
                            .unreservedGuests[ndx],
                        onChanged: (guest) {
                          currentGroupManager.markGuestPresent(ref, guest);
                        });
                  },
                          childCount: currentGroupManager
                                  .getState()
                                  ?.unreservedGuests
                                  .length ??
                              0)),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * .05,
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          height: 75,
                          alignment: Alignment.topCenter,
                          child: Icon(
                            Icons.info,
                            color:
                                Theme.of(context).textTheme.displaySmall?.color,
                            size: 13,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(
                            8.0,
                            0,
                            8.0,
                            16,
                          ),
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(
                            guestReservationWarning,
                            style: Theme.of(context).textTheme.displaySmall,
                            softWrap: true,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          BottomActionButton(
            label: continueLabel,
            enable: enabled ?? false,
            onPressed: () {
              currentGroupManager.hasConflictedCheckIn()
                  ? context.push(conflictScreenRoute)
                  : currentGroupManager.areGuestsCheckedInReserved()
                      ? () {
                          context.push(confirmationRoute);
                        }()
                      : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Semantics(
                            label: reservationNeededLabel,
                            tooltip: 'Alert',
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.topCenter,
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        reservationNeededLabel,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                      ),
                                      Text(
                                        reservationNeededText,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Colors.white,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context)
                                        .clearSnackBars();
                                  },
                                  icon: const Icon(
                                    Icons.cancel_rounded,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ));
            },
          ),
        ],
      ),
    );
  }
}
