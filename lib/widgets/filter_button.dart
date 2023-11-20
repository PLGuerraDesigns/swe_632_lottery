import 'package:flutter/material.dart';

/// A button that displays a dropdown menu of options when pressed.
class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.options,
    required this.tooltip,
  });

  /// The Callback function to be called when the button is pressed.
  final Function(String?)? onPressed;

  /// The icon to be displayed on the button.
  final IconData icon;

  /// The label to be displayed on the button.
  final String label;

  /// The list of options to be displayed in the dropdown menu.
  final List<String> options;

  /// The tooltip to be displayed when the button is hovered over.
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: Theme.of(context).colorScheme.outline, width: 0.75),
      ),
      child: DropdownButton<String>(
        borderRadius: BorderRadius.circular(8),
        dropdownColor: Theme.of(context).colorScheme.surfaceVariant,
        underline: Container(),
        focusColor: Colors.transparent,
        isDense: true,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        elevation: 0,
        value: label,
        onChanged: onPressed,
        items: <DropdownMenuItem<String>>[
          for (final String option in options)
            DropdownMenuItem<String>(
              value: option,
              child: Text(option.toUpperCase()),
            )
        ],
      ),
    );
  }
}
