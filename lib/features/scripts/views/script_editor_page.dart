// features/scripts/views/script_editor_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:async';
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
  late TextEditingController _slugController;

  StreamSubscription? _storySub;
  bool _dirty = false;
  bool _saving = false;
  bool _submitting = false;
  bool _approving = false;

  bool get canEdit =>
      TokenProvider.isAdmin ||
      TokenProvider.isEditor ||
      TokenProvider.isProducer ||
      (TokenProvider.isReporter &&
          widget.story.updatedBy == TokenProvider.username);

  bool get canApprove =>
      TokenProvider.isEditor ||
      TokenProvider.isProducer ||
      TokenProvider.isAdmin;

  @override
  void initState() {
    super.initState();
    final svc = Get.find<StoryService>();
    ctrl = Get.isRegistered<ScriptController>()
        ? Get.find<ScriptController>()
        : Get.put(ScriptController(service: svc));
    ctrl.load(widget.story);
    _slugController = TextEditingController(text: widget.story.slug);

    final initialDoc = _parseDocument(ctrl.content.value);
    _quillController = QuillController(
      document: initialDoc,
      selection: const TextSelection.collapsed(offset: 0),
    );

    // Track local edits
    _quillController.document.changes.listen((_) {
      if (mounted) {
        setState(() {
          _dirty = true;
        });
      }
    });

    // Listen for remote updates; avoid clobbering local edits
    _storySub = svc.stream.listen((ev) {
      if (ev.story != null && ev.story!.id == widget.story.id) {
        if (_dirty) return;
        ctrl.story.value = ev.story;
        ctrl.content.value = ev.story!.script;
        final newDoc = _parseDocument(ev.story!.script);
        // Update controller without disposing it
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _quillController.document = newDoc;
            _slugController.text = ev.story!.slug;
            _quillController.readOnly = !canEdit;
            setState(() {});
          }
        });
      }
    });

    // Keep slug synced
    _slugController.addListener(() {
      final s = ctrl.story.value;
      if (s != null) {
        ctrl.story.value = s.copyWith(slug: _slugController.text);
      }
    });

    _quillController.readOnly = !canEdit;
  }

  Document _parseDocument(String content) {
    try {
      if (content.isEmpty) {
        return Document();
      }
      // Try to parse as JSON first
      final decoded = jsonDecode(content);
      if (decoded is List) {
        return Document.fromJson(decoded);
      } else if (decoded is Map && decoded.containsKey('ops')) {
        return Document.fromJson(decoded['ops']);
      } else {
        // If it's not a valid Quill format, treat as plain text
        final doc = Document();
        doc.insert(0, content);
        return doc;
      }
    } catch (e) {
      // If parsing fails, treat as plain text
      final doc = Document();
      doc.insert(0, content);
      return doc;
    }
  }

  @override
  void dispose() {
    _storySub?.cancel();
    _slugController.dispose();
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || !_dirty) return;

        final shouldLeave =
            await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Unsaved changes'),
                content: const Text(
                  'You have unsaved changes. Discard and leave?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: const Text('Discard'),
                  ),
                ],
              ),
            ) ??
            false;

        if (shouldLeave && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Script Editor'),
          actions: [
            if (canEdit)
              TextButton(
                onPressed: _saving
                    ? null
                    : () async {
                        setState(() => _saving = true);
                        try {
                          final content = jsonEncode(
                            _quillController.document.toDelta().toJson(),
                          );
                          ctrl.content.value = content;
                          await ctrl.save();
                          _dirty = false;
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Saved')),
                            );
                            Get.back();
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Save failed: $e')),
                            );
                          }
                        } finally {
                          if (mounted) setState(() => _saving = false);
                        }
                      },
                child: const Text('Save'),
              ),
            if (canEdit) const SizedBox(width: 8),
            if (canEdit)
              TextButton(
                onPressed: _submitting
                    ? null
                    : () async {
                        setState(() => _submitting = true);
                        try {
                          final content = jsonEncode(
                            _quillController.document.toDelta().toJson(),
                          );
                          ctrl.content.value = content;
                          await ctrl.submit();
                          _dirty = false;
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Submitted')),
                            );
                            Get.back();
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Submit failed: $e')),
                            );
                          }
                        } finally {
                          if (mounted) setState(() => _submitting = false);
                        }
                      },
                child: const Text('Submit'),
              ),
            if (canEdit) const SizedBox(width: 8),
            if (canApprove)
              TextButton(
                onPressed: _approving
                    ? null
                    : () async {
                        setState(() => _approving = true);
                        try {
                          final content = jsonEncode(
                            _quillController.document.toDelta().toJson(),
                          );
                          ctrl.content.value = content;
                          await ctrl.approve();
                          _dirty = false;
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Approved')),
                            );
                            Get.back();
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Approve failed: $e')),
                            );
                          }
                        } finally {
                          if (mounted) setState(() => _approving = false);
                        }
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
                controller: _slugController,
                readOnly: !canEdit,
                decoration: const InputDecoration(labelText: 'Slug'),
              ),
              const SizedBox(height: 12),
              if (canEdit)
                QuillSimpleToolbar(
                  controller: _quillController,
                  config: const QuillSimpleToolbarConfig(
                    showBoldButton: true,
                    showItalicButton: true,
                    showUnderLineButton: true,
                    showStrikeThrough: true,
                    showInlineCode: true,
                    showColorButton: true,
                    showBackgroundColorButton: true,
                    showClearFormat: true,
                    showAlignmentButtons: true,
                    showHeaderStyle: true,
                    showListNumbers: true,
                    showListBullets: true,
                    showListCheck: true,
                    showCodeBlock: true,
                    showQuote: true,
                    showIndent: true,
                    showLink: true,
                    showUndo: true,
                    showRedo: true,
                  ),
                ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: QuillEditor.basic(
                    controller: _quillController,
                    focusNode: FocusNode(),
                    scrollController: ScrollController(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
