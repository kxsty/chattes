import "package:flutter/material.dart";

class LetterAvatar extends StatelessWidget {
  const LetterAvatar({super.key, required this.title, this.radius});

  final String title;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = _stringToColor(title);

    return CircleAvatar(
      backgroundColor: bgColor,
      radius: radius,
      child: Center(
        child: Text(
          title.characters.toUpperCase().first,
          style: theme.textTheme.titleMedium,
        ),
      ),
    );
  }

  Color _stringToColor(String input) {
    const goldenAngle = 137.50776405;
    final hue = (input.hashCode * goldenAngle) % 360.0;
    return HSLColor.fromAHSL(0.5, hue, 0.5, 0.5).toColor();
  }
}
