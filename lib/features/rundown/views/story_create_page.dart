// features/rundown/views/story_create_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:nrcs/core/services/story_service.dart';
import 'package:nrcs/core/utils/themes/app_theme.dart';

class StoryCreatePage extends StatefulWidget {
  const StoryCreatePage({super.key});

  @override
  State<StoryCreatePage> createState() => _StoryCreatePageState();
}

class _StoryCreatePageState extends State<StoryCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _slugController = TextEditingController();
  late quill.QuillController _quillController;
  String _status = 'pending';

  final List<String> _statusOptions = ['pending', 'draft', 'ready'];

  @override
  void initState() {
    super.initState();
    _quillController = quill.QuillController.basic();
  }

  @override
  void dispose() {
    _slugController.dispose();
    _quillController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final svc = Get.find<StoryService>();
      svc.add(
        _slugController.text.trim(),
        status: _status,
        script: jsonEncode(_quillController.document.toDelta().toJson()),
      );
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(
          'Create New Story',
          style: theme.appBarTheme.titleTextStyle,
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(
              'Create',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _slugController,
                decoration: const InputDecoration(
                  labelText: 'Story Slug',
                  hintText: 'Enter a descriptive title for the story',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a story slug';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _status,
                dropdownColor: theme.cardTheme.color,
                decoration: const InputDecoration(labelText: 'Status'),
                items: _statusOptions.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Quill Toolbar
              quill.QuillSimpleToolbar(
                controller: _quillController,
                config: const quill.QuillSimpleToolbarConfig(
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
              const SizedBox(height: 16),
              // Quill Editor
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: appColors?.accent1 ??
                          theme.dividerTheme.color ??
                          Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: quill.QuillEditor.basic(
                    controller: _quillController,
                    config: const quill.QuillEditorConfig(
                      checkBoxReadOnly: false,
                    ),
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
