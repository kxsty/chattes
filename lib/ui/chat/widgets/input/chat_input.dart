import "package:chattes/ui/chat/widgets/input/chat_input_attachments.dart";
import "package:chattes/ui/chat/widgets/input/chat_input_core.dart";
import "package:flutter/material.dart";

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({super.key, required this.chatId});

  final int chatId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Container(
        margin: const .all(8),
        decoration: BoxDecoration(
          borderRadius: const .all(.circular(20)),
          color: theme.colorScheme.surfaceContainerLow,
          border: .all(color: theme.colorScheme.outlineVariant),
        ),
        child: Column(
          mainAxisSize: .min,
          children: [
            ChatInputAttachments(chatId: chatId),

            ChatInputCore(
              key: ValueKey("chat:$chatId:input:core"),
              chatId: chatId,
            ),
          ],
        ),
      ),
    );
  }
}
