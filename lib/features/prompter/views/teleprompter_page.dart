// features/prompter/views/teleprompter_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nrcs/core/models/story.dart';
import 'package:nrcs/core/services/story_service.dart';
import 'package:nrcs/features/prompter/controllers/prompter_controller.dart';

class TeleprompterPage extends StatefulWidget {
  final Story story;
  const TeleprompterPage({super.key, required this.story});

  @override
  State<TeleprompterPage> createState() => _TeleprompterPageState();
}

class _TeleprompterPageState extends State<TeleprompterPage> {
  late PrompterController ctrl;
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final svc = Get.find<StoryService>();
    ctrl = Get.put(PrompterController(service: svc), tag: widget.story.id);
    ctrl.load(widget.story);

    ever(ctrl.isPlaying, (playing) {
      if (playing) {
        _startScrolling();
      } else {
        _stopScrolling();
      }
    });
    
    // Listen for external updates (e.g. script changes)
    svc.stream.listen((ev) {
        if (ev.story != null && ev.story!.id == widget.story.id) {
            // Update content if script changed
            if (ctrl.story.value?.script != ev.story!.script) {
                ctrl.story.value = ev.story;
            }
        }
    });
  }

  void _startScrolling() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!_scrollController.hasClients) return;
      
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      
      if (currentScroll >= maxScroll) {
        ctrl.isPlaying.value = false;
        return;
      }

      // Calculate pixels to scroll based on speed
      // Speed 1.0 = 2 pixels per tick roughly
      final pixels = ctrl.scrollSpeed.value * 2.0;
      
      _scrollController.jumpTo(currentScroll + pixels);
    });
  }

  void _stopScrolling() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Script Area
          GestureDetector(
            onTap: ctrl.togglePlay,
            child: Obx(() {
                 final s = ctrl.story.value;
                 if (s == null) return const Center(child: CircularProgressIndicator());
                 
                 return SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 200),
                  child: Text(
                    s.script,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ctrl.fontSize.value,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                );
            }),
          ),
          
          // Controls Overlay (visible when paused or hovered ideally, but keeping simple)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black54,
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                  child: Row(
                    children: [
                        IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Get.back(),
                        ),
                        const SizedBox(width: 16),
                         Obx(() => IconButton(
                            icon: Icon(
                                ctrl.isPlaying.value ? Icons.pause : Icons.play_arrow, 
                                color: Colors.green,
                                size: 32,
                            ),
                            onPressed: ctrl.togglePlay,
                        )),
                        const SizedBox(width: 16),
                        const Text('Speed:', style: TextStyle(color: Colors.white)),
                        Expanded(
                            child: Obx(() => Slider(
                                value: ctrl.scrollSpeed.value,
                                min: 0.5,
                                max: 5.0,
                                onChanged: ctrl.updateSpeed,
                                activeColor: Colors.green,
                            )),
                        ),
                        const SizedBox(width: 16),
                        const Text('Size:', style: TextStyle(color: Colors.white)),
                        Expanded(
                            child: Obx(() => Slider(
                                value: ctrl.fontSize.value,
                                min: 24.0,
                                max: 96.0,
                                onChanged: (v) => ctrl.fontSize.value = v,
                                activeColor: Colors.blue,
                            )),
                        ),
                    ],
                  ),
              ),
            ),
          ),
          
          // Mirror Guide (flipped text/guidance line could be added)
          Center(
              child: Container(
                  height: 2,
                  width: double.infinity,
                  color: Colors.red.withValues(alpha:0.3),
              ),
          ),
        ],
      ),
    );
  }
}
