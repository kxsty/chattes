import "package:chattes/data/app/dto.dart";
import "package:path/path.dart" as path_dart;

extension Formatting on DateTime {
  String get _year => year.toString().padLeft(4, "0");
  String get _month => month.toString().padLeft(2, "0");
  String get _day => day.toString().padLeft(2, "0");
  String get _hour => hour.toString().padLeft(2, "0");
  String get _minute => minute.toString().padLeft(2, "0");

  String get formatDateTime {
    var local = toLocal();
    final now = DateTime.now().toUtc();

    final lessThan24h = now.difference(local) <= const Duration(days: 1);

    return lessThan24h
        ? "${local._hour}:${local._minute}"
        : "${local._day}/${local._month}/${local._year}";
  }

  String get formatTime {
    var local = toLocal();
    return "${local._hour}:${local._minute}";
  }
}

enum AttachmentType { image, video, audio, document, file }

extension AttachmentExtensions on Attachment {
  AttachmentType get type {
    final extension = path_dart.extension(path);
    return _extensionMap[extension] ?? AttachmentType.file;
  }
}

const Map<String, AttachmentType> _extensionMap = {
  ".jpg": AttachmentType.image,
  ".jpeg": AttachmentType.image,
  ".png": AttachmentType.image,
  ".gif": AttachmentType.image,
  ".bmp": AttachmentType.image,
  ".webp": AttachmentType.image,
  ".svg": AttachmentType.image,
  ".heic": AttachmentType.image,
  ".heif": AttachmentType.image,
  ".ico": AttachmentType.image,
  ".tiff": AttachmentType.image,
  ".tif": AttachmentType.image,

  ".mp4": AttachmentType.video,
  ".mov": AttachmentType.video,
  ".avi": AttachmentType.video,
  ".mkv": AttachmentType.video,
  ".webm": AttachmentType.video,
  ".flv": AttachmentType.video,
  ".wmv": AttachmentType.video,
  ".m4v": AttachmentType.video,
  ".3gp": AttachmentType.video,

  ".mp3": AttachmentType.audio,
  ".wav": AttachmentType.audio,
  ".aac": AttachmentType.audio,
  ".ogg": AttachmentType.audio,
  ".flac": AttachmentType.audio,
  ".m4a": AttachmentType.audio,
  ".wma": AttachmentType.audio,
  ".opus": AttachmentType.audio,

  ".pdf": AttachmentType.document,
  ".doc": AttachmentType.document,
  ".docx": AttachmentType.document,
  ".xls": AttachmentType.document,
  ".xlsx": AttachmentType.document,
  ".ppt": AttachmentType.document,
  ".pptx": AttachmentType.document,
  ".txt": AttachmentType.document,
  ".rtf": AttachmentType.document,
  ".odt": AttachmentType.document,
  ".ods": AttachmentType.document,
  ".odp": AttachmentType.document,
  ".csv": AttachmentType.document,
  ".md": AttachmentType.document,
};
