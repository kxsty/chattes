import "package:chattes/ui/chat/providers/messages.dart";
import "package:chattes/ui/chat/widgets/messages/message.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class ChatMessageList extends StatelessWidget {
  const ChatMessageList({super.key, required this.chatId});

  final int chatId;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom - 8;

    return Padding(
      padding: const .symmetric(vertical: 8),
      child: Consumer(
        builder: (context, ref, child) {
          final messages =
              ref.watch(messagesProvider(chatId)).value?.messages ?? [];

          return ListView.builder(
            reverse: true,
            padding: .only(top: kToolbarHeight, bottom: bottomPadding),
            itemCount: messages.length,
            itemBuilder: (context, index) => MessageWidget(
              message: messages.elementAt(messages.length - 1 - index),
              onDelete: () =>
                  ref.read(messagesProvider(chatId).notifier).removeAt(index),
            ),
          );
        },
      ),
    );
  }
}
