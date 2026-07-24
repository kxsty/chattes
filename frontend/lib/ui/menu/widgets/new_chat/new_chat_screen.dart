import "dart:io";

import "package:chattes/ui/core/constants.dart";
import "package:chattes/ui/menu/providers/chats.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class NewChatScreen extends StatelessWidget {
  const NewChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New chat")),
      body: Padding(padding: const .all(16), child: CreateChatForm()),
    );
  }
}

class CreateChatForm extends ConsumerStatefulWidget {
  const CreateChatForm({super.key});

  @override
  ConsumerState<CreateChatForm> createState() => _CreateChatFormState();
}

class _CreateChatFormState extends ConsumerState<CreateChatForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  String? _imagePath;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 32),
          _CreateChatImage(imagePath: _imagePath, onTap: _pickImage),
          const SizedBox(height: 32),
          _CreateChatName(controller: _nameController),
          const Spacer(),
          _CreateChatSubmitButton(onPressed: _submit),
        ],
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text;

    ref.read(chatsProvider.notifier).add(name);

    Navigator.pop(context);
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.pickFile(type: FileType.image);
    if (result == null || result.path == null) {
      return;
    }

    setState(() {
      _imagePath = result.path;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}

class _CreateChatImage extends StatelessWidget {
  const _CreateChatImage({this.imagePath, this.onTap});

  final String? imagePath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      hitTestBehavior: .deferToChild,
      child: GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
          radius: 64,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          foregroundImage: imagePath != null
              ? FileImage(File(imagePath!))
              : null,
          child: imagePath == null
              ? Icon(
                  Icons.add_a_photo_rounded,
                  size: 64,
                  color: theme.colorScheme.onSurfaceVariant,
                )
              : null,
        ),
      ),
    );
  }
}

class _CreateChatName extends StatelessWidget {
  const _CreateChatName({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: "Chat name",
        fillColor: theme.colorScheme.surfaceContainerLow,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: const .all(.circular(24)),
          borderSide: .new(color: theme.colorScheme.outlineVariant),
        ),
        border: OutlineInputBorder(borderRadius: const .all(.circular(24))),
      ),
      validator: _validator,
    );
  }

  String? _validator(String? input) {
    final name = input?.trim();
    if (name == null || name.isEmpty) {
      return "Chat name is required";
    }
    if (name.length > 255) {
      return "Chat name too long";
    }

    return null;
  }
}

class _CreateChatSubmitButton extends StatelessWidget {
  const _CreateChatSubmitButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: .infinity,
      height: 40,
      child: FilledButton(
        onPressed: onPressed,
        style: .new(
          shadowColor: .all(kColorTransparent),
          backgroundColor: .all(theme.colorScheme.surfaceContainerLow),
          overlayColor: .all(const Color.fromRGBO(255, 255, 255, 0.05)),
          shape: .all(
            RoundedRectangleBorder(
              borderRadius: const .all(.circular(20)),
              side: .new(color: theme.colorScheme.outlineVariant),
            ),
          ),
        ),
        child: Text("Create Chat", style: theme.textTheme.titleMedium),
      ),
    );
  }
}
