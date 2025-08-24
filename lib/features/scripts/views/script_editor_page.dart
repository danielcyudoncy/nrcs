// features/scripts/views/script_editor_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nrcs/features/scripts/controllers/script_controller.dart';
import 'package:nrcs/core/services/story_service.dart';
import 'package:nrcs/core/models/story.dart';
import 'package:nrcs/core/auth/token_provider.dart';

class ScriptEditorPage extends StatelessWidget {
  final Story story;
  const ScriptEditorPage({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
  final svc = Get.find<StoryService>();
  final ctrl = Get.put(ScriptController(service: svc));
  ctrl.load(story);
  final textCtrl = TextEditingController(text: ctrl.content.value);
  // listen for remote updates to this story
  svc.stream.listen((ev) {
    if (ev.story != null && ev.story!.id == story.id) {
      // update local
      ctrl.story.value = ev.story;
      ctrl.content.value = ev.story!.script;
      textCtrl.text = ev.story!.script;
    }
  });
    return Scaffold(
      appBar: AppBar(title: const Text('Script Editor')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(text: story.slug),
              decoration: const InputDecoration(labelText: 'Slug'),
              onChanged: (v) => ctrl.story.value = ctrl.story.value!.copyWith(slug: v),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: textCtrl,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Write script...'),
                onChanged: (v) => ctrl.content.value = v,
              ),
            ),
            const SizedBox(height: 12),
            Row(children: [
              ElevatedButton(
                onPressed: () async {
                  await ctrl.save();
                  Get.back();
                },
                child: const Text('Save')),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () async {
                  await ctrl.submit();
                  Get.back();
                },
                child: const Text('Submit')),
              const SizedBox(width: 8),
              if (TokenProvider.roles.contains('approver')) ElevatedButton(
                onPressed: () async {
                  await ctrl.approve();
                  Get.back();
                },
                child: const Text('Approve')),
            ])
          ],
        ),
      ),
    );
  }
}
