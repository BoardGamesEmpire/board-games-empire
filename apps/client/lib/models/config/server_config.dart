import 'package:uuid/uuid.dart';

class ServerConfig {
  final String id;
  final String name;
  final String url;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastConnectedAt;

  ServerConfig({
    String? id,
    required this.name,
    required this.url,
    this.isActive = false,
    DateTime? createdAt,
    this.lastConnectedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  ServerConfig copyWith({
    String? name,
    String? url,
    bool? isActive,
    DateTime? lastConnectedAt,
  }) {
    return ServerConfig(
      id: id,
      name: name ?? this.name,
      url: url ?? this.url,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      lastConnectedAt: lastConnectedAt ?? this.lastConnectedAt,
    );
  }

  static String sanitizeUrl(String url) {
    String sanitized = url.trim();

    if (!sanitized.startsWith('http://') && !sanitized.startsWith('https://')) {
      sanitized = 'https://$sanitized';
    }

    if (sanitized.endsWith('/')) {
      sanitized = sanitized.substring(0, sanitized.length - 1);
    }

    return sanitized;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'lastConnectedAt': lastConnectedAt?.toIso8601String(),
    };
  }

  factory ServerConfig.fromJson(Map<String, dynamic> json) {
    return ServerConfig(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      isActive: json['isActive'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      lastConnectedAt:
          json['lastConnectedAt'] != null
              ? DateTime.parse(json['lastConnectedAt'])
              : null,
    );
  }
}
