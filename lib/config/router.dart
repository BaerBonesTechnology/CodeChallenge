import 'package:go_router/go_router.dart';
import 'package:the_d_list/constants/router_endpoints.dart';
import 'package:the_d_list/ui/main_screen.dart';


final GoRouter router = GoRouter(
  routes: [
    GoRoute(path: homeRoute,
    builder: (_, __) => HomeScreen())
  ]
);