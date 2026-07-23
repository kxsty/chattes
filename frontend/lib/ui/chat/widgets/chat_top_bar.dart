import "package:chattes/ui/core/constants.dart";
import "package:chattes/ui/menu/providers/selected_chat.dart";
import "package:chattes/ui/menu/widgets/chats/letter_avatar.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class ChatTopBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPop = Navigator.canPop(context);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: kPillMargin,
        child: Row(
          crossAxisAlignment: .center,
          spacing: 8,
          children: [
            if (canPop)
              Pill(
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
              ),

            Flexible(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Pill(
                  child: Consumer(
                    builder: (context, ref, child) {
                      final selectedChat = ref.watch(selectedChatProvider);

                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LetterAvatar(title: selectedChat!.name, radius: 19),

                          Flexible(
                            child: Padding(
                              padding: const .directional(start: 4, end: 8),
                              child: Text(
                                selectedChat.name,
                                style: theme.textTheme.titleLarge,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),

            Pill(
              child: MenuAnchor(
                builder: (context, controller, child) => IconButton(
                  icon: const Icon(Icons.more_vert_rounded),
                  onPressed: () => controller.isOpen
                      ? controller.close()
                      : controller.open(),
                ),
                animated: true,
                alignmentOffset: const .new(-50, 8),
                style: .new(
                  shape: .all(
                    RoundedRectangleBorder(
                      borderRadius: kPillBorderRadius,
                      side: BorderSide(color: theme.colorScheme.outlineVariant),
                    ),
                  ),
                  padding: .all(.zero),
                ),
                menuChildren: [
                  MenuItemButton(
                    leadingIcon: const Icon(Icons.search_rounded),
                    onPressed: () {},
                    child: const Text("Search"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class Pill extends StatelessWidget {
  const Pill({super.key, this.color, this.child});

  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: kPillBorderRadius,
        color: color ?? theme.colorScheme.surfaceContainerLow,
        border: .all(color: theme.colorScheme.outlineVariant),
      ),
      child: child,
    );
  }
}
