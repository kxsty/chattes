import "package:chattes/ui/core/constants.dart";
import "package:flutter/material.dart";

void pushResponsivePage(
  BuildContext context,
  Widget child, {
  BoxConstraints? constraints,
}) {
  final mediaSize = MediaQuery.of(context).size;
  final theme = Theme.of(context);

  if (mediaSize.width < kScreenWidthThreshold) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => child));
  } else {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        constraints: constraints ?? const .expand(width: 512),
        shape: RoundedRectangleBorder(
          borderRadius: kPillBorderRadius,
          side: .new(color: theme.colorScheme.outlineVariant),
        ),
        clipBehavior: .antiAlias,
        child: child,
      ),
    );
  }
}
