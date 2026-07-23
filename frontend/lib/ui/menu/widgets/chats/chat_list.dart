import "package:chattes/ui/menu/providers/chats.dart";
import "package:chattes/ui/menu/widgets/chats/chat_tile.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class ChatList extends ConsumerWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatsProvider).value ?? [];

    return ListView.builder(
      padding: const .only(bottom: kToolbarHeight),
      itemCount: chats.length,
      itemBuilder: (context, index) => ChatTile(chat: chats[index]),
    );
  }
}
