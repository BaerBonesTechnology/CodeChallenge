import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../constants/strings.dart';
import '../../models/guest.dart';
import '../../models/guest_group.dart';
import '../guest_repository.dart';

class GuestRepositoryImpl extends GuestRepository {
  GuestRepositoryImpl({required this.database});

  final FirebaseFirestore database;

  @override
  void createGroup(List<Guest> guests, {String? name}) async {
    const uuid = Uuid();
    final id = uuid.v1();
    final group = GuestGroup(id,
        name: name ?? guests[0].name.split(' ').last,
        reservedGuests:
            guests.where((element) => element.isReserved == true).toList(),
        unreservedGuests:
            guests.where((element) => element.isReserved == false).toList());



    await addGuestGroup(group);
  }

  @override
  Future<void> addGuestGroup(GuestGroup group) async {
      await database
          .collection(mainListPath)
          .doc('${group.name}_${group.id}')
          .set(group.toJson());
      guestGroups.add(group);
  }

  @override
  void removeGroup(GuestGroup group) {
    guestGroups.remove(group);
  }

  @override
  Future<List<GuestGroup>> retrieveGroups() async {
    final snapshot = await database.collection(mainListPath).where('id', isNull: false).get();
    if (snapshot.docs.isNotEmpty) {
      final tempGroup = <GuestGroup>[];
      for (final doc in snapshot.docs) {
        final guestGroup = GuestGroup.fromJson(doc.data());
        final registeredGuest = guestGroups.where((element) => element.id == guestGroup.id); // Check against guestGroups
        if (registeredGuest.isEmpty) {
          tempGroup.add(guestGroup);
        }
      }
      guestGroups.addAll(tempGroup);
    } else {
      guestGroups.clear();
    }
    return guestGroups;
  }
}
