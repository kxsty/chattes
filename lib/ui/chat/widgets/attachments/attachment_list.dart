import "package:chattes/data/app/dto.dart";
import "package:chattes/ui/chat/widgets/attachments/attachment_widget.dart";
import "package:flutter/material.dart";

class AttachmentList extends StatelessWidget {
  const AttachmentList(this.attachments, {super.key, this.onDelete});

  final List<Attachment> attachments;
  final void Function(int index)? onDelete;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: attachments.indexed
          .map(
            ((int, Attachment) x) => AttachmentEntry(
              attachment: x.$2,
              onDelete: onDelete != null ? () => onDelete?.call(x.$1) : null,
            ),
          )
          .toList(),
    );
  }
}
