import "package:chattes/ui/chat/providers/draft.dart";
import "package:chattes/ui/core/debouncer.dart";
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
  final Debouncer _debouncer = .new(milliseconds: 300);

  @override
  void initState() {
    super.initState();

    final text = ref.watch(draftTextProvider(widget.chatId)).value;

    _controller = TextEditingController(text: text);
  }

  @override
  Future<void> dispose() async {
    _controller.dispose();
    _debouncer.dispose();
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
            onSubmitted: (_) => _submit(ref),
            onChanged: (text) => _debouncer.run(
              () =>
                  ref.read(draftTextProvider(widget.chatId).notifier).set(text),
            ),
            textInputAction: .send,
            decoration: const InputDecoration(
              isCollapsed: true,
              contentPadding: .symmetric(vertical: 11),
              hintText: "Message",
              border: OutlineInputBorder(
                borderRadius: .all(.circular(20)),
                borderSide: .none,
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send_rounded),
          onPressed: () => _submit(ref),
          constraints: const .expand(height: 38, width: 38),
        ),
      ],
    );
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

  Future<void> _submit(WidgetRef ref) async {
    if (_controller.text.trim().isEmpty) {
      return;
    }

    _debouncer.cancel();
    await ref
        .read(draftTextProvider(widget.chatId).notifier)
        .set(_controller.text);

    await ref.read(draftProvider(widget.chatId).notifier).send();

    _controller.clear();
  }
}
