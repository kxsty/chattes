import "package:chattes/data/app/dto.dart";
import "package:chattes/ui/chat/widgets/attachments/attachment_list.dart";
import "package:chattes/ui/core/extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class MessageWidget extends ConsumerStatefulWidget {
  const MessageWidget({super.key, required this.message, this.onDelete});

  final Message message;
  final VoidCallback? onDelete;

  @override
  ConsumerState<MessageWidget> createState() => _MessageWidgetState();
}

enum MessageAction { edit, delete }

class _MessageWidgetState extends ConsumerState<MessageWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = .new(text: widget.message.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: const Color(0x00000000),
      child: InkWell(
        hoverColor: theme.hoverColor,
        onSecondaryTapDown: _onSecondaryTapDown,
        child: Padding(
          padding: const .symmetric(vertical: 8, horizontal: 16),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            spacing: 4,
            children: [
              Row(
                children: [
                  Text(
                    widget.message.sentAt.formatTime,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                    textHeightBehavior: const TextHeightBehavior(
                      applyHeightToFirstAscent: false,
                      applyHeightToLastDescent: false,
                    ),
                  ),
                ],
              ),

              if (widget.message.text.isNotEmpty)
                TextField(
                  controller: _controller,
                  maxLines: null,
                  decoration: InputDecoration(border: .none),
                ),

              AttachmentList(widget.message.attachments),
            ],
          ),
        ),
      ),
    );
  }

  void _onSecondaryTapDown(TapDownDetails details) async {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    final position = RelativeRect.fromRect(
      Rect.fromPoints(details.globalPosition, details.globalPosition),
      Offset.zero & overlay.size,
    );
    final theme = Theme.of(context);

    final result = await showMenu<MessageAction>(
      context: context,
      position: position,
      clipBehavior: .antiAlias,
      color: theme.colorScheme.surfaceContainerLow,
      menuPadding: const .all(0),
      shape: RoundedRectangleBorder(
        borderRadius: const .all(.circular(20)),
        side: .new(color: theme.colorScheme.outlineVariant),
      ),
      items: [
        PopupMenuItem(
          value: .edit,
          child: Row(
            spacing: 12,
            children: [
              Icon(Icons.edit, size: theme.iconTheme.size ?? 40 / 2),
              Text("Edit"),
            ],
          ),
        ),
        PopupMenuItem(
          value: .delete,
          child: Row(
            spacing: 12,
            children: [
              Icon(Icons.delete, size: theme.iconTheme.size ?? 40 / 2),
              Text("Delete"),
            ],
          ),
        ),
      ],
    );

    if (result == null) {
      return;
    }

    switch (result) {
      case MessageAction.edit:
        debugPrint("Edit clicked for message: ${widget.message.text}");
        break;
      case MessageAction.delete:
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Do you want to delete this message?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Delete"),
              ),
            ],
          ),
        );
        if (confirmed != null && confirmed) {
          widget.onDelete?.call();
        }
        break;
    }
  }
}
