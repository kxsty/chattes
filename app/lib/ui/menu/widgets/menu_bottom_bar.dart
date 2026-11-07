import "package:chattes/ui/core/constants.dart";
import "package:chattes/ui/core/responsive_page.dart";
import "package:chattes/ui/menu/widgets/new_chat/new_chat_screen.dart";
import "package:chattes/ui/menu/widgets/settings/settings_screen.dart";
import "package:flutter/material.dart";

class MenuBottomBar extends StatelessWidget implements PreferredSizeWidget {
  const MenuBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Container(
        height: 40,
        margin: kPillMargin,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLowest,
          borderRadius: kPillBorderRadius,
          border: .all(color: theme.colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Expanded(
              child: IconButton(
                onPressed: () => pushResponsivePage(context, SettingsScreen()),
                icon: const Icon(Icons.settings_outlined),
                color: theme.colorScheme.secondary,
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () => pushResponsivePage(context, NewChatScreen()),
                icon: const Icon(Icons.add_rounded),
                color: theme.colorScheme.secondary,
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search_rounded),
                color: theme.colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kBottomNavigationBarHeight);
}
