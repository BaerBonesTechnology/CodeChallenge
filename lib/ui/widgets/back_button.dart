import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/keys.dart';

class DListBackButton extends StatelessWidget {
  const DListBackButton({super.key, this.onPressed});

  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: true,
      hint: 'Go to previous screen',
      key: backButtonKey,
      label: 'Back Button',
      onTap: () {
        onPressed != null ? onPressed!() : DoNothingAction();
        context.pop();
      },
      child: IconButton(
          onPressed: () {
            onPressed != null ? onPressed!() : DoNothingAction();
            context.pop();
          },
          icon: Icon(
            Icons.chevron_left_rounded,
            color: Colors.blue[700],
            size: 32,
          )),
    );
  }
}
