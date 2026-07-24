import "dart:async";

import "package:chattes/data/app/dto.dart";
import "package:chattes/ui/core/rust_app.dart";
import "package:chattes/ui/menu/providers/selected_chat.dart";
import "package:collection/collection.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

final chatsProvider = AsyncNotifierProvider.autoDispose(ChatsNotifier.new);

class ChatsNotifier extends AsyncNotifier<List<Chat>> {
  @override
  Future<List<Chat>> build() async {
    final value = await Api().chats.list(
      request: const .new(limit: 1000, desc: false),
    );
    assert(value.isSorted((a, b) => a.compareTo(b)));

    return value;
  }

  Future<void> add(String name) async {
    final oldValue = state.value;
    if (oldValue == null) {
      return;
    }

    name = name.trim();

    final chat = await Api().chats.post(request: .new(name: name));

    final value = [...oldValue, chat];
    assert(value.isSorted((a, b) => a.compareTo(b)));

    state = AsyncData(value);

    ref.read(selectedChatIdProvider.notifier).set(chat.id);
  }

  void setLastMessage(final int chatId, final Message? lastMessage) {
    final oldValue = state.value;
    if (oldValue == null) {
      return;
    }

    final index = oldValue.indexWhere((c) => c.id == chatId);
    if (index == -1) {
      return;
    }

    final value = [...oldValue];

    value[index] = value[index].copyWith(lastMessage: lastMessage);
    value.sort((a, b) => a.compareTo(b));

    state = AsyncData(value);
  }
}