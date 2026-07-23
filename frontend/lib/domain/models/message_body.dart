import "package:chattes/data/app/dto.dart";

class MessageBody {
  const MessageBody({this.text = "", this.attachments = const []});
  MessageBody.from(Message message)
    : text = message.text,
      attachments = message.attachments.map((a) => a.path).toList();

  final String text;
  final List<String> attachments;

  bool get isEmpty => text.isEmpty && attachments.isEmpty;
}
