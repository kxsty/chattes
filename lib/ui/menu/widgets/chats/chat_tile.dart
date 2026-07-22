import "package:chattes/data/app/dto.dart";
import "package:chattes/ui/core/extensions.dart";
import "package:chattes/ui/menu/controllers/chats_notifier.dart";
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

        return ListTile(
          onTap: () =>
              ref.read(selectedChatIdProvider.notifier).selectChat(chat),
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

              if (chat.lastMessage != null)
                Text(
                  chat.lastMessage!.sentAt.formatDateTime,
                  style: theme.textTheme.bodySmall,
                ),
            ],
          ),
          subtitle: Text(
            chat.lastMessage?.text ?? "",
            maxLines: 1,
            overflow: .ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        );
      },
    );
  }
}
