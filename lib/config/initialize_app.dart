import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_d_list/providers/guest_providers.dart';


class Bootstrapper {
  static Future<ProviderContainer> initializeApp() async {
    final ProviderContainer container = ProviderContainer(
      overrides: [

      ]
    );

    return container;
  }
}