import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_d_list/constants/strings.dart';
import 'package:the_d_list/ui/widgets/bottom_action_button.dart';

import '../../providers/creation_view_providers.dart';
import '../../providers/guest_providers.dart';
import '../widgets/backButton.dart';
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
    var currentGroup = ref.watch(currentGroupNotifierProvider.notifier);
    final size = MediaQuery.of(context).size;
    bool enabled = currentGroup.getState() != null
        ? currentGroup.getState()!.unreservedGuests.isNotEmpty ||
            currentGroup.getState()!.reservedGuests.isNotEmpty
        : false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Creation'),
        centerTitle: true,
        leading: DListBackButton(
          onPressed: () {
            _guestEntryNameController.clear();
            currentGroup.clear();
            groupList.clear();
            context.pop();
          },
        ),
      ),
      body: Stack(children: [
        SingleChildScrollView(
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
                          ref.read(tempReservedProvider.notifier).state =
                              value!;
                        }),
                    const Text('Reserve'),
                    const Spacer(),
                    IconButton.filledTonal(
                      onPressed: () async {
                        currentGroup.addGuest(
                          ref,
                          name: _guestEntryNameController.text,
                          isReserved:
                              ref.read(tempReservedProvider.notifier).state,
                        );
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
                          name: ref.read(tempGroupListProvider)[ndx].name,
                          onDelete: () {
                            if (ndx >= 0 && ndx < groupList.length) {
                              final guest = groupList[ndx];
                              ref.read(tempGroupListProvider.notifier).state =
                                  groupList.where((g) => g != guest).toList();
                              currentGroup.removeGuest(ref, guest: guest);
                            }
                          },
                        );
                      },
                      itemCount: groupList.length,
                    ),
                  )),
            ],
          ),
        ),
      ]),
      bottomNavigationBar: BottomActionButton(
        label: saveGroupLabel,
        enable: enabled,
        onPressed: () async {
          try {
            if (currentGroup.getState() != null &&
                (currentGroup.getState()!.reservedGuests.isNotEmpty ||
                    currentGroup.getState()!.unreservedGuests.isNotEmpty)) {
              ref
                  .read(guestListProvider.notifier)
                  .addGuestGroup(currentGroup.getState()!);
              _guestEntryNameController.clear();
              currentGroup.clear();
              groupList.clear();
              context.pop();
            } else {
              throw Exception('Add a guest or group to proceed');
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Add a guest or group to proceed'),
                elevation: 10,
              ),
            );
          }
        },
      ),
    );
  }
}
