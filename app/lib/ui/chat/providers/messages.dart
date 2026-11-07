import "dart:async";

import "package:chattes/data/app/dto.dart";
import "package:chattes/domain/models/message_body.dart";
import "package:chattes/ui/core/rust_app.dart";
import "package:chattes/ui/menu/providers/chats.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

final messagesProvider = AsyncNotifierProvider.autoDispose.family(
  MessagesNotifier.new,
);

class MessagesNotifier extends AsyncNotifier<MessagesState> {
  MessagesNotifier(this.chatId);

  final int chatId;

  static const _limit = 100;

  @override
  Future<MessagesState> build() async {
    final messages = await Api().messages.list(
      request: ListMessages(
        chatId: chatId,
        idCursor: null,
        limit: _limit,
        desc: true,
      ),
    );

    return .new(
      messages: messages.reversed.toList(),
      hasPrev: messages.length == _limit,
    );
  }

  Future<void> loadPrev() async {
    final oldValue = state.value;
    if (oldValue == null || !oldValue.hasPrev) {
      return;
    }

    try {
      final firstMessage = oldValue.messages.firstOrNull;

      final olderMessages = await Api().messages.list(
        request: ListMessages(
          chatId: chatId,
          idCursor: firstMessage?.id,
          limit: _limit,
          desc: true,
        ),
      );

      final value = oldValue.copyWith(
        messages: [...olderMessages.reversed, ...oldValue.messages],
        hasPrev: olderMessages.length == _limit,
      );

      state = AsyncData(value);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<bool> add(MessageBody body) async {
    final oldValue = state.value;
    if (oldValue == null) {
      return false;
    }

    if (body.isEmpty) {
      return false;
    }

    final message = await Api().messages.post(
      request: .new(
        chatId: chatId,
        text: body.text,
        attachments: body.attachments
            .map((p) => PostAttachment(path: p))
            .toList(),
      ),
    );

    final value = oldValue.copyWith(messages: [...oldValue.messages, message]);

    state = AsyncData(value);

    ref.read(chatsProvider.notifier).setLastMessage(chatId, message);

    return true;
  }

  Future<void> removeAt(int index) async {
    final oldValue = state.value;
    if (oldValue == null) {
      return;
    }

    final value = oldValue.copyWith(messages: [...oldValue.messages]);

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

@immutable
class MessagesState {
  const MessagesState({this.messages = const [], this.hasPrev = true});

  final List<Message> messages;
  final bool hasPrev;

  MessagesState copyWith({List<Message>? messages, bool? hasPrev}) {
    return MessagesState(
      messages: messages ?? this.messages,
      hasPrev: hasPrev ?? this.hasPrev,
    );
  }
}
