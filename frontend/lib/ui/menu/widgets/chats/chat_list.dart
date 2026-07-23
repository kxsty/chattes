import "package:chattes/ui/menu/providers/chats.dart";
import "package:chattes/ui/menu/widgets/chats/chat_tile.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class ChatList extends ConsumerWidget {
  const ChatList({super.key, this.bottomPadding});

  final double? bottomPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatsProvider).value ?? [];

    return ListView.builder(
      padding: bottomPadding != null ? .only(bottom: bottomPadding!) : null,
      itemCount: chats.length,
      itemBuilder: (context, index) =>
          ChatTile(chat: chats[chats.length - 1 - index]),
    );
  }
}
