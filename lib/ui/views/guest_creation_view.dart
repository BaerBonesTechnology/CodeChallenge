import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/strings.dart';
import '../../providers/creation_view_providers.dart';
import '../../providers/guest_providers.dart';
import '../widgets/back_button.dart';
import '../widgets/bottom_action_button.dart';
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
    ref.watch(currentGroupNotifierProvider);
    final groupList = ref.watch(tempGroupListProvider);
    final currentGroup = ref.watch(currentGroupNotifierProvider.notifier);
    final size = MediaQuery.of(context).size;

    bool enabled = groupList.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text(creationScreenString),
        centerTitle: true,
        leading: DListBackButton(
          onPressed: () async {
            _guestEntryNameController.clear();
            currentGroup.clear();
            await ref.read(guestListProvider.notifier).retrieveGroups();
            ref.read(tempGroupListProvider.notifier).state = [];
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
                          isReserved: ref.read(tempGroupListProvider)[ndx].isReserved,
                            name: ref.read(tempGroupListProvider)[ndx].name,
                            onDelete: () {
                              currentGroup.removeGuest(ref,
                                  index: ndx);
                            });
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
          if (currentGroup.getState() != null) {
            ref.read(guestListProvider.notifier).addGuestGroup(ref);
            _guestEntryNameController.clear();
            ref.read(currentGroupNotifierProvider.notifier).clear();
            ref.read(tempGroupListProvider.notifier).state = [];
            await ref.read(guestListProvider.notifier).retrieveGroups();
            context.pop();
          } else {
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
