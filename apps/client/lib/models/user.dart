class User {
  final String id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? avatar;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'avatar': avatar,
    };
  }
}

class UserSession {
  final String id;
  final String? ipAddress;
  final String? userAgent;
  final Map<String, dynamic>? deviceInfo;
  final DateTime createdAt;
  final DateTime lastActive;
  final DateTime expiresAt;
  final bool isCurrentSession;

  UserSession({
    required this.id,
    this.ipAddress,
    this.userAgent,
    this.deviceInfo,
    required this.createdAt,
    required this.lastActive,
    required this.expiresAt,
    this.isCurrentSession = false,
  });

  factory UserSession.fromJson(
    Map<String, dynamic> json, {
    bool isCurrentSession = false,
  }) {
    return UserSession(
      id: json['id'],
      ipAddress: json['ipAddress'],
      userAgent: json['userAgent'],
      deviceInfo: json['deviceInfo'],
      createdAt: DateTime.parse(json['createdAt']),
      lastActive: DateTime.parse(json['lastActive']),
      expiresAt: DateTime.parse(json['expiresAt']),
      isCurrentSession: isCurrentSession,
    );
  }

  String get deviceName {
    if (deviceInfo != null &&
        deviceInfo!.containsKey('browser') &&
        deviceInfo!.containsKey('os')) {
      return '${deviceInfo!['browser']} on ${deviceInfo!['os']}';
    }

    return userAgent?.split(' ').first ?? 'Unknown device';
  }
}
