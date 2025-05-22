import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// A gateway to an external game source
class GameGateway extends Equatable {
  final String? id;
  final String name;
  final String? description;

  final String? messageContext;
  final String? iconUrl;
  final String? logoUrl;
  final String? websiteUrl;

  final String? baseUrl;
  final String? apiDocumentation;
  final String? apiVersion;

  final bool enabled;
  final AuthType? authType;
  final Map<String, dynamic>? authParameters;

  final int usageCount;
  final DateTime? lastUsed;

  final String? createdById;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GameGateway({
    required this.id,
    required this.name,
    this.description,
    this.messageContext,
    this.iconUrl,
    this.logoUrl,
    this.websiteUrl,
    this.baseUrl,
    this.apiDocumentation,
    this.apiVersion,
    this.enabled = true,
    this.authType,
    this.authParameters,
    this.usageCount = 0,
    this.lastUsed,
    this.createdById,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GameGateway.fromJson(Map<String, dynamic> json) {
    return GameGateway(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      messageContext: json['messageContext'],
      iconUrl: json['iconUrl'],
      logoUrl: json['logoUrl'],
      websiteUrl: json['websiteUrl'],
      baseUrl: json['baseUrl'],
      apiDocumentation: json['apiDocumentation'],
      apiVersion: json['apiVersion'],
      enabled: json['enabled'] ?? true,
      authType:
          json['authType'] != null
              ? AuthType.values.firstWhere(
                (e) => e.toString() == 'AuthType.${json['authType']}',
                orElse: () => AuthType.None,
              )
              : null,
      authParameters: json['authParameters'],
      usageCount: json['usageCount'] ?? 0,
      lastUsed:
          json['lastUsed'] != null ? DateTime.parse(json['lastUsed']) : null,
      createdById: json['createdById'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson({bool create = false}) {
    if (kDebugMode) {
      print('GameGateway toJson:');
      print('id: $id');
      print('name: $name');
      print('description: $description');
      print('messageContext: $messageContext');
      print('iconUrl: $iconUrl');
      print('logoUrl: $logoUrl');
      print('websiteUrl: $websiteUrl');
      print('baseUrl: $baseUrl');
      print('apiDocumentation: $apiDocumentation');
      print('apiVersion: $apiVersion');
      print('enabled: $enabled');
      print('authType: ${authType?.toString()}');
      print(authType?.toString().split('.').last);
      print(authType?.toString().split('.'));
    }

    final json = {
      'id': id,
      'name': name,
      'description': description,
      'messageContext': messageContext,
      'iconUrl': iconUrl,
      'logoUrl': logoUrl,
      'websiteUrl': websiteUrl,
      'baseUrl': baseUrl,
      'apiDocumentation': apiDocumentation,
      'apiVersion': apiVersion,
      'enabled': enabled,
      'authType': authType?.toString().split('.').last ?? AuthType.None.name,
      'authParameters': authParameters,
      'usageCount': usageCount,
      'lastUsed': lastUsed?.toIso8601String(),
      'createdById': createdById,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };

    if (create) {
      json.remove('id');
      json.remove('createdAt');
      json.remove('updatedAt');
      json.remove('lastUsed');
      json.remove('createdById');
      json.remove('usageCount');
    }

    return json;
  }

  /// Create a copy of this gateway with optional field updates
  GameGateway copyWith({
    String? id,
    String? name,
    String? description,
    String? messageContext,
    String? iconUrl,
    String? logoUrl,
    String? websiteUrl,
    String? baseUrl,
    String? apiDocumentation,
    String? apiVersion,
    bool? enabled,
    AuthType? authType,
    Map<String, dynamic>? authParameters,
    int? usageCount,
    DateTime? lastUsed,
    String? createdById,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GameGateway(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      messageContext: messageContext ?? this.messageContext,
      iconUrl: iconUrl ?? this.iconUrl,
      logoUrl: logoUrl ?? this.logoUrl,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      baseUrl: baseUrl ?? this.baseUrl,
      apiDocumentation: apiDocumentation ?? this.apiDocumentation,
      apiVersion: apiVersion ?? this.apiVersion,
      enabled: enabled ?? this.enabled,
      authType: authType ?? this.authType,
      authParameters: authParameters ?? this.authParameters,
      usageCount: usageCount ?? this.usageCount,
      lastUsed: lastUsed ?? this.lastUsed,
      createdById: createdById ?? this.createdById,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    messageContext,
    iconUrl,
    logoUrl,
    websiteUrl,
    baseUrl,
    apiDocumentation,
    apiVersion,
    enabled,
    authType,
    authParameters,
    usageCount,
    lastUsed,
    createdById,
    createdAt,
    updatedAt,
  ];
}

/// Authentication types supported by external game sources
enum AuthType { ApiKey, Basic, None, OAuth, PSK }
