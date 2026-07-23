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

  ".webm": AttachmentType.video,
  ".mkv": AttachmentType.video,
  ".flv": AttachmentType.video,
  ".f4v": AttachmentType.video,
  ".f4p": AttachmentType.video,
  ".f4a": AttachmentType.video,
  ".f4b": AttachmentType.video,
  ".vob": AttachmentType.video,
  ".ogv": AttachmentType.video,
  ".drc": AttachmentType.video,
  ".gifv": AttachmentType.video,
  ".mng": AttachmentType.video,
  ".avi": AttachmentType.video,
  ".mts": AttachmentType.video,
  ".m2ts": AttachmentType.video,
  ".ts": AttachmentType.video,
  ".mov": AttachmentType.video,
  ".qt": AttachmentType.video,
  ".wmv": AttachmentType.video,
  ".yuv": AttachmentType.video,
  ".rm": AttachmentType.video,
  ".rmvb": AttachmentType.video,
  ".viv": AttachmentType.video,
  ".asf": AttachmentType.video,
  ".amv": AttachmentType.video,
  ".mp4": AttachmentType.video,
  ".m4p": AttachmentType.video,
  ".m4v": AttachmentType.video,
  ".mpg": AttachmentType.video,
  ".mp2": AttachmentType.video,
  ".mpeg": AttachmentType.video,
  ".mpe": AttachmentType.video,
  ".mpv": AttachmentType.video,
  ".m2v": AttachmentType.video,
  ".svi": AttachmentType.video,
  ".3gp": AttachmentType.video,
  ".3g2": AttachmentType.video,
  ".mxf": AttachmentType.video,
  ".roq": AttachmentType.video,
  ".nsv": AttachmentType.video,

  ".mp3": AttachmentType.audio,
  ".aif": AttachmentType.audio,
  ".mid": AttachmentType.audio,
  ".wav": AttachmentType.audio,
  ".aac": AttachmentType.audio,
  ".flac": AttachmentType.audio,
  ".alac": AttachmentType.audio,
  ".oga": AttachmentType.audio,
  ".ogg": AttachmentType.audio,
  ".mogg": AttachmentType.audio,
  ".aiff": AttachmentType.audio,
  ".m4a": AttachmentType.audio,
  ".wma": AttachmentType.audio,
  ".opus": AttachmentType.audio,

  ".pdf": AttachmentType.document,
  ".doc": AttachmentType.document,
  ".docx": AttachmentType.document,
  ".eml": AttachmentType.document,
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
