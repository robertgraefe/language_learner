import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ui/models/translation.dart';
import 'package:ui/viewmodels/translations_view_model.dart';

class AddTranslationWidget extends HookConsumerWidget {
  const AddTranslationWidget({super.key});

  @override
  Widget build(Object context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final indonesiaController = useTextEditingController();
    final englishController = useTextEditingController();
    final germanController = useTextEditingController();

    void fileSelect() async {
      final filePickerResult = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      final path = filePickerResult?.files.single.path;

      if (path == null) return;

      final file = File(path);

      ref.read(translationsViewModelProvider.notifier).putFile(file);
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: indonesiaController,
                decoration: InputDecoration(labelText: "Indonesian"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a word in Indonesian';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: englishController,
                decoration: InputDecoration(labelText: "English"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a word in English';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: germanController,
                decoration: InputDecoration(labelText: "German"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a word in German';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final id = indonesiaController.text;
                    final en = englishController.text;
                    final de = germanController.text;
                    final translation = Translation(id, en, de);
                    final translationsViewModel = ref.read(
                      translationsViewModelProvider.notifier,
                    );
                    translationsViewModel.put([translation]);
                  }
                },
                child: const Text("Add Translation"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: fileSelect, child: Text("Upload File")),
            ],
          ),
        ),
      ),
    );
  }
}
