import 'package:flutter/material.dart';

class BottomActionButton extends StatelessWidget {
  BottomActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.enable,
    this.hint,
  }) : _statesController = WidgetStatesController();

  final String label;
  final Function() onPressed;
  final bool enable;
  final String? hint;
  final WidgetStatesController _statesController;

  @override
  Widget build(BuildContext context) {
    _statesController.update(WidgetState.disabled, !enable);

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.09,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Semantics(
          key: Key('${key.toString()} Action Button'),
          enabled: enable,
          label: label,
          hint: hint,
          button: true,
          container: true,
          onTap: () => onPressed(),
          child: ElevatedButton(
            statesController: _statesController,
            onPressed: enable ? onPressed : null,
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
