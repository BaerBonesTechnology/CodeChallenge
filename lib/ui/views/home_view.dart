import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_d_list/ui/widgets/bottom_action_button.dart';

import '../../constants/router_endpoints.dart';
import '../../constants/strings.dart';
import '../../models/guest_group.dart';
import '../../providers/creation_view_providers.dart';
import '../../providers/guest_providers.dart';
import '../widgets/guest_group_selection.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({
    super.key,
  });

  @override
  ConsumerState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final reservationController = ref.watch(guestListProvider);
    final currentGroup = ref.watch(currentGroupNotifierProvider.notifier);

    if (reservationController.isLoading) {
      ref.read(guestListProvider.notifier).retrieveGroups();
    }

    return Scaffold(
      appBar: AppBar(
        title: Semantics(
            header: true,
            label: appName,
            tooltip: 'Heading',
            child: Text(
              appName,
              style: Theme.of(context).textTheme.displayMedium,
            )),
        centerTitle: true,
      ),
      body: reservationController.when(
        data: (guestGroups) {
          return guestGroups.isEmpty
              ? Center(
                  child: Column(
                    children: [
                      Text(
                        '?',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Text('Hmm, No Guests',
                          style: Theme.of(context).textTheme.displayLarge),
                    ],
                  ),
                )
              : ListView.builder(
                  itemBuilder: (context, ndx) {
                    return GuestGroupSelection(
                      group: guestGroups[ndx],
                      onSelect: (group) {
                        currentGroup.chooseGroup(group);
                        context.push(guestSelectionRoute);
                      },
                      onDelete: (group) {
                        ref.read(guestListProvider.notifier).deleteGroup(group);
                      },
                      onEditSwipe: (GuestGroup group) {
                        currentGroup.chooseGroup(group);
                        final tempList = [
                          ...currentGroup.getState()!.reservedGuests
                        ];
                        tempList
                            .addAll(currentGroup.getState()!.unreservedGuests);
                        ref.read(tempGroupListProvider.notifier).state =
                            tempList;
                        context.push(guestCreationRoute);
                      },
                    );
                  },
                  itemCount: guestGroups.length,
                );
        },
        error: (e, stack) {
          return Center(
            child: Column(
              children: [
                Text(
                  '?',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Text('Hmm, No Guests',
                    style: Theme.of(context).textTheme.displayLarge),
              ],
            ),
          );
        },
        loading: () {
          return Center(
            heightFactor: size.height,
            widthFactor: size.width,
            child: const CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: BottomActionButton(
        enable: true,
        label: addNewGroupLabel,
        onPressed: () {
          context.push(guestCreationRoute);
        },
      ),
    );
  }
}
