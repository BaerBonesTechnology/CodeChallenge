import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/initialize_app.dart';
import 'config/router.dart';
import 'constants/strings.dart';

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