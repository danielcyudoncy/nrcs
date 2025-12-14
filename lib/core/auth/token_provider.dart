// core/auth/token_provider.dart
class TokenProvider {
  static String? token;
  static String? username;
  static List<String> roles = [];
  static UserRole? currentRole;

  static bool get isWriter => currentRole == UserRole.writer;
  static bool get isCaster => currentRole == UserRole.caster;

  static void setUser(String token, String username, List<String> roles) {
    TokenProvider.token = token;
    TokenProvider.username = username;
    TokenProvider.roles = roles;
    currentRole = _determinePrimaryRole(roles);
  }

  static void clear() {
    token = null;
    username = null;
    roles = [];
    currentRole = null;
  }

  static UserRole _determinePrimaryRole(List<String> roles) {
    // Priority: writer > caster > other roles
    if (roles.contains('writer')) return UserRole.writer;
    if (roles.contains('caster')) return UserRole.caster;
    if (roles.contains('admin')) return UserRole.admin;
    return UserRole.writer; // Default to writer role
  }
}

enum UserRole { writer, caster, admin }

class User {
  final String username;
  final List<String> roles;
  final UserRole primaryRole;

  User({required this.username, required this.roles})
    : primaryRole = TokenProvider._determinePrimaryRole(roles);
}
