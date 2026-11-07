import "package:chattes/ui/chat/widgets/input/chat_input_attachments.dart";
import "package:chattes/ui/chat/widgets/input/chat_input_core.dart";
import "package:chattes/ui/core/constants.dart";
import "package:flutter/material.dart";

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({super.key, required this.chatId});

  final int chatId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return SafeArea(
      top: false,
      child: Container(
        margin: kPillMargin,
        decoration: BoxDecoration(
          borderRadius: kPillBorderRadius,
          color: theme.colorScheme.surfaceContainerLow,
          border: .all(color: theme.colorScheme.outlineVariant),
        ),
        child: ConstrainedBox(
          constraints: .new(maxHeight: mediaQuery.size.height * 0.75),
          child: Column(
            mainAxisSize: .min,
            children: [
              Flexible(child: ChatInputAttachments(chatId: chatId)),

              Flexible(
                child: ChatInputCore(
                  key: ValueKey("chat:$chatId:input:core"),
                  chatId: chatId,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
