import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/creation_screen_providers.dart';
import '../../providers/guest_providers.dart';
import '../widgets/user_creation_list_tile.dart';

class GuestCreationView extends ConsumerStatefulWidget {
  const GuestCreationView({super.key});

  @override
  ConsumerState createState() => _GuestCreationScreenState();
}

class _GuestCreationScreenState extends ConsumerState<GuestCreationView> {
  final TextEditingController _guestEntryNameController =
      TextEditingController();
  final ScrollController listScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var groupList = ref.watch(tempGroupListProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Creation'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            _guestEntryNameController.clear();
            currentGroupNotifierProvider.clear();
            groupList.clear();
            context.pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text('Add Guests Name'),
            SizedBox(
              height: (size.height * .08).clamp(50, 150),
              width: size.width * .8,
              child: TextFormField(
                controller: _guestEntryNameController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Checkbox(
                      activeColor: Colors.green,
                      value: ref.watch(tempReservedProvider),
                      onChanged: (value) {
                        ref.read(tempReservedProvider.notifier).state = value!;
                      }),
                  const Text('Reserve'),
                  const Spacer(),
                  IconButton.filledTonal(
                    onPressed: () async {
                      final guest = currentGroupNotifierProvider.addGuest(
                        name: _guestEntryNameController.text,
                        isReserved:
                            ref.read(tempReservedProvider.notifier).state,
                      );
                      final updatedList = [
                        ...groupList,
                        guest
                      ]; // Create a new list with the added guest
                      ref.read(tempGroupListProvider.notifier).state = updatedList; // Update the state
                      _guestEntryNameController.clear();
                    },
                    icon: const Icon(Icons.add),
                  )
                ],
              ),
            ),
            SizedBox(
                height: size.height * .7,
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    controller: listScrollController,
                    itemBuilder: (context, ndx) {
                      return GuestCreationListTile(
                          name:
                              ref.watch(tempGroupListProvider)[ndx].name,
                          onDelete: () {
                            if (ndx > 0 && ndx < groupList.length) {
                              final guest = groupList[ndx];
                              groupList.removeAt(ndx);
                              currentGroupNotifierProvider.removeGuest(guest);
                            }
                          });
                    },
                    itemCount: groupList.length,
                  ),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade600,
        onPressed: () async {
          try {
            if (currentGroupNotifierProvider.getState() != null) {
              ref
                  .read(guestListProvider.notifier)
                  .addGuestGroup(currentGroupNotifierProvider.getState()!);
              _guestEntryNameController.clear();
              currentGroupNotifierProvider.clear();
              groupList.clear();
              context.pop();
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Add a guest or group to proceed')),
            );
          }
        },
        child: const Icon(Icons.arrow_right_alt_rounded),
      ),
    );
  }
}
