
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_d_list/config/router.dart';
import 'package:the_d_list/constants/keys.dart';
import 'package:the_d_list/constants/router_endpoints.dart';
import 'package:the_d_list/constants/strings.dart';
import 'package:the_d_list/providers/controller/current_group_controller.dart';
import 'package:the_d_list/providers/controller/guest_list_controller.dart';
import 'package:the_d_list/providers/guest_providers.dart';
import 'package:the_d_list/repo/fakeImpl/guest_repository_fake_impl.dart';
import 'package:the_d_list/ui/views/guest_creation_view.dart';

void main() {
    group('Home Screen tests', () {
      late List<Override> overrides;

      setUpAll(() {
        TestWidgetsFlutterBinding.ensureInitialized();
        overrides = [
          guestRepositoryProvider
              .overrideWith((ref) => FakeGuestRepositoryImpl()),
          guestListProvider.overrideWith(
            (ref) => GuestListController(
                guestRepo: ref.read(guestRepositoryProvider)),
          ),
          currentGroupNotifierProvider.overrideWith((ref) =>
              CurrentGroupNotifier(null,
                  guestRepo: ref.read(guestRepositoryProvider))),
        ];
      });

      testWidgets('Home Screen initializes correctly', (tester) async {

        await tester.pumpWidget(
          ProviderScope(
            overrides: overrides,
            child: MaterialApp.router(
              routerConfig: router,
              title: appName,
            )
          ),
        );

        final appBarFinder =find.byKey(homeHeadingKey);
        expect(appBarFinder, findsOne);

        final buttonFinder = find.byKey(addGuestButtonKey);
        expect(buttonFinder, findsOne);

      });

      testWidgets('Guest Creation Screen initializes correctly', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
              overrides: overrides,
              child: const MaterialApp(
                home: GuestCreationView(),
                title: appName,
              )
          ),
        );

        final addGuestButtonFinder = find.byKey(createGuestButtonKey);
        expect(addGuestButtonFinder, findsOne);
      });
    });
}
