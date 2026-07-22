import "package:flutter/material.dart";

void pushResponsivePage(
  BuildContext context,
  Widget child, {
  double width = 512,
}) {
  final mediaSize = MediaQuery.of(context).size;
  final theme = Theme.of(context);

  if (mediaSize.width < 700) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => child));
  } else {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: const .all(.circular(20)),
          side: .new(color: theme.colorScheme.outlineVariant),
        ),
        contentPadding: .zero,
        clipBehavior: .antiAlias,
        content: SizedBox(width: width, child: child),
      ),
    );
  }
}
