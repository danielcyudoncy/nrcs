// core/network/openapi_stub.dart

class Story {
  final String id;
  final String slug;
  final int orderNo;
  final String status;
  final String? script;
  final int version;
  final String? updatedBy;

  Story({
    required this.id,
    required this.slug,
    required this.orderNo,
    required this.status,
    this.script,
    required this.version,
    this.updatedBy,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      slug: json['slug'],
      orderNo: json['orderNo'],
      status: json['status'],
      script: json['script'],
      version: json['version'],
      updatedBy: json['updatedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'orderNo': orderNo,
      'status': status,
      'script': script,
      'version': version,
      'updatedBy': updatedBy,
    };
  }
}

class RundownResponse {
  final List<Story> items;

  RundownResponse({required this.items});

  factory RundownResponse.fromJson(Map<String, dynamic> json) {
    return RundownResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) => Story.fromJson(e))
          .toList(),
    );
  }
}

class LoginResponse {
  final String token;

  LoginResponse({required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(token: json['token']);
  }
}

/// =======================
/// API CLIENT INTERFACE
/// =======================

abstract class OpenApiClient {
  /// =======================
  /// AUTH
  /// =======================
  Future<LoginResponse> login(String username, String password);

  /// =======================
  /// RUNDOWN
  /// =======================
  Future<RundownResponse> getRundown();

  /// =======================
  /// STORIES
  /// =======================
  Future<List<Story>> getStories();
  Future<Story> getStory(String id);
  Future<Story> createStory(Map<String, dynamic> request);
  Future<Story> updateStory(String id, Map<String, dynamic> request);
  Future<void> deleteStory(String id);

  /// =======================
  /// WORKFLOW
  /// =======================
  Future<Story> submitStory(String id);
  Future<Story> approveStory(String id);
  Future<void> reorderStories(int fromIndex, int toIndex);
}
