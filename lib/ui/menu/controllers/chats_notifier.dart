import "package:chattes/data/app/dto.dart";
import "package:chattes/ui/core/rust_app.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "chats_notifier.g.dart";

@riverpod
class Chats extends _$Chats {
  @override
  Future<List<Chat>> build() async {
    var chats = await Api().chats.list(
      request: ListChats(limit: 1000, desc: true),
    );
    chats.sort((a, b) => a.compareTo(b));
    return chats;
  }

  Future<void> add(PostChat post) async {
    state = const AsyncLoading();
    var chat = await Api().chats.post(request: post);

    var chats = [...state.value!, chat];
    chats.sort((a, b) => a.compareTo(b));

    state = AsyncData(chats);

    ref.read(selectedChatIdProvider.notifier).selectChat(chat);
  }
}

@riverpod
class SelectedChatId extends _$SelectedChatId {
  @override
  int? build() => null;

  void selectChat(Chat? chat) => state = chat?.id;
}

@riverpod
Chat? selectedChat(Ref ref) {
  final id = ref.watch(selectedChatIdProvider);
  if (id == null) return null;

  final chats = ref.watch(chatsProvider).value ?? [];

  return chats.firstWhere((chat) => chat.id == id);
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

extension ChatCompare on Chat {
  int compareTo(Chat other) {
    final sentAt = lastMessage?.sentAt;
    final otherSentAt = other.lastMessage?.sentAt;

    if (sentAt == null && otherSentAt == null) return 0;

    if (sentAt == null) {
      return -1;
    }

    if (otherSentAt == null) {
      return 1;
    }

    return sentAt.compareTo(otherSentAt);
  }
}
