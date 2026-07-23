import "package:chattes/data/app/dto.dart";
import "package:chattes/ui/core/constants.dart";
import "package:chattes/ui/core/extensions.dart";
import "package:chattes/ui/menu/providers/selected_chat.dart";
import "package:chattes/ui/menu/widgets/chats/letter_avatar.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class ChatTile extends StatelessWidget {
  const ChatTile({super.key, required this.chat});

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer(
      builder: (context, ref, child) {
        final selectedChatId = ref.watch(selectedChatIdProvider);
        final isSelected = selectedChatId == chat.id;

        final message = chat.lastMessage;

        return ListTile(
          onTap: () => ref.read(selectedChatIdProvider.notifier).set(chat.id),
          selected: isSelected,
          contentPadding: const .symmetric(horizontal: 8),
          leading: LetterAvatar(title: chat.name),
          splashColor: theme.colorScheme.surfaceContainerLowest,
          selectedTileColor: theme.colorScheme.surfaceContainerLowest,
          hoverColor: isSelected
              ? theme.colorScheme.surfaceContainerLowest
              : theme.colorScheme.surface,
          title: Row(
            crossAxisAlignment: .end,
            children: [
              Expanded(
                child: Text(
                  chat.name,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
              ),

              if (message != null)
                Text(
                  message.sentAt.formatDateTime,
                  style: theme.textTheme.bodySmall,
                ),
            ],
          ),
          subtitle: MessagePreview(message),
        );
      },
    );
  }
}

class MessagePreview extends StatelessWidget {
  const MessagePreview(this.message, {super.key});

  final Message? message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final height =
        (theme.textTheme.bodyMedium?.fontSize ?? 1) *
        (theme.textTheme.bodyMedium?.height ?? 1);

    if (message == null) {
      return SizedBox(height: height);
    }

    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: .baseline,
        textBaseline: .alphabetic,
        spacing: 4,
        children: [
          if (message!.attachments.isNotEmpty)
            MessagePreviewAttachments(count: message!.attachments.length),
          if (message!.text.isNotEmpty)
            Expanded(
              child: Text(
                message!.text,
                maxLines: 1,
                overflow: .ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class MessagePreviewAttachments extends StatelessWidget {
  const MessagePreviewAttachments({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: .infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: kPillBorderRadius,
        border: .all(color: theme.colorScheme.outlineVariant),
      ),
      padding: const .symmetric(horizontal: 6),
      child: Row(
        crossAxisAlignment: .center,
        spacing: 2,
        children: [
          Text(count.toString(), style: theme.textTheme.bodySmall),
          Icon(
            Icons.attachment_rounded,
            size: theme.textTheme.bodySmall?.fontSize,
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
