import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class User {
  final String id;
  final String username;
  final String? email;
  final String? avatarUrl;
  final UserStatus status;
  final String? lastSeen;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  User({
    required this.id,
    required this.username,
    this.email,
    this.avatarUrl,
    this.status = UserStatus.offline,
    this.lastSeen,
    required this.createdAt,
    this.updatedAt,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      status: UserStatus.fromString(json['status'] as String? ?? 'offline'),
      lastSeen: json['lastSeen'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatarUrl': avatarUrl,
      'status': status.name,
      'lastSeen': lastSeen,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
  
  String get displayName => username;
  
  String get initials {
    final parts = username.split(' ');
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
  
  String get avatarDisplay {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return avatarUrl!;
    }
    return '';
  }
  
  String get statusText {
    switch (status) {
      case UserStatus.online:
        return 'Online';
      case UserStatus.away:
        return 'Away';
      case UserStatus.doNotDisturb:
        return 'Do not disturb';
      case UserStatus.offline:
        if (lastSeen != null) {
          final lastSeenDate = DateTime.tryParse(lastSeen!);
          if (lastSeenDate != null) {
            return 'Last seen ${DateFormat('MMM d, h:mm a').format(lastSeenDate)}';
          }
        }
        return 'Offline';
    }
  }
  
  Color get statusColor {
    switch (status) {
      case UserStatus.online:
        return const Color(0xFF3BA55C);
      case UserStatus.away:
        return const Color(0xFFFAA81A);
      case UserStatus.doNotDisturb:
        return const Color(0xFFF38688);
      case UserStatus.offline:
        return const Color(0xFF949BA4);
    }
  }
  
  User copyWith({
    String? id,
    String? username,
    String? email,
    String? avatarUrl,
    UserStatus? status,
    String? lastSeen,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      status: status ?? this.status,
      lastSeen: lastSeen ?? this.lastSeen,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum UserStatus {
  online,
  away,
  doNotDisturb,
  offline;

  static UserStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'online':
        return online;
      case 'away':
      case 'idle':
        return away;
      case 'dnd':
      case 'donotdisturb':
      case 'do_not_disturb':
        return doNotDisturb;
      case 'offline':
      case 'invisible':
      default:
        return offline;
    }
  }

  String get name {
    switch (this) {
      case UserStatus.online:
        return 'online';
      case UserStatus.away:
        return 'away';
      case UserStatus.doNotDisturb:
        return 'dnd';
      case UserStatus.offline:
        return 'offline';
    }
  }

  String get displayName {
    switch (this) {
      case UserStatus.online:
        return 'Online';
      case UserStatus.away:
        return 'Away';
      case UserStatus.doNotDisturb:
        return 'Do not disturb';
      case UserStatus.offline:
        return 'Offline';
    }
  }
}
