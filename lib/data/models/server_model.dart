import 'package:flutter/material.dart';
import 'user_model.dart';

class Server {
  final String id;
  final String name;
  final String? description;
  final String? iconUrl;
  final String? bannerUrl;
  final String ownerId;
  final List<Channel> channels;
  final List<ServerMember> members;
  final List<Role> roles;
  final ServerSettings settings;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  Server({
    required this.id,
    required this.name,
    this.description,
    this.iconUrl,
    this.bannerUrl,
    required this.ownerId,
    this.channels = const [],
    this.members = const [],
    this.roles = const [],
    ServerSettings? settings,
    required this.createdAt,
    this.updatedAt,
  }) : settings = settings ?? ServerSettings();
  
  factory Server.fromJson(Map<String, dynamic> json) {
    return Server(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      iconUrl: json['iconUrl'] as String?,
      bannerUrl: json['bannerUrl'] as String?,
      ownerId: json['ownerId'] as String,
      channels: (json['channels'] as List? ?? [])
          .map((e) => Channel.fromJson(e as Map<String, dynamic>))
          .toList(),
      members: (json['members'] as List? ?? [])
          .map((e) => ServerMember.fromJson(e as Map<String, dynamic>))
          .toList(),
      roles: (json['roles'] as List? ?? [])
          .map((e) => Role.fromJson(e as Map<String, dynamic>))
          .toList(),
      settings: json['settings'] != null
          ? ServerSettings.fromJson(json['settings'] as Map<String, dynamic>)
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
      'name': name,
      'description': description,
      'iconUrl': iconUrl,
      'bannerUrl': bannerUrl,
      'ownerId': ownerId,
      'channels': channels.map((e) => e.toJson()).toList(),
      'members': members.map((e) => e.toJson()).toList(),
      'roles': roles.map((e) => e.toJson()).toList(),
      'settings': settings.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
  
  String get displayName => name;
  
  String get memberCountText {
    final count = members.length;
    return '$count member${count != 1 ? 's' : ''}';
  }
  
  List<Channel> get textChannels => 
      channels.where((c) => c.type == ChannelType.text).toList();
  
  List<Channel> get voiceChannels => 
      channels.where((c) => c.type == ChannelType.voice).toList();
  
  List<Channel> get categoryChannels => 
      channels.where((c) => c.type == ChannelType.category).toList();
  
  Role? getRoleById(String roleId) {
    try {
      return roles.firstWhere((role) => role.id == roleId);
    } catch (e) {
      return null;
    }
  }
  
  Server copyWith({
    String? id,
    String? name,
    String? description,
    String? iconUrl,
    String? bannerUrl,
    String? ownerId,
    List<Channel>? channels,
    List<ServerMember>? members,
    List<Role>? roles,
    ServerSettings? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Server(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      ownerId: ownerId ?? this.ownerId,
      channels: channels ?? this.channels,
      members: members ?? this.members,
      roles: roles ?? this.roles,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class Channel {
  final String id;
  final String serverId;
  final String? parentId;
  final String name;
  final ChannelType type;
  final String? topic;
  final int position;
  final bool isNsfw;
  final ChannelPermissions permissions;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  Channel({
    required this.id,
    required this.serverId,
    this.parentId,
    required this.name,
    this.type = ChannelType.text,
    this.topic,
    this.position = 0,
    this.isNsfw = false,
    ChannelPermissions? permissions,
    required this.createdAt,
    this.updatedAt,
  }) : permissions = permissions ?? ChannelPermissions();
  
  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'] as String,
      serverId: json['serverId'] as String,
      parentId: json['parentId'] as String?,
      name: json['name'] as String,
      type: ChannelType.fromString(json['type'] as String? ?? 'text'),
      topic: json['topic'] as String?,
      position: json['position'] as int? ?? 0,
      isNsfw: json['isNsfw'] as bool? ?? false,
      permissions: json['permissions'] != null
          ? ChannelPermissions.fromJson(json['permissions'] as Map<String, dynamic>)
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
      'serverId': serverId,
      'parentId': parentId,
      'name': name,
      'type': type.name,
      'topic': topic,
      'position': position,
      'isNsfw': isNsfw,
      'permissions': permissions.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
  
  String get displayName => name;
  
  bool get isTextChannel => type == ChannelType.text;
  bool get isVoiceChannel => type == ChannelType.voice;
  bool get isCategory => type == ChannelType.category;
  
  IconData get icon {
    switch (type) {
      case ChannelType.text:
        return Icons.tag;
      case ChannelType.voice:
        return Icons.volume_up;
      case ChannelType.category:
        return Icons.folder;
    }
  }
  
  Channel copyWith({
    String? id,
    String? serverId,
    String? parentId,
    String? name,
    ChannelType? type,
    String? topic,
    int? position,
    bool? isNsfw,
    ChannelPermissions? permissions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Channel(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      type: type ?? this.type,
      topic: topic ?? this.topic,
      position: position ?? this.position,
      isNsfw: isNsfw ?? this.isNsfw,
      permissions: permissions ?? this.permissions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum ChannelType {
  text,
  voice,
  category;
  
  static ChannelType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'text':
        return text;
      case 'voice':
        return voice;
      case 'category':
        return category;
      default:
        return text;
    }
  }
  
  String get name {
    switch (this) {
      case ChannelType.text:
        return 'text';
      case ChannelType.voice:
        return 'voice';
      case ChannelType.category:
        return 'category';
    }
  }
}

class ChannelPermissions {
  final bool canView;
  final bool canSendMessages;
  final bool canManageMessages;
  final bool canManageChannel;
  final bool canConnect;
  final bool canSpeak;
  
  const ChannelPermissions({
    this.canView = true,
    this.canSendMessages = true,
    this.canManageMessages = false,
    this.canManageChannel = false,
    this.canConnect = true,
    this.canSpeak = true,
  });
  
  factory ChannelPermissions.fromJson(Map<String, dynamic> json) {
    return ChannelPermissions(
      canView: json['canView'] as bool? ?? true,
      canSendMessages: json['canSendMessages'] as bool? ?? true,
      canManageMessages: json['canManageMessages'] as bool? ?? false,
      canManageChannel: json['canManageChannel'] as bool? ?? false,
      canConnect: json['canConnect'] as bool? ?? true,
      canSpeak: json['canSpeak'] as bool? ?? true,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'canView': canView,
      'canSendMessages': canSendMessages,
      'canManageMessages': canManageMessages,
      'canManageChannel': canManageChannel,
      'canConnect': canConnect,
      'canSpeak': canSpeak,
    };
  }
  
  ChannelPermissions copyWith({
    bool? canView,
    bool? canSendMessages,
    bool? canManageMessages,
    bool? canManageChannel,
    bool? canConnect,
    bool? canSpeak,
  }) {
    return ChannelPermissions(
      canView: canView ?? this.canView,
      canSendMessages: canSendMessages ?? this.canSendMessages,
      canManageMessages: canManageMessages ?? this.canManageMessages,
      canManageChannel: canManageChannel ?? this.canManageChannel,
      canConnect: canConnect ?? this.canConnect,
      canSpeak: canSpeak ?? this.canSpeak,
    );
  }
}

class ServerMember {
  final String id;
  final String serverId;
  final String userId;
  final String? nickname;
  final DateTime joinedAt;
  final List<String> roleIds;
  
  ServerMember({
    required this.id,
    required this.serverId,
    required this.userId,
    this.nickname,
    required this.joinedAt,
    this.roleIds = const [],
  });
  
  factory ServerMember.fromJson(Map<String, dynamic> json) {
    return ServerMember(
      id: json['id'] as String,
      serverId: json['serverId'] as String,
      userId: json['userId'] as String,
      nickname: json['nickname'] as String?,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      roleIds: (json['roleIds'] as List? ?? [])
          .map((e) => e as String)
          .toList(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serverId': serverId,
      'userId': userId,
      'nickname': nickname,
      'joinedAt': joinedAt.toIso8601String(),
      'roleIds': roleIds,
    };
  }
  
  String get displayName => nickname ?? userId;
}

class Role {
  final String id;
  final String serverId;
  final String name;
  final int color;
  final int position;
  final RolePermissions permissions;
  final bool isHoisted;
  final bool isMentionable;
  final DateTime createdAt;
  
  Role({
    required this.id,
    required this.serverId,
    required this.name,
    this.color = 0xFF95A5A6,
    this.position = 0,
    RolePermissions? permissions,
    this.isHoisted = false,
    this.isMentionable = true,
    required this.createdAt,
  }) : permissions = permissions ?? RolePermissions();
  
  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] as String,
      serverId: json['serverId'] as String,
      name: json['name'] as String,
      color: json['color'] as int? ?? 0xFF95A5A6,
      position: json['position'] as int? ?? 0,
      permissions: json['permissions'] != null
          ? RolePermissions.fromJson(json['permissions'] as Map<String, dynamic>)
          : null,
      isHoisted: json['isHoisted'] as bool? ?? false,
      isMentionable: json['isMentionable'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serverId': serverId,
      'name': name,
      'color': color,
      'position': position,
      'permissions': permissions.toJson(),
      'isHoisted': isHoisted,
      'isMentionable': isMentionable,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  String get displayName => name;
  
  Color get colorValue => Color(color);
}

class RolePermissions {
  final bool canManageServer;
  final bool canManageChannels;
  final bool canManageRoles;
  final bool canKickMembers;
  final bool canBanMembers;
  final bool canManageMessages;
  final bool canEmbedLinks;
  final bool canAttachFiles;
  final bool canMentionEveryone;
  final bool canUseExternalEmojis;
  final bool canAddReactions;
  final bool canViewAuditLog;
  final bool canPrioritySpeaker;
  final bool canStream;
  final bool canConnect;
  final bool canSpeak;
  
  const RolePermissions({
    this.canManageServer = false,
    this.canManageChannels = false,
    this.canManageRoles = false,
    this.canKickMembers = false,
    this.canBanMembers = false,
    this.canManageMessages = false,
    this.canEmbedLinks = true,
    this.canAttachFiles = true,
    this.canMentionEveryone = false,
    this.canUseExternalEmojis = true,
    this.canAddReactions = true,
    this.canViewAuditLog = false,
    this.canPrioritySpeaker = false,
    this.canStream = true,
    this.canConnect = true,
    this.canSpeak = true,
  });
  
  factory RolePermissions.fromJson(Map<String, dynamic> json) {
    return RolePermissions(
      canManageServer: json['canManageServer'] as bool? ?? false,
      canManageChannels: json['canManageChannels'] as bool? ?? false,
      canManageRoles: json['canManageRoles'] as bool? ?? false,
      canKickMembers: json['canKickMembers'] as bool? ?? false,
      canBanMembers: json['canBanMembers'] as bool? ?? false,
      canManageMessages: json['canManageMessages'] as bool? ?? false,
      canEmbedLinks: json['canEmbedLinks'] as bool? ?? true,
      canAttachFiles: json['canAttachFiles'] as bool? ?? true,
      canMentionEveryone: json['canMentionEveryone'] as bool? ?? false,
      canUseExternalEmojis: json['canUseExternalEmojis'] as bool? ?? true,
      canAddReactions: json['canAddReactions'] as bool? ?? true,
      canViewAuditLog: json['canViewAuditLog'] as bool? ?? false,
      canPrioritySpeaker: json['canPrioritySpeaker'] as bool? ?? false,
      canStream: json['canStream'] as bool? ?? true,
      canConnect: json['canConnect'] as bool? ?? true,
      canSpeak: json['canSpeak'] as bool? ?? true,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'canManageServer': canManageServer,
      'canManageChannels': canManageChannels,
      'canManageRoles': canManageRoles,
      'canKickMembers': canKickMembers,
      'canBanMembers': canBanMembers,
      'canManageMessages': canManageMessages,
      'canEmbedLinks': canEmbedLinks,
      'canAttachFiles': canAttachFiles,
      'canMentionEveryone': canMentionEveryone,
      'canUseExternalEmojis': canUseExternalEmojis,
      'canAddReactions': canAddReactions,
      'canViewAuditLog': canViewAuditLog,
      'canPrioritySpeaker': canPrioritySpeaker,
      'canStream': canStream,
      'canConnect': canConnect,
      'canSpeak': canSpeak,
    };
  }
}

class ServerSettings {
  final String defaultMessageNotifications;
  final bool isWidgetEnabled;
  final String widgetChannelId;
  final String systemChannelId;
  final bool suppressEveryone;
  final bool suppressRoles;
  
  const ServerSettings({
    this.defaultMessageNotifications = 'all',
    this.isWidgetEnabled = false,
    this.widgetChannelId = '',
    this.systemChannelId = '',
    this.suppressEveryone = false,
    this.suppressRoles = false,
  });
  
  factory ServerSettings.fromJson(Map<String, dynamic> json) {
    return ServerSettings(
      defaultMessageNotifications: json['defaultMessageNotifications'] as String? ?? 'all',
      isWidgetEnabled: json['isWidgetEnabled'] as bool? ?? false,
      widgetChannelId: json['widgetChannelId'] as String? ?? '',
      systemChannelId: json['systemChannelId'] as String? ?? '',
      suppressEveryone: json['suppressEveryone'] as bool? ?? false,
      suppressRoles: json['suppressRoles'] as bool? ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'defaultMessageNotifications': defaultMessageNotifications,
      'isWidgetEnabled': isWidgetEnabled,
      'widgetChannelId': widgetChannelId,
      'systemChannelId': systemChannelId,
      'suppressEveryone': suppressEveryone,
      'suppressRoles': suppressRoles,
    };
  }
}
