import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class ChatInputText extends StatelessWidget {
  const ChatInputText({
    super.key,
    required this.controller,
    this.onAttachFiles,
    this.onSend,
  });

  final TextEditingController controller;
  final VoidCallback? onAttachFiles;
  final VoidCallback? onSend;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: .end,
      children: [
        IconButton(
          icon: const Icon(Icons.attach_file_rounded),
          onPressed: onAttachFiles,
          constraints: const .expand(height: 38, width: 38),
        ),
        Expanded(
          child: Consumer(
            builder: (context, ref, child) {

              return TextField(
                controller: controller,
                minLines: 1,
                maxLines: 20,
                onSubmitted: (_) => onSend?.call(),
                onChanged: (value) {},
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: const .symmetric(vertical: 11),
                  hintText: "Message",
                  border: const OutlineInputBorder(
                    borderRadius: .all(.circular(20)),
                    borderSide: .none,
                  ),
                ),
              );
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send_rounded),
          onPressed: onSend,
          constraints: const .expand(height: 38, width: 38),
        ),
      ],
    );
  }
}
