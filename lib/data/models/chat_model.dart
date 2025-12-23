import 'package:intl/intl.dart';
import 'user_model.dart';

class Chat {
  final String id;
  final String? title;
  final ChatType type;
  final List<User> participants;
  final Message? lastMessage;
  final int unreadCount;
  final bool isMuted;
  final DateTime? lastActivity;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  Chat({
    required this.id,
    this.title,
    this.type = ChatType.direct,
    required this.participants,
    this.lastMessage,
    this.unreadCount = 0,
    this.isMuted = false,
    this.lastActivity,
    required this.createdAt,
    this.updatedAt,
  });
  
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] as String,
      title: json['title'] as String?,
      type: ChatType.fromString(json['type'] as String? ?? 'direct'),
      participants: (json['participants'] as List? ?? [])
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastMessage: json['lastMessage'] != null
          ? Message.fromJson(json['lastMessage'] as Map<String, dynamic>)
          : null,
      unreadCount: json['unreadCount'] as int? ?? 0,
      isMuted: json['isMuted'] as bool? ?? false,
      lastActivity: json['lastActivity'] != null
          ? DateTime.parse(json['lastActivity'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type.name,
      'participants': participants.map((e) => e.toJson()).toList(),
      'lastMessage': lastMessage?.toJson(),
      'unreadCount': unreadCount,
      'isMuted': isMuted,
      'lastActivity': lastActivity?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
  
  String get displayTitle {
    if (title != null && title!.isNotEmpty) {
      return title!;
    }
    
    if (type == ChatType.direct && participants.length == 2) {
      final otherUser = participants.firstWhere(
        (user) => user.id != 'current_user_id',
        orElse: () => participants.first,
      );
      return otherUser.username;
    }
    
    return 'Unnamed Chat';
  }
  
  String get displaySubtitle {
    if (lastMessage == null) {
      return 'No messages yet';
    }
    
    final prefix = lastMessage!.senderId == 'current_user_id' ? 'You: ' : '';
    final content = lastMessage!.content;
    
    if (content.length > 50) {
      return '$prefix${content.substring(0, 50)}...';
    }
    
    return '$prefix$content';
  }
  
  String get displayTime {
    if (lastActivity == null) {
      return '';
    }
    
    final now = DateTime.now();
    final difference = now.difference(lastActivity!);
    
    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return DateFormat('MMM d').format(lastActivity!);
    }
  }
  
  User? get otherUser {
    if (type != ChatType.direct || participants.length != 2) {
      return null;
    }
    
    return participants.firstWhere(
      (user) => user.id != 'current_user_id',
      orElse: () => participants.first,
    );
  }
  
  bool get isOnline {
    return otherUser?.status == UserStatus.online;
  }
  
  Chat copyWith({
    String? id,
    String? title,
    ChatType? type,
    List<User>? participants,
    Message? lastMessage,
    int? unreadCount,
    bool? isMuted,
    DateTime? lastActivity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Chat(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      isMuted: isMuted ?? this.isMuted,
      lastActivity: lastActivity ?? this.lastActivity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum ChatType {
  direct,
  group,
  channel;
  
  static ChatType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'direct':
      case 'dm':
        return direct;
      case 'group':
        return group;
      case 'channel':
        return channel;
      default:
        return direct;
    }
  }
  
  String get name {
    switch (this) {
      case ChatType.direct:
        return 'direct';
      case ChatType.group:
        return 'group';
      case ChatType.channel:
        return 'channel';
    }
  }
  
  String get displayName {
    switch (this) {
      case ChatType.direct:
        return 'Direct Message';
      case ChatType.group:
        return 'Group Chat';
      case ChatType.channel:
        return 'Channel';
    }
  }
}

class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final MessageType type;
  final MessageStatus status;
  final String? replyToMessageId;
  final List<MessageAttachment> attachments;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    this.type = MessageType.text,
    this.status = MessageStatus.sent,
    this.replyToMessageId,
    this.attachments = const [],
    required this.createdAt,
    this.updatedAt,
  });
  
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      senderId: json['senderId'] as String,
      content: json['content'] as String,
      type: MessageType.fromString(json['type'] as String? ?? 'text'),
      status: MessageStatus.fromString(json['status'] as String? ?? 'sent'),
      replyToMessageId: json['replyToMessageId'] as String?,
      attachments: (json['attachments'] as List? ?? [])
          .map((e) => MessageAttachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'type': type.name,
      'status': status.name,
      'replyToMessageId': replyToMessageId,
      'attachments': attachments.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
  
  bool get isMine => senderId == 'current_user_id';
  
  bool get hasAttachments => attachments.isNotEmpty;
  
  bool get isReply => replyToMessageId != null;
  
  Message copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? content,
    MessageType? type,
    MessageStatus? status,
    String? replyToMessageId,
    List<MessageAttachment>? attachments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Message(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      type: type ?? this.type,
      status: status ?? this.status,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum MessageType {
  text,
  image,
  video,
  audio,
  file,
  system;
  
  static MessageType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'text':
        return text;
      case 'image':
      case 'photo':
        return image;
      case 'video':
        return video;
      case 'audio':
      case 'voice':
        return audio;
      case 'file':
      case 'document':
        return file;
      case 'system':
        return system;
      default:
        return text;
    }
  }
  
  String get name {
    switch (this) {
      case MessageType.text:
        return 'text';
      case MessageType.image:
        return 'image';
      case MessageType.video:
        return 'video';
      case MessageType.audio:
        return 'audio';
      case MessageType.file:
        return 'file';
      case MessageType.system:
        return 'system';
    }
  }
  
  String get displayName {
    switch (this) {
      case MessageType.text:
        return 'Text';
      case MessageType.image:
        return 'Image';
      case MessageType.video:
        return 'Video';
      case MessageType.audio:
        return 'Audio';
      case MessageType.file:
        return 'File';
      case MessageType.system:
        return 'System';
    }
  }
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed;
  
  static MessageStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'sending':
        return sending;
      case 'sent':
        return sent;
      case 'delivered':
        return delivered;
      case 'read':
        return read;
      case 'failed':
        return failed;
      default:
        return sent;
    }
  }
  
  String get name {
    switch (this) {
      case MessageStatus.sending:
        return 'sending';
      case MessageStatus.sent:
        return 'sent';
      case MessageStatus.delivered:
        return 'delivered';
      case MessageStatus.read:
        return 'read';
      case MessageStatus.failed:
        return 'failed';
    }
  }
}

class MessageAttachment {
  final String id;
  final String type;
  final String url;
  final String filename;
  final int size;
  final int? width;
  final int? height;
  final String? thumbnailUrl;
  
  MessageAttachment({
    required this.id,
    required this.type,
    required this.url,
    required this.filename,
    required this.size,
    this.width,
    this.height,
    this.thumbnailUrl,
  });
  
  factory MessageAttachment.fromJson(Map<String, dynamic> json) {
    return MessageAttachment(
      id: json['id'] as String,
      type: json['type'] as String,
      url: json['url'] as String,
      filename: json['filename'] as String,
      size: json['size'] as int,
      width: json['width'] as int?,
      height: json['height'] as int?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'url': url,
      'filename': filename,
      'size': size,
      'width': width,
      'height': height,
      'thumbnailUrl': thumbnailUrl,
    };
  }
  
  String get fileSizeFormatted {
    if (size < 1024) {
      return '$size B';
    } else if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(1)} KB';
    } else if (size < 1024 * 1024 * 1024) {
      return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }
  
  bool get isImage => type.startsWith('image/');
  bool get isVideo => type.startsWith('video/');
  bool get isAudio => type.startsWith('audio/');
}
