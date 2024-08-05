import 'package:go_router/go_router.dart';

import '../constants/router_endpoints.dart';
import '../ui/views/guest_creation_view.dart';
import '../ui/views/guest_select_view.dart';
import '../ui/views/home_view.dart';

final GoRouter router = GoRouter(routes: [
    GoRoute(
    path: homeRoute,
    builder: (context, state) => const HomeView()),
  GoRoute(
    path: guestCreationRoute,
    builder: (_, __) => const GuestCreationView(),
  ),
  GoRoute(path: guestSelectionRoute,
  builder: (_, __) => const GuestSelectionView()),
  GoRoute(path: confirmationRoute,
  builder: (_,__) => const ConfirmationView()),
  GoRoute(path: conflictScreenRoute,
  builder: (_,__)=> const ConflictView()),
]);
