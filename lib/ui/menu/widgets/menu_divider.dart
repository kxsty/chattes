import "package:chattes/ui/core/constants.dart";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

class MenuDivider extends StatelessWidget {
  const MenuDivider({super.key, required this.onHorizontalOffestUpdate});

  final void Function(double)? onHorizontalOffestUpdate;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragUpdate: (d) =>
            onHorizontalOffestUpdate?.call(d.globalPosition.dx),
        onHorizontalDragEnd: (d) async {
          final instance = await SharedPreferences.getInstance();

          instance.setDouble("sidebar_width", d.globalPosition.dx);
        },
        child: kVerticalDivider,
      ),
    );
  }
}
