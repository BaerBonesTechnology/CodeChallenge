import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/router_endpoints.dart';
import '../../constants/strings.dart';
import '../../providers/guest_providers.dart';
import '../widgets/guest_group_Selection.dart';

class HomeView extends ConsumerStatefulWidget {
  HomeView({super.key,});

  final homeAppBar = AppBar(
    title: const Text(appName),
    centerTitle: true,
  );

  final emptyListView = const Center(
    child: Column(
      children: [
        Text(
          '?',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
        ),
        Text('Hmm, No Guests'),
      ],
    ),
  );

  @override
  ConsumerState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final reservationController = ref.watch(guestListProvider);
    final currentGroup = ref.watch(currentGroupNotifierProvider.notifier);

    return Scaffold(
      appBar: widget.homeAppBar,
      body: reservationController.when(
        data: (guestGroups) {
          return guestGroups.isEmpty
              ? widget.emptyListView
              : ListView.builder(
                  itemBuilder: (context, ndx) {
                    return GuestGroupSelection(
                      group: guestGroups[ndx],
                      onSelect: (group) {
                        currentGroup.chooseGroup(group);
                        context.push(guestSelectionRoute);
                      },
                      onDelete: (group) {
                        reservationController.value?.remove(group);
                      },
                    );
                  },
                  itemCount: guestGroups.length,
                );
        },
        error: (e, stack) {
          return Center(
              heightFactor: size.height,
              widthFactor: size.width,
              child: widget.emptyListView);
        },
        loading: () {
          return Center(
            heightFactor: size.height,
            widthFactor: size.width,
            child: const CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(guestCreationRoute),
        child: const Icon(Icons.add),
      ),
    );
  }
}
