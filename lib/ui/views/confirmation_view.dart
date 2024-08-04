import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_d_list/constants/router_endpoints.dart';

import '../../constants/strings.dart';
import '../../providers/guest_providers.dart';
import '../widgets/back_button.dart';

class ConfirmationView extends ConsumerWidget {
  const ConfirmationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentGroupManager = ref.read(currentGroupNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(confirmationScreenLabel),
        leading: DListBackButton(
          onPressed: () async {
            context.go(homeRoute);
          },
        ),
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
