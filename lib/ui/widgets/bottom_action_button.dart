import 'package:flutter/material.dart';
import 'package:the_d_list/constants/colors.dart';
import 'package:the_d_list/constants/padding_value.dart';

class BottomActionButton extends StatelessWidget {
  BottomActionButton({
    super.key,
    required this.enable,
    this.hint,
    required this.label,
    required this.onPressed,
  }) : _statesController = WidgetStatesController();

  final bool enable;
  final String? hint;
  final String label;
  final Function() onPressed;

  final WidgetStatesController _statesController;

  @override
  Widget build(BuildContext context) {
    _statesController.update(WidgetState.disabled, !enable);

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: MediaQuery.of(context).size.height * 0.09,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: PaddingValue.bottomLargePadding,
        child: Semantics(
          button: true,
          container: true,
          enabled: enable,
          hint: hint,
          label: label,
          onTap: () => onPressed(),
          child: ElevatedButton(
            onPressed: enable ? onPressed : null,
            statesController: _statesController,
            style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
              backgroundColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.disabled)) {
                    return inactiveBlue;
                  }
                  return primaryBlue;
                },
              ),
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}