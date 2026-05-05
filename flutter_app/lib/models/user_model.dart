class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? profileImage;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.profileImage,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      profileImage: json['profile_image'] as String?,
      createdAt: json['created_at'] is String
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'profile_image': profileImage,
        'created_at': createdAt.toIso8601String(),
      };

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AuthToken {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final User user;
  final String? refreshToken;

  AuthToken({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
    this.refreshToken,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String? ?? 'bearer',
      expiresIn: json['expires_in'] as int? ?? 3600,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      refreshToken: json['refresh_token'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'token_type': tokenType,
        'expires_in': expiresIn,
        'user': user.toJson(),
        'refresh_token': refreshToken,
      };
}
