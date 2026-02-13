// core/services/story_service.dart
import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:nrcs/core/models/story.dart';

enum StoryEventType { list, upsert, delete, reorder, approve, submit }

class StoryEvent {
  final StoryEventType type;
  final Story? story;
  final List<Story>? list;
  StoryEvent({required this.type, this.story, this.list});
}

class StoryService {
  final _rng = Uuid();
  final List<Story> _items = [];
  final _ctrl = StreamController<StoryEvent>.broadcast();

  StoryService({bool enableWsDemo = false}) {
    if (enableWsDemo) {
      _loadDemoDataInternal();
    }
    // emit initial list (empty or with demo data)
    Future.microtask(
      () => _ctrl.add(
        StoryEvent(type: StoryEventType.list, list: List.unmodifiable(_items)),
      ),
    );
  }

  void _loadDemoDataInternal() {
    final priorities = ['low', 'medium', 'high', 'urgent'];
    for (var i = 0; i < 8; i++) {
      _items.add(
        Story(
          id: _rng.v4(),
          slug: 'Story ${i + 1}',
          orderNo: i + 1,
          status: 'draft',
          assignedTo: i % 2 == 0 ? null : 'Reporter ${i + 1}',
          notes: i % 3 == 0 ? 'Urgent update needed' : null,
          priority: priorities[i % priorities.length],
        ),
      );
    }
  }

  Stream<StoryEvent> get stream => _ctrl.stream;

  List<Story> list() => List.unmodifiable(_items);

  Story save(Story s, {required String user}) {
    final idx = _items.indexWhere((it) => it.id == s.id);
    final updated = s.copyWith(
      version: s.version + 1,
      updatedBy: user,
    );
    if (idx == -1) {
      _items.add(updated);
    } else {
      _items[idx] = updated;
    }
    _ctrl.add(StoryEvent(type: StoryEventType.upsert, story: updated));
    return updated;
  }

  Story updateNotes(String id, String notes, {required String user}) {
    final idx = _items.indexWhere((it) => it.id == id);
    if (idx == -1) throw Exception('not found');
    final s = _items[idx];
    final updated = s.copyWith(notes: notes, updatedBy: user, version: s.version + 1);
    _items[idx] = updated;
    _ctrl.add(StoryEvent(type: StoryEventType.upsert, story: updated));
    return updated;
  }

  Story updatePriority(String id, String priority, {required String user}) {
    final idx = _items.indexWhere((it) => it.id == id);
    if (idx == -1) throw Exception('not found');
    final s = _items[idx];
    final updated = s.copyWith(priority: priority, updatedBy: user, version: s.version + 1);
    _items[idx] = updated;
    _ctrl.add(StoryEvent(type: StoryEventType.upsert, story: updated));
    return updated;
  }

  Story assign(String id, String? assignee, {required String user}) {
    final idx = _items.indexWhere((it) => it.id == id);
    if (idx == -1) throw Exception('not found');
    final s = _items[idx];
    final updated = s.copyWith(assignedTo: assignee, updatedBy: user, version: s.version + 1);
    _items[idx] = updated;
    _ctrl.add(StoryEvent(type: StoryEventType.upsert, story: updated));
    return updated;
  }

  Story submit(String id, {required String user}) {
    final idx = _items.indexWhere((it) => it.id == id);
    if (idx == -1) throw Exception('not found');
    final s = _items[idx];
    final updated = s.copyWith(status: 'submitted', updatedBy: user, version: s.version + 1);
    _items[idx] = updated;
    _ctrl.add(StoryEvent(type: StoryEventType.submit, story: updated));
    return updated;
  }

  Story approve(String id, {required String user}) {
    final idx = _items.indexWhere((it) => it.id == id);
    if (idx == -1) throw Exception('not found');
    final s = _items[idx];
    final updated = s.copyWith(status: 'approved', updatedBy: user, version: s.version + 1);
    _items[idx] = updated;
    _ctrl.add(StoryEvent(type: StoryEventType.approve, story: updated));
    return updated;
  }

  void delete(String id) {
    _items.removeWhere((it) => it.id == id);
    _ctrl.add(
      StoryEvent(type: StoryEventType.delete, list: List.unmodifiable(_items)),
    );
  }

  void reorder(int fromIndex, int toIndex) {
    if (fromIndex < 0 ||
        toIndex < 0 ||
        fromIndex >= _items.length ||
        toIndex >= _items.length) {
      return;
    }
    final item = _items.removeAt(fromIndex);
    _items.insert(toIndex, item);
    // fix orderNo
    for (var i = 0; i < _items.length; i++) {
      _items[i] = _items[i].copyWith(orderNo: i + 1);
    }
    _ctrl.add(
      StoryEvent(type: StoryEventType.reorder, list: List.unmodifiable(_items)),
    );
  }

  void refresh() {
    // Just emit the current list without generating demo data
    _ctrl.add(
      StoryEvent(type: StoryEventType.list, list: List.unmodifiable(_items)),
    );
  }

  void loadDemoData() {
    // Generate demo data only when explicitly requested
    _items.clear();
    _loadDemoDataInternal();
    _ctrl.add(
      StoryEvent(type: StoryEventType.list, list: List.unmodifiable(_items)),
    );
  }

  Story add(
    String slug, {
    String status = 'pending',
    String script = '',
    String? user,
  }) {
    final id = _rng.v4();
    final orderNo = _items.length + 1;
    final story = Story(
      id: id,
      slug: slug,
      orderNo: orderNo,
      status: status,
      script: script,
      version: 1,
      updatedBy: user,
    );
    _items.add(story);
    _ctrl.add(StoryEvent(type: StoryEventType.upsert, story: story));
    return story;
  }
}
