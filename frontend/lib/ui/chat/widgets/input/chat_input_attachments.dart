import "package:chattes/data/app/dto.dart";
import "package:chattes/ui/chat/providers/draft.dart";
import "package:chattes/ui/chat/widgets/attachments/attachment_list.dart";
import "package:chattes/ui/core/constants.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:path/path.dart" as path;

class ChatInputAttachments extends ConsumerWidget {
  const ChatInputAttachments({required this.chatId, super.key});

  final int chatId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var attachments = ref.watch(draftProvider(chatId)).attachments;
    if (attachments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: .infinity,
      padding: kPillMargin,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 256 + 8),
        child: SingleChildScrollView(
          child: AttachmentList(
            attachments
                .map((p) => Attachment(path: p, fileName: path.basename(p)))
                .toList(),
            onDelete: ref
                .read(draftAttachmentsProvider(chatId).notifier)
                .removeAt,
          ),
        ),
      ),
    );
  }
}
