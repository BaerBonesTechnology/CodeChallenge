import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/router_endpoints.dart';
import '../../constants/strings.dart';
import '../../models/guest_group.dart';
import '../../providers/guest_providers.dart';
import '../widgets/bottom_action_button.dart';
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
    final currentGroup = ref.watch(currentGroupNotifierProvider.notifier);

    return Consumer(// Wrap with Consumer
        builder: (context, ref, child) {
      var reservationController = ref.watch(guestListProvider);
      ref.watch(guestListProvider.notifier).retrieveGroups();

      return Scaffold(
        appBar: AppBar(
          title: Semantics(
              header: true,
              label: appName,
              tooltip: 'Heading',
              child: const Text(
                appName,
              )),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            reservationController = ref.refresh(guestListProvider);
            await ref.read(guestListProvider.notifier).retrieveGroups();
            },
          child: reservationController.when(
              data: (guestGroups) {
                return guestGroups.isEmpty
                    ? Center(
                      child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                              currentGroup.chooseGroup(ref, group);
                              context.push(guestSelectionRoute);
                            },
                            onDelete: (group) {
                              ref
                                  .read(guestListProvider.notifier)
                                  .deleteGroup(group);
                            },
                            onEditSwipe: (GuestGroup group) {
                              currentGroup.chooseGroup(ref, group);
                              context.push(guestCreationRoute);
                            },
                          );
                        },
                        itemCount: guestGroups.length,
                      );
              },
              error: (e, stack) {
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
                                connectionErrorLabel,
                                style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                connectionErrorText,
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
        ),
        bottomNavigationBar: BottomActionButton(
          enable: true,
          label: addNewGroupLabel,
          onPressed: () {
            context.push(guestCreationRoute);
          },
        ),
      );
    });
  }
}
