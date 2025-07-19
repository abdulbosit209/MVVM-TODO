import 'package:flutter/material.dart';
import 'package:todo_project/config/locator_config.dart';
import 'package:todo_project/core/utils/internal_notification/notify_service.dart';
import 'package:todo_project/todo/stats/stats_provider.dart';
import 'package:todo_project/todo/stats/stats_view_model.dart';
import 'package:todo_project/todo/todo_repository.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late final StatsViewModel statsViewModel;

  @override
  void initState() {
    super.initState();
    statsViewModel = StatsViewModel(
      todosRepository: locator<TodosRepository>(),
      notifyService: locator<NotifyService>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StatsProvider(
      statsViewModel: statsViewModel,
      child: _StatsView(),
    );
  }

  @override
  void dispose() {
    statsViewModel.dispose();
    super.dispose();
  }
}

class _StatsView extends StatelessWidget {
  const _StatsView();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final statsProvider = StatsProvider.of(context).statsViewModel;
    return Scaffold(
      appBar: AppBar(title: Text('Stats')),
      body: ValueListenableBuilder(
        valueListenable: statsProvider,
        builder: (context, state, _) {
          return Column(
            children: [
              ListTile(
                key: const Key('statsView_completedTodos_listTile'),
                leading: const Icon(Icons.check_rounded),
                title: Text('Completed Todo Count'),
                trailing: Text(
                  '${state.completedTodos}',
                  style: textTheme.headlineSmall,
                ),
              ),
              ListTile(
                key: const Key('statsView_activeTodos_listTile'),
                leading: const Icon(Icons.radio_button_unchecked_rounded),
                title: Text('Active Todo Count'),
                trailing: Text(
                  '${state.activeTodos}',
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
