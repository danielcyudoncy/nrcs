// core/network/api_client.dart
import 'http_client.dart';
import 'openapi_stub.dart';

class ApiClient implements OpenApiClient {
  ApiClient(this.http);

  final HttpClient http;

  @override
  Future<LoginResponse> login(String username, String password) async {
    final json = await http.post(
      '/auth/login',
      body: {'email': username, 'password': password},
    );

    final response = LoginResponse.fromJson(json);
    http.token = response.token;
    return response;
  }

  @override
  Future<RundownResponse> getRundown() async {
    final json = await http.get('/rundowns/today');
    return RundownResponse.fromJson(json);
  }

  @override
  Future<List<Story>> getStories() async {
    final rundown = await getRundown();
    return rundown.items;
  }

  @override
  Future<Story> getStory(String id) async {
    final json = await http.get('/stories/$id');
    return Story.fromJson(json);
  }

  @override
  Future<Story> createStory(Map<String, dynamic> request) async {
    final json = await http.post('/stories', body: request);
    return Story.fromJson(json);
  }

  @override
  Future<Story> updateStory(String id, Map<String, dynamic> request) async {
    final json = await http.put('/stories/$id', body: request);
    return Story.fromJson(json);
  }

  @override
  Future<void> deleteStory(String id) async {
    await http.delete('/stories/$id');
  }

  @override
  Future<Story> submitStory(String id) async {
    final json = await http.post('/stories/$id/submit');
    return Story.fromJson(json);
  }

  @override
  Future<Story> approveStory(String id) async {
    final json = await http.post('/stories/$id/approve');
    return Story.fromJson(json);
  }

  @override
  Future<void> reorderStories(int fromIndex, int toIndex) async {
    await http.post(
      '/stories/reorder',
      body: {'fromIndex': fromIndex, 'toIndex': toIndex},
    );
  }
}
