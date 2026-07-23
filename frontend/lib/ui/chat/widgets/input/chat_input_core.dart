import "package:chattes/ui/chat/providers/draft.dart";
import "package:chattes/ui/core/constants.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class ChatInputCore extends ConsumerStatefulWidget {
  const ChatInputCore({super.key, required this.chatId});

  final int chatId;

  @override
  ConsumerState<ChatInputCore> createState() => _ChatInputCoreState();
}

class _ChatInputCoreState extends ConsumerState<ChatInputCore> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    final text = ref.watch(draftTextProvider(widget.chatId)).value;

    _controller = TextEditingController(text: text);
  }

  @override
  Future<void> dispose() async {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: .end,
      children: [
        IconButton(
          icon: const Icon(Icons.attach_file_rounded),
          onPressed: () => _attachFiles(ref),
          constraints: const .expand(height: 38, width: 38),
        ),
        Expanded(
          child: TextField(
            minLines: 1,
            maxLines: 20,
            controller: _controller,
            onSubmitted: (_) => _submit(),
            onChanged: (text) => _setText(text),
            textInputAction: .send,
            decoration: const InputDecoration(
              isCollapsed: true,
              contentPadding: .symmetric(vertical: 11),
              hintText: "Message",
              border: OutlineInputBorder(
                borderRadius: kPillBorderRadius,
                borderSide: .none,
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send_rounded),
          onPressed: _anyInput() ? () => _submit() : null,
          constraints: const .expand(height: 38, width: 38),
        ),
      ],
    );
  }

  bool _anyInput() {
    final text = ref.watch(draftTextProvider(widget.chatId)).value;
    if (text != null && text.isNotEmpty) {
      return true;
    }

    final attachments = ref
        .watch(draftAttachmentsProvider(widget.chatId))
        .value;
    if (attachments != null && attachments.isNotEmpty) {
      return true;
    }

    return false;
  }

  Future<void> _attachFiles(WidgetRef ref) async {
    final result = await FilePicker.pickFiles();
    if (result == null || result.files.isEmpty) return;

    final attachments = result.files
        .map((e) => e.path)
        .whereType<String>()
        .toList();

    ref
        .read(draftAttachmentsProvider(widget.chatId).notifier)
        .addAll(attachments);
  }

  Future<void> _submit() async {
    final sent = await ref.read(draftProvider(widget.chatId).notifier).send();
    if (!sent) {
      return;
    }

    _controller.clear();
  }

  Future<void> _setText(String text) {
    return ref.read(draftTextProvider(widget.chatId).notifier).set(text.trim());
  }
}
