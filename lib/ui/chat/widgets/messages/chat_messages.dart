import "package:chattes/ui/chat/controllers/messages_notifier.dart";
import "package:chattes/ui/chat/widgets/messages/message.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class ChatMessageList extends StatefulWidget {
  const ChatMessageList({super.key});

  @override
  State<ChatMessageList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatMessageList> {
  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom - 8;

    return Padding(
      padding: const .symmetric(vertical: 8),
      child: Consumer(
        builder: (context, ref, child) {
          final messages = ref.watch(messagesProvider).value?.messages ?? [];

          return ListView.builder(
            reverse: true,
            padding: .only(top: kToolbarHeight, bottom: bottomPadding),
            itemCount: messages.length,
            itemBuilder: (context, index) => MessageWidget(
              message: messages.elementAt(messages.length - 1 - index),
              onDelete: () {
                final message = messages.elementAt(messages.length - 1 - index);
                ref.read(messagesProvider.notifier).remove(message.id);
              },
            ),
          );
        },
      ),
    );
  }
}
