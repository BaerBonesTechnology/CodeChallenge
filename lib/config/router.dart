import 'package:go_router/go_router.dart';

import '../constants/router_endpoints.dart';
import '../ui/views/guest_creation_view.dart';
import '../ui/views/guest_select_view.dart';
import '../ui/views/home_view.dart';

final GoRouter router = GoRouter(routes: [
    GoRoute(
    path: homeRoute,
    builder: (context, state) => HomeView()),
  GoRoute(
    path: guestCreationRoute,
    builder: (_, __) => const GuestCreationView(),
  ),
  GoRoute(path: guestSelectionRoute,
  builder: (_, __) => const GuestSelectionView())
]);
