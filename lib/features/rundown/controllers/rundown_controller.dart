// features/rundown/controllers/rundown_controller.dart
import 'package:get/get.dart';

class RundownController extends GetxController {
  final stories = <Map<String, dynamic>>[].obs;

  void loadSample() {
    stories.assignAll(List.generate(8, (i) => {
      'id': 'sid-$i',
      'slug': 'Story ${i + 1}',
      'orderNo': i + 1,
      'status': 'draft'
    }));
  }
}
