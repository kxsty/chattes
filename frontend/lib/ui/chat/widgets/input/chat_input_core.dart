import "package:chattes/ui/chat/providers/draft.dart";
import "package:chattes/ui/core/constants.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class ChatInputCore extends ConsumerStatefulWidget {
  const ChatInputCore({super.key, required this.chatId});

  final int chatId;

  @override
  ConsumerState<ChatInputCore> createState() => _ChatInputCoreState();
}

class _ChatInputCoreState extends ConsumerState<ChatInputCore> {
  final TextEditingController _textController = .new();
  late final FocusNode _focusNode = .new(onKeyEvent: _onKeyEvent);

  @override
  Widget build(BuildContext context) {
    final value = ref.watch(draftTextProvider(widget.chatId));
    value.whenData((text) {
      text = text ?? "";
      if (_textController.text != text) {
        _textController.text = text;
      }
    });

    return Row(
      crossAxisAlignment: .end,
      children: [
        IconButton(
          icon: const Icon(Icons.attach_file_rounded),
          onPressed: () => _attachFiles(),
          constraints: const .expand(height: 38, width: 38),
        ),
        Expanded(
          child: TextField(
            maxLines: null,
            controller: _textController,
            focusNode: _focusNode,
            onChanged: _setText,
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

  Future<void> _setText(String text) {
    return ref.read(draftTextProvider(widget.chatId).notifier).set(text);
  }

  Future<void> _attachFiles() async {
    final result = await FilePicker.pickFiles();
    if (result.isEmpty) return;

    final attachments = result
        .map((e) => e.path)
        .whereType<String>()
        .toList();

    ref
        .read(draftAttachmentsProvider(widget.chatId).notifier)
        .addAll(attachments);
  }

  Future<void> _submit() async {
    _focusNode.requestFocus();

    final sent = await ref.read(draftProvider(widget.chatId).notifier).send();
    if (!sent) {
      return;
    }

    _textController.clear();
  }

  bool _anyInput() {
    return !ref.watch(draftProvider(widget.chatId)).isEmpty;
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) {
      return .ignored;
    }

    if (HardwareKeyboard.instance.isControlPressed ||
        HardwareKeyboard.instance.isShiftPressed) {
      return .ignored;
    }

    if (event.logicalKey != .enter && event.logicalKey != .numpadEnter) {
      return .ignored;
    }

    _submit();
    return .handled;
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
