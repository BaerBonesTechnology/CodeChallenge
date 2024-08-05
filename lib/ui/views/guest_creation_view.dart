import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/keys.dart';
import '../../constants/padding_value.dart';
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
        leading: DListBackButton(
          onPressed: () async {
            _guestEntryNameController.clear();
            currentGroup.clear();
            await ref.read(guestListProvider.notifier).retrieveGroups();
            ref.read(tempGroupListProvider.notifier).state = [];
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
                padding: PaddingValue.small,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Checkbox(
                      activeColor: Colors.green,
                      key: reserveGuestCheckboxKey,
                      onChanged: (value) {
                        ref.read(tempReservedProvider.notifier).state = value!;
                      },
                      value: ref.watch(tempReservedProvider),
                    ),
                    const Text('Reserve'),
                    const Spacer(),
                    IconButton.filledTonal(
                      icon: const Icon(Icons.add),
                      key: createGuestButtonKey,
                      onPressed: () async {
                        currentGroup.addGuest(
                          ref,
                          name: _guestEntryNameController.text,
                          isReserved:
                              ref.read(tempReservedProvider.notifier).state,
                        );
                        _guestEntryNameController.clear();
                      },
                    )
                  ],
                ),
              ),
              SizedBox(
                height: size.height * .7,
                width: size.width,
                child: Padding(
                  padding: PaddingValue.small,
                  child: ListView.builder(
                    controller: listScrollController,
                    itemBuilder: (context, ndx) {
                      return GuestCreationListTile(
                          isReserved:
                              ref.read(tempGroupListProvider)[ndx].isReserved,
                          name: ref.read(tempGroupListProvider)[ndx].name,
                          onDelete: () {
                            currentGroup.removeGuest(ref, index: ndx);
                          });
                    },
                    itemCount: groupList.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
      bottomNavigationBar: BottomActionButton(
        enable: enabled,
        label: saveGroupLabel,
        onPressed: () async {
          if (currentGroup.getState() != null) {
            ref.read(guestListProvider.notifier).addGuestGroup(ref);
            _guestEntryNameController.clear();
            ref.read(currentGroupNotifierProvider.notifier).clear();
            ref.read(tempGroupListProvider.notifier).state = [];
            await ref.read(guestListProvider.notifier).retrieveGroups();
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
