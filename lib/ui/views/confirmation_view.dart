import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/router_endpoints.dart';
import '../../constants/strings.dart';
import '../widgets/back_button.dart';

class ConfirmationView extends ConsumerWidget {
  const ConfirmationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(
        leading: DListBackButton(
          onPressed: () async {
            context.go(homeRoute);
          },
        ),
        title: const Text(confirmationScreenLabel),

      ),
      body: Center(
        child: Text(
          confirmationScreenMessage,
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}
