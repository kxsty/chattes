import "dart:async";

import "package:chattes/ui/chat/providers/messages.dart";
import "package:chattes/ui/core/debouncer.dart";
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
    final attachments =
        ref.watch(draftAttachmentsProvider(chatId)).value ?? const [];

    return DraftState(text: text, attachments: attachments);
  }

  Future<bool> send() async {
    final value = state;

    final added = await ref
        .read(messagesProvider(chatId).notifier)
        .add(value.text, value.attachments);
    if (!added) {
      return false;
    }

    ref.read(draftTextProvider(chatId).notifier).destroy();
    ref.read(draftAttachmentsProvider(chatId).notifier).destroy();

    state = const .new();
    return true;
  }
}

class DraftTextNotifier extends AsyncNotifier<String> {
  DraftTextNotifier(this.chatId);

  final int chatId;
  late final String key = "chat:$chatId:draft:text";
  final Debouncer _saveDebouncer = Debouncer(milliseconds: 300);

  @override
  Future<String> build() async {
    final instance = await SharedPreferences.getInstance();
    final value = instance.getString(key);

    ref.onDispose(() => _saveDebouncer.dispose());

    return value ?? "";
  }

  Future<void> set(String text) async {
    final oldValue = state.value;
    final value = text.trim();
    if (value == oldValue) {
      return;
    }

    _saveDebouncer.run(() async {
      final instance = await SharedPreferences.getInstance();
      await instance.setString(key, value);
    });

    state = AsyncData(value);
  }

  Future<void> destroy() async {
    _saveDebouncer.run(() async {
      final instance = await SharedPreferences.getInstance();
      instance.remove(key);
    });

    state = AsyncData("");
  }
}

class DraftAttachmentsNotifier extends AsyncNotifier<List<String>> {
  DraftAttachmentsNotifier(this.chatId);

  final int chatId;
  late final String key = "chat:$chatId:draft:attachments";
  final Debouncer _saveDebouncer = Debouncer(milliseconds: 300);

  @override
  Future<List<String>> build() async {
    final instance = await SharedPreferences.getInstance();
    final attachments = instance.getStringList(key);

    ref.onDispose(() => _saveDebouncer.dispose());

    return attachments ?? const [];
  }

  Future<void> addAll(Iterable<String> attachments) async {
    final oldValue = state.value;
    final value = <String>[];

    if (oldValue != null) {
      value.addAll(oldValue);
    }
    value.addAll(attachments);

    _saveDebouncer.run(() async {
      final instance = await SharedPreferences.getInstance();
      await instance.setStringList(key, value);
    });

    state = AsyncData(value);
  }

  Future<void> removeAt(int index) async {
    final oldValue = state.value;
    if (oldValue == null) {
      return;
    }

    final value = oldValue.toList();
    value.removeAt(index);

    _saveDebouncer.run(() async {
      final instance = await SharedPreferences.getInstance();
      await instance.setStringList(key, value);
    });

    state = AsyncData(value);
  }

  Future<void> destroy() async {
    _saveDebouncer.run(() async {
      final instance = await SharedPreferences.getInstance();
      instance.remove(key);
    });

    state = AsyncData(const []);
  }
}

class DraftState {
  const DraftState({this.text = "", this.attachments = const []});

  final String text;
  final List<String> attachments;
}
