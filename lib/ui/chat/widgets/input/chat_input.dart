import "package:chattes/data/app/dto.dart";
import "package:chattes/ui/chat/controllers/messages_notifier.dart";
import "package:chattes/ui/chat/widgets/input/chat_input_attachments.dart";
import "package:chattes/ui/chat/widgets/input/chat_input_text.dart";
import "package:chattes/ui/menu/controllers/chats_notifier.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class ChatInputBar extends ConsumerStatefulWidget {
  const ChatInputBar({super.key});

  @override
  ConsumerState<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends ConsumerState<ChatInputBar> {
  final TextEditingController _textController = .new();
  final List<PostAttachment> _attachments = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    var selectedChatId = ref.watch(selectedChatIdProvider);
    if (selectedChatId == null) {
      throw ();
    }

    _textController.addListener(() {
      var read = ref.read(draftProvider(selectedChatId));
      read.text = _textController.text;
    });

    return SafeArea(
      top: false,
      child: Padding(
        padding: const .all(8),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const .all(.circular(20)),
            color: theme.colorScheme.surfaceContainerLow,
            border: .all(color: theme.colorScheme.outlineVariant),
          ),
          child: Column(
            mainAxisSize: .min,
            children: [
              if (_attachments.isNotEmpty) ChatInputAttachments(_attachments),

              Consumer(
                builder: (context, ref, child) {
                  return ChatInputText(
                    controller: _textController,
                    onSend: () => _sendMessage(ref),
                    onAttachFiles: _attachFiles,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _attachFiles() async {
    final result = await FilePicker.pickFiles();
    if (result == null || result.count < 1 || !mounted) return;

    setState(() {
      for (final filePath in result.paths.whereType<String>()) {
        if (kDebugMode) {
          print("Added: $filePath");
        }

        _attachments.add(PostAttachment(path: filePath));
      }
    });
  }

  Future<void> _sendMessage(WidgetRef ref) async {
    final text = _textController.text.trim();
    if (text.isEmpty && _attachments.isEmpty) {
      return;
    }

    final selectedChatId = ref.read(selectedChatIdProvider);
    if (selectedChatId == null) {
      return;
    }

    await ref.read(messagesProvider.notifier).add(text, _attachments);

    _textController.clear();
    setState(() {
      _attachments.clear();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
