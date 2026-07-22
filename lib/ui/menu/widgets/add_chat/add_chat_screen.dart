import "dart:io";

import "package:chattes/ui/menu/providers/chats.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class AddChatScreen extends StatelessWidget {
  const AddChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add chat")),
      body: CreateChatWidget(),
    );
  }
}

class CreateChatWidget extends StatefulWidget {
  const CreateChatWidget({super.key});

  @override
  State<CreateChatWidget> createState() => _CreateChatWidgetState();
}

class _CreateChatWidgetState extends State<CreateChatWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _imagePath;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 32,
                backgroundColor: Colors.grey.shade300,
                child: _imagePath == null
                    ? const Icon(Icons.camera_alt, size: 32, color: Colors.grey)
                    : Image.file(File(_imagePath!)),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Add image (Optional)",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Chat Name *",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.chat),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter a chat name";
                }
                return null;
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Consumer(
                builder: (context, ref, child) => ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    final name = _nameController.text.trim();

                    ref.read(chatsProvider.notifier).add(name);

                    /*                     ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Created chat: ${post.name}')),
                    );*/

                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Create Chat",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
