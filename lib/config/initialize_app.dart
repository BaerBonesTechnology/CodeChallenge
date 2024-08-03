import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_d_list/providers/controller/current_group_controller.dart';

import 'firebase_options.dart';
import '../providers/controller/guest_list_controller.dart';
import '../providers/guest_providers.dart';
import '../repo/impl/guest_repository_impl.dart';


class Bootstrapper {
  static Future<ProviderContainer> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final ProviderContainer container = ProviderContainer(
      overrides: [
        guestRepositoryProvider.overrideWith((ref) =>
        GuestRepositoryImpl(database: FirebaseFirestore.instance)
        ),
        guestListProvider.overrideWith(
            (ref) => GuestListController(guestRepo: ref.read(guestRepositoryProvider)),
        ),
        currentGroupNotifierProvider.overrideWith(
            (ref)=> CurrentGroupNotifier(null, guestRepo: ref.read(guestRepositoryProvider))
        ),
      ]
    );

    await container.read(guestListProvider.notifier).retrieveGroups();

    return container;
  }
}