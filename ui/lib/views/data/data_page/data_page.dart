import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/viewmodels/translations_view_model.dart';
import 'package:ui/views/data/data_page/widgets/add_translation.dart';
import 'package:ui/views/utils/error.dart';
import 'package:ui/views/utils/loading.dart';

class DataPage extends ConsumerWidget {
  const DataPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTranslations = ref.watch(translationsViewModelProvider);

    return asyncTranslations.when(
      data: (translations) => _ContentWidget(),
      error: (error, _) => errorWidget(error.toString()),
      loading: () => loadingWidget(),
    );
  }
}

class _ContentWidget extends ConsumerWidget {
  const _ContentWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translations =
        ref.read(translationsViewModelProvider).asData?.value ?? [];

    final columns = const [
      DataColumn(label: Text("Indonesian")),
      DataColumn(label: Text("English")),
      DataColumn(label: Text("German")),
    ];

    final rows =
        translations
            .map(
              (x) => DataRow(
                cells: [
                  DataCell(Text(x.id)),
                  DataCell(Text(x.en)),
                  DataCell(Text(x.de)),
                ],
              ),
            )
            .toList();

    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              AddTranslationWidget(),
              DataTable(columns: columns, rows: rows),
            ],
          ),
        ),
      ),
    );
  }
}
