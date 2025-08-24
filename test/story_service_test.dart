// test/story_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:nrcs/core/services/story_service.dart';

void main(){
  test('story service save/submit/approve/reorder', (){
    final svc = StoryService(enableWsDemo: false);
    final initial = svc.list();
    expect(initial.length, greaterThanOrEqualTo(1));

    final s = initial.first;
    final saved = svc.save(s.copyWith(slug: 'updated-slug', status: s.status), user: 'tester');
    expect(saved.slug, 'updated-slug');
    expect(saved.updatedBy, 'tester');

    final submitted = svc.submit(s.id, user: 'tester');
    expect(submitted.status, 'submitted');

    final approved = svc.approve(s.id, user: 'approver');
    expect(approved.status, 'approved');

    // reorder: move first to last
    svc.reorder(0, svc.list().length - 1);
    final after = svc.list();
    expect(after.last.id, saved.id);
  });
}
