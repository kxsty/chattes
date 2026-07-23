import "package:chattes/ui/menu/widgets/chats/chat_list.dart";
import "package:chattes/ui/menu/widgets/menu_bottom_bar.dart";
import "package:flutter/material.dart";

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Navigator(
      pages: [
        MaterialPage(
          child: Scaffold(
            backgroundColor: theme.colorScheme.surfaceContainerLow,
            body: ChatList(bottomPadding: kToolbarHeight),
            extendBody: true,
            bottomNavigationBar: MenuBottomBar(),
          ),
        ),
      ],
      onDidRemovePage: (_) {},
    );
  }
}
