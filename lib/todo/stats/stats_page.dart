import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_project/config/locator_config.dart';
import 'package:todo_project/core/utils/internal_notification/notify_service.dart';
import 'package:todo_project/todo/stats/stats_view_model.dart';
import 'package:todo_project/todo/todo_repository.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StatsViewModel(
        notifyService: locator<NotifyService>(),
        todosRepository: locator<TodosRepository>(),
      ),
      child: const StatsView(),
    );
  }
}

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final state = context.watch<StatsViewModel>().value;

    return Scaffold(
      appBar: AppBar(title: Text('Stats')),
      body: Column(
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
      ),
    );
  }
}
