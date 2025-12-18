// features/rundown/controllers/rundown_controller.dart
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/http_client.dart';
import '../../../core/network/openapi_stub.dart';

class RundownController extends GetxController {
  late final ApiClient api;

  final stories = <Story>[].obs;

  @override
  void onInit() {
    super.onInit();

    api = ApiClient(HttpClient('https://api.yournewsroom.com'));

    loadSample(); // remove later
  }

  void loadSample() {
    stories.assignAll(
      List.generate(
        8,
        (i) => Story(
          id: 'sid-$i',
          slug: 'Story ${i + 1}',
          orderNo: i + 1,
          status: 'draft',
          version: 1,
        ),
      ),
    );
  }

  Future<void> login() async {
    await api.login('editor@station.com', 'password');
    await loadRundown();
  }

  Future<void> loadRundown() async {
    final rundown = await api.getRundown();
    stories.assignAll(rundown.items);
  }

  Future<void> submit(String id) async {
    final updated = await api.submitStory(id);
    _replace(updated);
  }

  Future<void> approve(String id) async {
    final updated = await api.approveStory(id);
    _replace(updated);
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex--;

    final item = stories.removeAt(oldIndex);
    stories.insert(newIndex, item);

    await api.reorderStories(oldIndex, newIndex);
  }

  void _replace(Story story) {
    final index = stories.indexWhere((s) => s.id == story.id);
    if (index != -1) {
      stories[index] = story;
    }
  }
}
