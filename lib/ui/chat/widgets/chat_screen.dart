import "package:chattes/ui/chat/widgets/chat_top_bar.dart";
import "package:chattes/ui/chat/widgets/input/chat_input.dart";
import "package:chattes/ui/chat/widgets/messages/chat_messages.dart";
import "package:chattes/ui/menu/controllers/chats_notifier.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer(
      builder: (context, ref, child) {
        final selectedChatId = ref.watch(selectedChatIdProvider);
        if (selectedChatId == null) {
          return Container(
            color: theme.colorScheme.surfaceContainerLowest,
            child: Center(
              child: Text("Select a chat", style: theme.textTheme.bodyMedium),
            ),
          );
        }

        return Scaffold(
          extendBody: true,
          backgroundColor: theme.colorScheme.surfaceContainerLowest,
          body: Stack(
            children: [
              ChatMessageList(),
              Positioned(top: 0, left: 0, right: 0, child: ChatTopBar()),
            ],
          ),
          bottomNavigationBar: ChatInputBar(),
        );
      },
    );
  }
}
