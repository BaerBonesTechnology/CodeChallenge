import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_d_list/constants/router_endpoints.dart';
import 'package:the_d_list/providers/guest_providers.dart';
import 'package:the_d_list/ui/widgets/backButton.dart';
import 'package:the_d_list/ui/widgets/bottom_action_button.dart';
import 'package:the_d_list/ui/widgets/guest_selector.dart';

import '../../constants/strings.dart';
import '../../models/guest.dart';
import '../widgets/delegates/sticky_delegate_header.dart';

class GuestSelectionView extends ConsumerStatefulWidget {
  const GuestSelectionView({super.key});

  @override
  ConsumerState createState() => _GuessSelectionViewState();
}

class _GuessSelectionViewState extends ConsumerState<GuestSelectionView> {
  late ScrollController _scrollController;
  final String _appBarTitle = guestSelectionTitle;
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
    final currentGroup = ref.watch(currentGroupNotifierProvider.notifier);
    final enabled = ref.watch(isEnabledProvider);
    final guestProvider = ref.watch(guestProviders).putIfAbsent(
        Guest(name: '', isReserved: false),
        () => StateProvider((ref) => false));

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SafeArea(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  leading:  DListBackButton(
                    onPressed: () {
                      currentGroup.clear();
                    },
                  ),
                  title: Semantics(
                    label: _appBarTitle,
                    tooltip: 'Heading',
                    child: Text(
                      _appBarTitle,
                      style: Theme.of(context).textTheme.displayMedium,
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
                    if (currentGroup.getState() == null) {
                      throw Exception('NULL GROUP OBJECT');
                    }
                    return GuestSelector(
                        guest: currentGroup.getState()!.reservedGuests[ndx],
                        onChanged: (guest) {
                          ref.read(isEnabledProvider.notifier).state =
                              currentGroup.markGuestPresent(ref, guest);
                          ref.read(guestProvider.notifier).state =
                              guest.isPresent;
                        },
                      groupSize: currentGroup.getState()!.reservedGuests.length,
                      index: ndx,
                    );
                  },
                          childCount:
                              currentGroup.getState()?.reservedGuests.length ??
                                  0)),
                ),
                SliverPersistentHeader(
                    delegate: StickyHeaderDelegate(label: unreservedLabel),
                    pinned: true),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, ndx) {
                    if (currentGroup.getState() == null) {
                      return const Center(
                        child: Text('No Unreserved Guests'),
                      );
                    }
                    return GuestSelector(
                      groupSize: currentGroup.getState()!.unreservedGuests.length - 1,
                        index: ndx,
                        guest: currentGroup.getState()!.unreservedGuests[ndx],
                        onChanged: (guest) => ref
                            .read(isEnabledProvider.notifier)
                            .state = currentGroup.markGuestPresent(ref, guest));
                  },
                          childCount: currentGroup
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
            enable: ref.watch(isEnabledProvider),
            onPressed: () {
              currentGroup.hasConflictedCheckin() ? context.push(conflictScreenRoute):
                  currentGroup.areGuestsCheckedInReserved() ? context.push(confirmationRoute):
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reservationNeededLabel,
                              style:
                                  Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                            ),
                            Text(
                              reservationNeededText,
                              style:
                                  Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.white,
                                      ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).clearSnackBars();
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
