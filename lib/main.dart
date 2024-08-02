import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_d_list/config/initialize_app.dart';
import 'package:the_d_list/config/router.dart';
import 'package:the_d_list/constants/strings.dart';

void main() {
  Bootstrapper.initializeApp().then((container) =>
      runApp(
        UncontrolledProviderScope(
            container: container,
            child: MaterialApp.router(
              title: appName,
              routerConfig: router,
            ))
      )
  );
}