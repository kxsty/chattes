import "package:chattes/data/app/dto.dart";
import "package:chattes/ui/core/rust_app.dart";
import "package:chattes/ui/menu/providers/selected_chat.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

final chatsProvider = AsyncNotifierProvider.autoDispose(ChatsNotifier.new);

class ChatsNotifier extends AsyncNotifier<List<Chat>> {
  @override
  Future<List<Chat>> build() async {
    final value = await Api().chats.list(
      request: const .new(limit: 1000, desc: false),
    );

    return value;
  }

  Future<void> add(String name) async {
    name = name.trim();

    final chat = await Api().chats.post(request: .new(name: name));

    final oldValue = state.value;
    final value = oldValue?.toList() ?? [];

    value.add(chat);
    value.sort((a, b) => a.compareTo(b));

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

    final value = oldValue.toList();

    value[index] = value[index].copyWith(lastMessage: lastMessage);
    value.sort((a, b) => a.compareTo(b));

    state = AsyncData(value);
  }
}

extension ChatCopyWith on Chat {
  Chat copyWith({int? id, String? name, Message? lastMessage}) {
    return Chat(
      id: id ?? this.id,
      name: name ?? this.name,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }
}
