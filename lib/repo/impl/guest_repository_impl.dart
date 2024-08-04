import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants/strings.dart';
import '../../models/guest.dart';
import '../../models/guest_group.dart';
import '../guest_repository.dart';

class GuestRepositoryImpl extends GuestRepository {
  GuestRepositoryImpl({required this.database});

  final FirebaseFirestore database;

  @override
  void createGroup(List<Guest> guests, {String? name}) async {
    final group = GuestGroup(
        name: name ?? guests[0].name.split(' ').last,
        reservedGuests:
            guests.where((element) => element.isReserved == true).toList(),
        unreservedGuests:
            guests.where((element) => element.isReserved == false).toList());

    await addGuestGroup(group);
  }

  @override
  Future<void> addGuestGroup(GuestGroup group) async {
    String? altName;

    await database
        .collection(mainListPath)
        .doc('${group.name}_${group.id}').get().then((snapshot) async {
      if (snapshot.exists) {
        final docId = snapshot.get('id');
        if (docId == group.id) {
          final existingGroup = GuestGroup.fromJson(snapshot.data()!);

          // Merge reserved guests
          final reservedGuests = [
            ...existingGroup.reservedGuests,
            ...group.reservedGuests
          ];

          // Merge unreserved guests
          final unreservedGuests = [
            ...existingGroup.unreservedGuests,
            ...group.unreservedGuests
          ];

          // Update the group with merged lists
          final updatedGroup = group.copyWith(
            reservedGuests: reservedGuests,
            unreservedGuests: unreservedGuests,
          );

          if(verifyGroup(group)) {
            await database
                .collection(mainListPath)
                .doc('${group.name}_${group.id}')
                .set(updatedGroup.toJson());
          }
        } else {
          final nameSplit = group.name.split(' ');
          altName = '${nameSplit.last} ${nameSplit.first}';
          group = group.copyWith(
            name: altName,
          );
        }
      }
    });

    if(verifyGroup(group)){
      await database
          .collection(mainListPath)
          .doc('${group.name}_${group.id}')
          .set(group.toJson());
    }
  }

  @override
  Future<List<GuestGroup>> retrieveGroups() async {
    final snapshot = await database.collection(mainListPath)
        .where('id', isNull: false)
        .get();

    if (snapshot.docs.isNotEmpty) {
      guestGroups = snapshot.docs.map((doc) => GuestGroup.fromJson(doc.data())).toList();
      guestGroups.removeWhere((element) => element.cleared == true); // Remove cleared groups
    } else {
      guestGroups.clear();
    }

    return guestGroups;
  }

  @override
  Future<void> clearGroup(GuestGroup group) async {
    await database
        .collection(mainListPath)
        .doc("${group.name}_${group.id}")
        .set(group.copyWith(cleared: true).toJson());
    guestGroups.remove(group);
  }

  @override
  Future<void> deleteGroup(GuestGroup group) async {
    await database
        .collection(mainListPath)
        .doc("${group.name}_${group.id}")
        .delete();
    guestGroups.remove(group);
  }

  @override
  void updateGroup(GuestGroup group) async {
    await database
        .collection(mainListPath)
        .doc('${group.name}_${group.id}')
        .set(group.toJson());
  }

  @override
  bool verifyGroup(GuestGroup group){
    final reservedTestGroup = group.reservedGuests.where((element) => !element.isReserved);
    final unreservedTestGroup = group.unreservedGuests.where((element) => element.isReserved);

    if(reservedTestGroup.isEmpty && unreservedTestGroup.isEmpty){
      return true;
    }else{
      for (var guest in reservedTestGroup) {
        group.reservedGuests.remove(guest);
      }
      for(var guest in unreservedTestGroup){
        group.reservedGuests.remove(guest);
      }
      verifyGroup(group);
    }
    return false;
  }
}
