// features/rundown/views/rundown_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nrcs/core/services/story_service.dart';
import '../controllers/rundown_controller.dart';
import 'package:nrcs/features/scripts/views/script_editor_page.dart';


class RundownPage extends StatelessWidget {
  const RundownPage({super.key});

  @override
  Widget build(BuildContext context) {
    final svc = Get.put(StoryService());
  final controller = Get.put(RundownController());
  controller.loadSample();
    return Scaffold(
      appBar: AppBar(title: const Text('Rundown')),
      body: StreamBuilder<StoryEvent>(
        stream: svc.stream,
        initialData: StoryEvent(type: StoryEventType.list, list: svc.list()),
        builder: (context, snap) {
          final ev = snap.data!;
          final stories = ev.list ?? svc.list();
          return ReorderableListView.builder(
            itemCount: stories.length,
            onReorder: (oldIndex, newIndex) {
              // adjust newIndex per ReorderableListView behaviour
              if (newIndex > oldIndex) newIndex -= 1;
              svc.reorder(oldIndex, newIndex);
            },
            itemBuilder: (context, i) {
              final s = stories[i];
              return ListTile(
                key: ValueKey(s.id),
                leading: Text('${s.orderNo}'),
                title: Text(s.slug),
                subtitle: Row(children: [Text(s.status), const SizedBox(width: 8), if (s.updatedBy!=null) Text('by ${s.updatedBy}', style: const TextStyle(fontSize: 12))]),
                trailing: Chip(label: Text(s.status)),
                onTap: () => Get.to(() => ScriptEditorPage(story: s)),
              );
            },
          );
        },
      ),
    );
  }
}
