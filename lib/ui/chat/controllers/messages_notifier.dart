import "dart:async";

import "package:chattes/data/app/dto.dart";
import "package:chattes/ui/core/rust_app.dart";
import "package:chattes/ui/menu/controllers/chats_notifier.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "messages_notifier.g.dart";

@riverpod
class Messages extends _$Messages {
  @override
  Future<MessagesState?> build() async {
    final chatId = ref.watch(selectedChatIdProvider);
    if (chatId == null) {
      return null;
    }

    var request = ListMessages(
      chatId: chatId,
      id: null,
      limit: 100,
      desc: false,
    );

    final response = await Api().messages.list(request: request);

    return MessagesState(
      messages: response,
      hasMorePrev: response.length >= request.limit,
    );
  }

  Future<void> add(String text, List<PostAttachment> attachments) async {
    final chatId = ref.watch(selectedChatIdProvider);
    if (chatId == null) {
      return;
    }

    final current = state.value!;

    final newMessage = await Api().messages.post(
      request: PostMessage(
        chatId: chatId,
        text: text,
        attachments: attachments,
      ),
    );

    state = AsyncData(
      current.copyWith(messages: [...current.messages, newMessage]),
    );

    final chatsNotifier = ref.read(chatsProvider.notifier);
    final chats = ref.read(chatsProvider).value;

    if (chats != null) {
      final updatedChats = chats
          .map(
            (chat) => chat.id == chatId
                ? chat.copyWith(lastMessage: newMessage)
                : chat,
          )
          .toList();
      updatedChats.sort((a, b) => a.compareTo(b));

      chatsNotifier.state = AsyncData(updatedChats);
    }
  }

  Future<void> remove(int id) async {
    final chatId = ref.watch(selectedChatIdProvider);
    if (chatId == null) {
      return;
    }

    final current = state.value!;

    var deleted = await Api().messages.delete(
      request: DeleteMessage(chatId: chatId, id: id),
    );
    if (!deleted) {
      return;
    }

    state = AsyncData(
      current.copyWith(
        messages: current.messages.where((m) => m.id != id).toList(),
      ),
    );
  }
}

class MessagesState {
  const MessagesState({
    this.messages = const [],
    this.hasMoreNext = true,
    this.hasMorePrev = true,
  });

  final List<Message> messages;
  final bool hasMoreNext;
  final bool hasMorePrev;

  MessagesState copyWith({
    List<Message>? messages,
    bool? hasMoreNext,
    bool? hasMorePrev,
    bool? isLoadingMore,
  }) {
    return MessagesState(
      messages: messages ?? this.messages,
      hasMoreNext: hasMoreNext ?? this.hasMoreNext,
      hasMorePrev: hasMorePrev ?? this.hasMorePrev,
    );
  }
}

class MessageDraft {
  MessageDraft({this.text = "", this.attachments = const []});

  String text;
  List<PostAttachment> attachments;
}

@riverpod
MessageDraft draft(Ref ref, int chatId) {
  return MessageDraft();
}
