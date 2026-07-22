import "package:chattes/data/app/dto.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class MessageDraft {
  MessageDraft({this.text = "", this.attachments = const []});

  String text;
  List<PostAttachment> attachments;
}

final draftProvider = Provider.autoDispose.family<MessageDraft, int>(
  (ref, chatId) => MessageDraft(),
);

/* @riverpod
MessageDraft draft(Ref ref, int chatId) {
  return MessageDraft();
} */
