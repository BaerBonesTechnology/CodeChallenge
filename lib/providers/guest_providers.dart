import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/guest.dart';
import '../models/guest_group.dart';
import '../repo/guest_repository.dart';
import '../repo/impl/guest_repository_impl.dart';
import 'controller/current_group_controller.dart';
import 'controller/guest_list_controller.dart';

final currentGroupNotifierProvider =
    StateNotifierProvider<CurrentGroupNotifier, GuestGroup?>((ref) =>
        CurrentGroupNotifier(null,
            guestRepo: ref.read(guestRepositoryProvider)),
    );

final guestListProvider =
    StateNotifierProvider<GuestListController, AsyncValue<List<GuestGroup>>>(
        (ref) =>
            GuestListController(guestRepo: ref.read(guestRepositoryProvider)));

final Provider<GuestRepository> guestRepositoryProvider = Provider(
    (ref) => GuestRepositoryImpl(database: FirebaseFirestore.instance));

final guestProviders = Provider((ref) => <Guest, StateProvider<bool>>{});

final isEnabledProvider = StateProvider((ref) => false);