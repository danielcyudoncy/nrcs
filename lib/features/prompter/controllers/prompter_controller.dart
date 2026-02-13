import 'package:get/get.dart';
import '../../../core/models/story.dart';
import '../../../core/services/story_service.dart';

class PrompterController extends GetxController {
  final StoryService service;
  final story = Rxn<Story>();
  final scrollSpeed = 1.0.obs;
  final fontSize = 48.0.obs;
  final isPlaying = false.obs;

  PrompterController({required this.service});

  void load(Story s) {
    story.value = s;
    scrollSpeed.value = s.prompterSpeed;
  }

  void togglePlay() {
    isPlaying.value = !isPlaying.value;
  }

  void updateSpeed(double speed) {
    scrollSpeed.value = speed;
    final s = story.value;
    if (s != null) {
        // Optimistic local update
        story.value = s.copyWith(prompterSpeed: speed);
        // Persist
        // TODO: ideally we have a dedicated patch endpoint or similar, 
        // but save() with the same script works for now.
        service.save(story.value!, user: 'prompter');
    }
  }
}
