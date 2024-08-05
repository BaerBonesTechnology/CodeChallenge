import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/padding_value.dart';
import '../../constants/strings.dart';
import '../widgets/back_button.dart';

class ConflictView extends ConsumerWidget {
  const ConflictView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: const DListBackButton(),
        title: const Text(conflictScreenLabel),
      ),
      body: Padding(
        padding: PaddingValue.defaultPadding,
        child: Center(
          child: Text(
            conflictScreenMessage,
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
      ),
    );
  }
}
