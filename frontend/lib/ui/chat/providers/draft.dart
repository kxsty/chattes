import "dart:async";

import "package:chattes/ui/chat/providers/messages.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shared_preferences/shared_preferences.dart";

final draftProvider = NotifierProvider.autoDispose.family(DraftNotifier.new);

final draftTextProvider = AsyncNotifierProvider.autoDispose.family(
  DraftTextNotifier.new,
);

final draftAttachmentsProvider = AsyncNotifierProvider.autoDispose.family(
  DraftAttachmentsNotifier.new,
);

class DraftNotifier extends Notifier<DraftState> {
  DraftNotifier(this.chatId);

  final int chatId;

  @override
  DraftState build() {
    final text = ref.watch(draftTextProvider(chatId)).value ?? "";
    final attachments = ref.watch(draftAttachmentsProvider(chatId)).value ?? [];

    return DraftState(text: text, attachments: attachments);
  }

  Future<void> send() async {
    final value = state;

    await ref
        .read(messagesProvider(chatId).notifier)
        .add(value.text, value.attachments);

    state = const .new();
  }
}

class DraftTextNotifier extends AsyncNotifier<String> {
  DraftTextNotifier(this.chatId);

  final int chatId;
  late final String key = "chat:$chatId:draft:text";

  @override
  Future<String> build() async {
    final instance = await SharedPreferences.getInstance();
    final value = instance.getString(key);

    return value ?? "";
  }

  Future<void> set(String text) async {
    final value = text;

    final instance = await SharedPreferences.getInstance();
    await instance.setString(key, value);

    state = AsyncData(value);
  }

  Future<bool> destroy() async {
    final instance = await SharedPreferences.getInstance();
    return instance.remove(key);
  }
}

class DraftAttachmentsNotifier extends AsyncNotifier<List<String>> {
  DraftAttachmentsNotifier(this.chatId);

  final int chatId;
  late final String key = "chat:$chatId:draft:attachments";

  @override
  Future<List<String>> build() async {
    final instance = await SharedPreferences.getInstance();
    final attachments = instance.getStringList(key);

    return attachments ?? [];
  }

  Future<void> addAll(Iterable<String> attachments) async {
    final oldValue = state.value;
    final value = <String>[];

    if (oldValue != null) {
      value.addAll(oldValue);
    }
    value.addAll(attachments);

    final instance = await SharedPreferences.getInstance();
    await instance.setStringList(key, value);

    state = AsyncData(value);
  }

  Future<void> removeAt(int index) async {
    final oldValue = state.value;
    if (oldValue == null) {
      return;
    }

    final value = oldValue.toList();
    value.removeAt(index);

    final instance = await SharedPreferences.getInstance();
    await instance.setStringList(key, value);

    state = AsyncData(value);
  }

  Future<bool> destroy() async {
    final instance = await SharedPreferences.getInstance();
    return instance.remove(key);
  }
}

class DraftState {
  const DraftState({this.text = "", this.attachments = const []});

  final String text;
  final List<String> attachments;
}
