import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_d_list/constants/router_endpoints.dart';
import 'package:the_d_list/constants/strings.dart';
import 'package:the_d_list/providers/controller/current_group_controller.dart';
import 'package:the_d_list/providers/guest_providers.dart';
import 'package:the_d_list/ui/widgets/guest_group_selection.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservationController = ref.watch(guestListProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          appName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: reservationController.guestGroups.isEmpty
          ? SizedBox(
        height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: const Center(
                    child: Column(
            children: [
              Text('?', style: TextStyle(
                fontSize: 32,
              ),),
              Text('Hmm? No Guests')
            ],
                    ),
                  ),
          )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reservationController.guestGroups.length,
              itemBuilder: (context, ndx) {
                return GuestGroupSelection(
                    group: reservationController.guestGroups[ndx],
                    onDelete: (group) {
                      ref
                          .read(currentGroupControllerProvider.notifier)
                          .chooseGroup(group);
                      context.go(guestSelectionRoute);
                    },
                    onSelect: (group) {
                      reservationController.removeGroup(group);
                    });
              },
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Adds a new Guest/Group",
        onPressed: () {
          context.go(guestCreationRoute);
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
