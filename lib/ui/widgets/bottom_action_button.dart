import 'package:flutter/material.dart';

class BottomActionButton extends StatelessWidget {
  const BottomActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.enable,
  });

  final String label;
  final Function() onPressed;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.09,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: ElevatedButton(
          statesController: _buttonStateController(enable),
          onPressed:
              enable ? onPressed : null,
          style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return Colors.grey; // Disabled color
                }
                return Color(Colors.blue[800]?.value ?? 0xFF1565C0);
              },
            ),
          ),
          child: Text(label),
        ),
      ),
    );
  }

  WidgetStatesController _buttonStateController(bool enabled) =>
      WidgetStatesController(<WidgetState>{if (!enabled) WidgetState.disabled});
}
