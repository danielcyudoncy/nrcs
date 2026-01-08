// core/auth/token_provider.dart
class TokenProvider {
  static String? token;
  static String? username;
  static List<String> roles = [];
  static UserRole? currentRole;

  static bool get isReporter => currentRole == UserRole.reporter;
  static bool get isEditor => currentRole == UserRole.editor;
  static bool get isProducer => currentRole == UserRole.producer;
  static bool get isAnchor => currentRole == UserRole.anchor;
  static bool get isAdmin => currentRole == UserRole.admin;

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
    // Priority: admin > producer > editor > reporter > anchor
    if (roles.contains('admin')) return UserRole.admin;
    if (roles.contains('producer')) return UserRole.producer;
    if (roles.contains('editor')) return UserRole.editor;
    if (roles.contains('reporter')) return UserRole.reporter;
    if (roles.contains('anchor')) return UserRole.anchor;
    return UserRole.reporter; // Default to reporter role
  }
}

enum UserRole { reporter, editor, producer, anchor, admin }

class User {
  final String username;
  final List<String> roles;
  final UserRole primaryRole;

  User({required this.username, required this.roles})
    : primaryRole = TokenProvider._determinePrimaryRole(roles);
}
