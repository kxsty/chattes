import "package:chattes/data/app/dto.dart";
import "package:chattes/ui/core/constants.dart";
import "package:chattes/ui/core/extensions.dart";
import "package:flutter/material.dart";
import "package:open_file/open_file.dart";

class AttachmentEntry extends StatelessWidget {
  const AttachmentEntry({super.key, required this.attachment, this.onDelete});

  final Attachment attachment;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InputChip(
      clipBehavior: .antiAlias,
      shape: RoundedRectangleBorder(borderRadius: kPillBorderRadius),
      avatar: _attachmentToIcon(attachment),
      label: Text(attachment.fileName, style: theme.textTheme.bodySmall),
      onPressed: _onPressed,
      onDeleted: onDelete,
      backgroundColor: theme.colorScheme.surface,
    );
  }

  Icon _attachmentToIcon(Attachment attachment) {
    switch (attachment.type) {
      case AttachmentType.image:
        return const Icon(Icons.image_outlined);
      case AttachmentType.video:
        return const Icon(Icons.personal_video_outlined);
      case AttachmentType.audio:
        return const Icon(Icons.audio_file_outlined);
      case AttachmentType.document:
        return const Icon(Icons.text_snippet_outlined);
      case AttachmentType.file:
        return const Icon(Icons.insert_drive_file_outlined);
    }
  }

  Future<void> _onPressed() async {
    await OpenFile.open(attachment.path);
  }
}
