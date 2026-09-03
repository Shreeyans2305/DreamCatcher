/// Represents an authenticated user session in DreamCatcher.
/// Sensitive tokens and identity fields are excluded from toString logging.
class AuthUser {
  final String id;
  final String phoneNumber;
  final String email;
  final String displayName;
  final String token;
  final String authProvider; // 'google', 'otp', 'gov_id'
  final bool isProfileComplete;

  const AuthUser({
    required this.id,
    this.phoneNumber = '',
    this.email = '',
    required this.displayName,
    required this.token,
    this.authProvider = 'otp',
    this.isProfileComplete = false,
  });

  AuthUser copyWith({
    String? id,
    String? phoneNumber,
    String? email,
    String? displayName,
    String? token,
    String? authProvider,
    bool? isProfileComplete,
  }) {
    return AuthUser(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      token: token ?? this.token,
      authProvider: authProvider ?? this.authProvider,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'email': email,
      'displayName': displayName,
      'token': token,
      'authProvider': authProvider,
      'isProfileComplete': isProfileComplete,
    };
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      email: json['email'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      token: json['token'] as String? ?? '',
      authProvider: json['authProvider'] as String? ?? 'otp',
      isProfileComplete: json['isProfileComplete'] as bool? ?? false,
    );
  }

  @override
  String toString() =>
      'AuthUser(id: $id, provider: $authProvider, isProfileComplete: $isProfileComplete, token: [SECURE])';
}
