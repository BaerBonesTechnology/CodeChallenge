import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_d_list/providers/controller/current_group_controller.dart';
import 'package:the_d_list/providers/controller/guest_list_controller.dart';
import 'package:the_d_list/providers/guest_providers.dart';
import 'package:the_d_list/repo/impl/guest_repository_impl.dart';
import 'package:the_d_list/ui/style.dart';

import 'config/firebase_options.dart';
import 'config/router.dart';
import 'constants/strings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((_) {

    final overrides = [
      guestRepositoryProvider.overrideWith(
          (ref) => GuestRepositoryImpl(database: FirebaseFirestore.instance)),
      guestListProvider.overrideWith(
        (ref) =>
            GuestListController(guestRepo: ref.read(guestRepositoryProvider)),
      ),
      currentGroupNotifierProvider.overrideWith((ref) => CurrentGroupNotifier(
          null,
          guestRepo: ref.read(guestRepositoryProvider))),
    ];

    runApp(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp.router(
          showSemanticsDebugger: false,   //kDebugMode,
          theme: dListThemeData,
          title: appName,
          routerConfig: router,
        ),
      ),
    );
  });
}
