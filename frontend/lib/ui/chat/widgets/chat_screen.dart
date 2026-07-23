import "package:chattes/ui/chat/widgets/chat_top_bar.dart";
import "package:chattes/ui/chat/widgets/input/chat_input.dart";
import "package:chattes/ui/chat/widgets/messages/chat_messages.dart";
import "package:chattes/ui/menu/providers/selected_chat.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

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
          extendBodyBehindAppBar: true,
          appBar: ChatTopBar(),
          backgroundColor: theme.colorScheme.surfaceContainerLowest,
          body: ChatMessageList(chatId: selectedChatId),
          bottomNavigationBar: ChatInputBar(chatId: selectedChatId),
        );
      },
    );
  }
}
