// features/scripts/controllers/script_controller.dart
import 'package:get/get.dart';
import 'package:nrcs/core/models/story.dart';
import 'package:nrcs/core/services/story_service.dart';
import 'package:flutter_quill/flutter_quill.dart';

class ScriptController extends GetxController {
  final StoryService service;
  final story = Rxn<Story>();
  final content = ''.obs;
  late QuillController quillController;

  ScriptController({required this.service});

  @override
  void onInit() {
    super.onInit();
    quillController = QuillController.basic();
  }

  void load(Story s) {
    story.value = s;
    content.value = s.script;

    // Update the QuillController document
    final doc = Document()..insert(0, s.script);
    quillController.document = doc;
  }

  Future<void> save() async {
    final s = story.value!;
    // Get the plain text from QuillController
    final plainText = quillController.document.toPlainText();

    final updated = Story(
      id: s.id,
      slug: s.slug,
      orderNo: s.orderNo,
      status: s.status,
      script: plainText,
      version: s.version,
      updatedBy: s.updatedBy,
    );
    service.save(updated, user: 'local-user');
  }

  Future<void> submit() async {
    final s = story.value!;
    // Get the plain text from QuillController
    final plainText = quillController.document.toPlainText();

    service.save(
      Story(
        id: s.id,
        slug: s.slug,
        orderNo: s.orderNo,
        status: 'submitted',
        script: plainText,
        version: s.version,
        updatedBy: 'local-user',
      ),
      user: 'local-user',
    );
  }

  Future<void> approve() async {
    final s = story.value!;
    service.approve(s.id, user: 'approver');
  }

  @override
  void onClose() {
    quillController.dispose();
    super.onClose();
  }
}
