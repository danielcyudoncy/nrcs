// features/rundown/views/story_create_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:nrcs/core/services/story_service.dart';
import 'package:nrcs/core/theme/app_theme.dart';

class StoryCreatePage extends StatefulWidget {
  const StoryCreatePage({super.key});

  @override
  State<StoryCreatePage> createState() => _StoryCreatePageState();
}

class _StoryCreatePageState extends State<StoryCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _slugController = TextEditingController();
  late QuillController _quillController;
  late FocusNode _focusNode;
  late ScrollController _scrollController;
  String _status = 'pending';

  final List<String> _statusOptions = ['pending', 'draft', 'ready'];

  @override
  void initState() {
    super.initState();
    _quillController = QuillController.basic();
    _focusNode = FocusNode();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _slugController.dispose();
    _quillController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final svc = Get.find<StoryService>();
      svc.add(
        _slugController.text.trim(),
        status: _status,
        script: _quillController.document.toPlainText(),
      );
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: Text(
          'Create New Story',
          style: AppTheme.headingSmall?.copyWith(color: AppColors.glassWhite),
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(
              'Create',
              style: AppTheme.button?.copyWith(color: AppColors.glassWhite),
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
                dropdownColor: AppColors.backgroundCard,
                decoration: const InputDecoration(labelText: 'Status'),
                items: _statusOptions.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(color: AppColors.glassWhite),
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
      ),
    );
  }
}
