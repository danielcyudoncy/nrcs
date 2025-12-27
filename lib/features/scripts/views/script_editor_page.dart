// features/scripts/views/script_editor_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:nrcs/features/scripts/controllers/script_controller.dart';
import 'package:nrcs/core/services/story_service.dart';
import 'package:nrcs/core/models/story.dart';
import 'package:nrcs/core/auth/token_provider.dart';

class ScriptEditorPage extends StatefulWidget {
  final Story story;
  const ScriptEditorPage({super.key, required this.story});

  @override
  State<ScriptEditorPage> createState() => _ScriptEditorPageState();
}

class _ScriptEditorPageState extends State<ScriptEditorPage> {
  late ScriptController ctrl;
  late QuillController _quillController;
  late FocusNode _focusNode;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final svc = Get.find<StoryService>();
    ctrl = Get.put(ScriptController(service: svc));
    ctrl.load(widget.story);
    _quillController = QuillController.basic();
    _focusNode = FocusNode();
    _scrollController = ScrollController();
    _quillController.addListener(() => setState(() {}));
    try {
      final delta = jsonDecode(ctrl.content.value) as List;
      _quillController.document = Document.fromJson(delta);
    } catch (e) {
      _quillController.document.insert(0, ctrl.content.value);
    }
    // listen for remote updates to this story
    svc.stream.listen((ev) {
      if (ev.story != null && ev.story!.id == widget.story.id) {
        // update local
        ctrl.story.value = ev.story;
        ctrl.content.value = ev.story!.script;
        try {
          final delta = jsonDecode(ev.story!.script) as List;
          _quillController.document = Document.fromJson(delta);
        } catch (e) {
          _quillController.document = Document();
          _quillController.document.insert(0, ev.story!.script);
        }
      }
    });
  }

  @override
  void dispose() {
    _quillController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Script Editor'),
        actions: [
          TextButton(
            onPressed: () {
              ctrl.content.value = jsonEncode(
                _quillController.document.toDelta().toJson(),
              );
              ctrl.save();
              Get.back();
            },
            child: const Text('Save'),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              ctrl.content.value = jsonEncode(
                _quillController.document.toDelta().toJson(),
              );
              ctrl.submit();
              Get.back();
            },
            child: const Text('Submit'),
          ),
          const SizedBox(width: 8),
          if (TokenProvider.roles.contains('approver'))
            TextButton(
              onPressed: () {
                ctrl.content.value = jsonEncode(
                  _quillController.document.toDelta().toJson(),
                );
                ctrl.approve();
                Get.back();
              },
              child: const Text('Approve'),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(text: widget.story.slug),
              decoration: const InputDecoration(labelText: 'Slug'),
              onChanged: (v) =>
                  ctrl.story.value = ctrl.story.value!.copyWith(slug: v),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () =>
                        _quillController.formatSelection(Attribute.bold),
                    icon: Icon(Icons.format_bold),
                    color:
                        _quillController
                            .getSelectionStyle()
                            .attributes
                            .containsKey(Attribute.bold)
                        ? Colors.blue
                        : null,
                  ),
                  IconButton(
                    onPressed: () =>
                        _quillController.formatSelection(Attribute.italic),
                    icon: Icon(Icons.format_italic),
                    color:
                        _quillController
                            .getSelectionStyle()
                            .attributes
                            .containsKey(Attribute.italic)
                        ? Colors.blue
                        : null,
                  ),
                  IconButton(
                    onPressed: () =>
                        _quillController.formatSelection(Attribute.underline),
                    icon: Icon(Icons.format_underline),
                    color:
                        _quillController
                            .getSelectionStyle()
                            .attributes
                            .containsKey(Attribute.underline)
                        ? Colors.blue
                        : null,
                  ),
                  IconButton(
                    onPressed: () => _quillController.formatSelection(
                      Attribute.strikeThrough,
                    ),
                    icon: Icon(Icons.strikethrough_s),
                    color:
                        _quillController
                            .getSelectionStyle()
                            .attributes
                            .containsKey(Attribute.strikeThrough)
                        ? Colors.blue
                        : null,
                  ),
                  IconButton(
                    onPressed: () =>
                        _quillController.formatSelection(Attribute.ol),
                    icon: Icon(Icons.list),
                    color:
                        _quillController
                            .getSelectionStyle()
                            .attributes
                            .containsKey(Attribute.ol)
                        ? Colors.blue
                        : null,
                  ),
                  IconButton(
                    onPressed: () =>
                        _quillController.formatSelection(Attribute.ul),
                    icon: Icon(Icons.list_alt),
                    color:
                        _quillController
                            .getSelectionStyle()
                            .attributes
                            .containsKey(Attribute.ul)
                        ? Colors.blue
                        : null,
                  ),
                  IconButton(
                    onPressed: () =>
                        _quillController.formatSelection(Attribute.blockQuote),
                    icon: Icon(Icons.format_quote),
                    color:
                        _quillController
                            .getSelectionStyle()
                            .attributes
                            .containsKey(Attribute.blockQuote)
                        ? Colors.blue
                        : null,
                  ),
                  IconButton(
                    onPressed: () =>
                        _quillController.formatSelection(Attribute.codeBlock),
                    icon: Icon(Icons.code),
                    color:
                        _quillController
                            .getSelectionStyle()
                            .attributes
                            .containsKey(Attribute.codeBlock)
                        ? Colors.blue
                        : null,
                  ),
                  IconButton(
                    onPressed: () =>
                        _quillController.formatSelection(Attribute.link),
                    icon: Icon(Icons.link),
                    color:
                        _quillController
                            .getSelectionStyle()
                            .attributes
                            .containsKey(Attribute.link)
                        ? Colors.blue
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: QuillEditor(
                controller: _quillController,
                focusNode: _focusNode,
                scrollController: _scrollController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
