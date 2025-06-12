import 'package:flutter/material.dart';
import 'package:todo_project/config/locator_config.dart';
import 'package:todo_project/core/utils/internal_notification/notify_service.dart';
import 'package:todo_project/todo/stats/stats_view_model.dart';
import 'package:todo_project/todo/todo_repository.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late final StatsViewModel _statsViewModel = StatsViewModel(
    notifyService: locator<NotifyService>(),
    todosRepository: locator<TodosRepository>(),
  );

  @override
  void dispose() {
    _statsViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatsView(statsViewModel: _statsViewModel);
  }
}

class StatsView extends StatelessWidget {
  const StatsView({required this.statsViewModel, super.key});

  final StatsViewModel statsViewModel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text('Stats')),
      body: ValueListenableBuilder(
        valueListenable: statsViewModel,
        builder: (context, value, _) {
          return Column(
            children: [
              ListTile(
                key: const Key('statsView_completedTodos_listTile'),
                leading: const Icon(Icons.check_rounded),
                title: Text('Completed Todo Count'),
                trailing: Text(
                  '${value.completedTodos}',
                  style: textTheme.headlineSmall,
                ),
              ),
              ListTile(
                key: const Key('statsView_activeTodos_listTile'),
                leading: const Icon(Icons.radio_button_unchecked_rounded),
                title: Text('Active Todo Count'),
                trailing: Text(
                  '${value.activeTodos}',
                  style: textTheme.headlineSmall,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
