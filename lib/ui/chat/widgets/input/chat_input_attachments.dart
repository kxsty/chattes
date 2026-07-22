import "package:chattes/data/app/dto.dart";
import "package:chattes/ui/chat/widgets/attachments/attachment_list.dart";
import "package:flutter/material.dart";
import "package:path/path.dart" as path;

class ChatInputAttachments extends StatefulWidget {
  const ChatInputAttachments(this.attachments, {super.key});

  final List<PostAttachment> attachments;

  @override
  State<ChatInputAttachments> createState() => _ChatInputAttachmentsState();
}

class _ChatInputAttachmentsState extends State<ChatInputAttachments> {
  @override
  Widget build(BuildContext context) {
    if (widget.attachments.isEmpty) {
      return Container();
    }

    return Container(
      width: .infinity,
      padding: const .all(8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 200),
        child: SingleChildScrollView(
          child: AttachmentList(
            widget.attachments
                .map(
                  (a) =>
                      Attachment(path: a.path, fileName: path.basename(a.path)),
                )
                .toList(),
            onDelete: (index) => setState(() {
              widget.attachments.removeAt(index);
            }),
          ),
        ),
      ),
    );
  }
}
