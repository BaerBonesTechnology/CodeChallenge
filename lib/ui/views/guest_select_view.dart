import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_d_list/providers/guest_providers.dart';
import 'package:the_d_list/ui/widgets/guest_selector.dart';

import '../../constants/strings.dart';

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
    final currentGroup = ref.read(currentGroupNotifierProvider.notifier);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            leading: _hasScrolled.value ? null : IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  currentGroup.clear();
                  context.pop();
                }),
            title: Text(_appBarTitle),
            pinned: true,
            centerTitle: !_hasScrolled.value,
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 50, // Example header height
              child: Text(
                reservedLabel,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, ndx) {
            if (currentGroup.getState() == null) {
              throw Exception('NULL GROUP OBJECT');
            }
            return GuestSelector(
                guest: currentGroup.getState()!.reservedGuests[ndx],
                onChanged: (guest) {
                  currentGroup.markGuestPresent(ref, guest);
                });
          }, childCount: currentGroup.getState()?.reservedGuests.length ?? 0)),
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.1, // Example header height
              child: const Text(
                unreservedLabel,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, ndx) {
            if (currentGroup.getState() == null) {
              throw Exception('NULL GROUP OBJECT');
            }
            return GuestSelector(
                guest: currentGroup.getState()!.unreservedGuests[ndx],
                onChanged: (guest) {});
          },
                  childCount:
                      currentGroup.getState()?.unreservedGuests.length ?? 0)),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.blue),
              elevation: WidgetStateProperty.all(0),
              foregroundColor: WidgetStateProperty.all(Colors.white),
            ),
            child: const Text(continueLabel),
          ),
        ),
      ),
    );
  }
}
