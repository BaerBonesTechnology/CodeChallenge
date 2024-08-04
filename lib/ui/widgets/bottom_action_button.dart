import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Semantics(
          button: true,
          container: true,
          enabled: enable,
          hint: hint,
          label: label,
          key: Key('${key.toString()} Action Button'),
          onTap: () => onPressed(),
          child: ElevatedButton(
            onPressed: enable ? onPressed : null,
            statesController: _statesController,
            style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
              backgroundColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.disabled)) {
                    return Colors.blueGrey.shade300; // Disabled color
                  }
                  return Color(Colors.blue[800]?.value ?? 0xFF1565C0);
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
