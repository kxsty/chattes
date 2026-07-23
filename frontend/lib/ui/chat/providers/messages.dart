import "dart:async";

import "package:chattes/data/app/dto.dart";
import "package:chattes/ui/core/rust_app.dart";
import "package:chattes/ui/menu/providers/chats.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

final messagesProvider = AsyncNotifierProvider.autoDispose.family(
  MessagesNotifier.new,
);

class MessagesNotifier extends AsyncNotifier<MessagesState?> {
  MessagesNotifier(this.chatId);

  final int chatId;

  @override
  Future<MessagesState?> build() async {
    final response = await Api().messages.list(
      request: .new(chatId: chatId, idCursor: null, limit: 100, desc: false),
    );

    return MessagesState(
      messages: response,
      hasMorePrev: response.length >= 100,
    );
  }

  Future<bool> add(String text, List<String> attachments) async {
    if (text.trim().isEmpty && attachments.isEmpty) {
      return false;
    }

    final message = await Api().messages.post(
      request: .new(
        chatId: chatId,
        text: text,
        attachments: attachments.map((p) => PostAttachment(path: p)).toList(),
      ),
    );

    final oldValue = state.value;
    final value = oldValue?.copyWith() ?? .new();

    value.messages.add(message);

    state = AsyncData(value);

    ref.read(chatsProvider.notifier).setLastMessage(chatId, message);

    return true;
  }

  Future<void> removeAt(int index) async {
    final oldValue = state.value;
    if (oldValue == null) {
      return;
    }
    final value = oldValue.copyWith();

    final message = value.messages.removeAt(index);

    var deleted = await Api().messages.delete(
      request: .new(chatId: chatId, id: message.id),
    );
    if (!deleted) {
      return;
    }

    state = AsyncData(value);
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
