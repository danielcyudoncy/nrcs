// features/scripts/controllers/script_controller.dart
import 'package:get/get.dart';
import 'package:nrcs/core/models/story.dart';
import 'package:nrcs/core/services/story_service.dart';

class ScriptController extends GetxController {
  final StoryService service;
  final story = Rxn<Story>();
  final content = ''.obs;

  ScriptController({required this.service});

  void load(Story s){
    story.value = s;
    content.value = s.script;
  }

  Future<void> save() async {
    final s = story.value!;
    final updated = Story(id: s.id, slug: s.slug, orderNo: s.orderNo, status: s.status, script: content.value, version: s.version, updatedBy: s.updatedBy);
    service.save(updated, user: 'local-user');
  }

  Future<void> submit() async {
    final s = story.value!;
    service.save(Story(id: s.id, slug: s.slug, orderNo: s.orderNo, status: 'submitted', script: content.value, version: s.version, updatedBy: 'local-user'), user: 'local-user');
  }

  Future<void> approve() async {
    final s = story.value!;
    service.approve(s.id, user: 'approver');
  }
}
