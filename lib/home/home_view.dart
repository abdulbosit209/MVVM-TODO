import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_project/config/locator_config.dart';
import 'package:todo_project/core/utils/navigation/router_service.dart';
import 'package:todo_project/core/utils/navigation/route_data.dart';
import 'package:todo_project/home/home_view_model.dart';
import 'package:todo_project/todo/stats/stats_page.dart';
import 'package:todo_project/todo/todos_overview/todos_overview_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeViewModel>().value;
    return Scaffold(
      body: IndexedStack(
        index: state.index,
        children: const [TodosOverviewPage(), StatsPage()],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        key: const Key('homeView_addTodo_floatingActionButton'),
        onPressed: () {
          locator<RouterService>().goTo(Path(name: '/editTodoPage'));
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _HomeTabButton(
              onPressed: () => context.read<HomeViewModel>().setTab(HomeTab.todos),
              groupValue: state,
              value: HomeTab.todos,
              icon: const Icon(Icons.list_rounded),
            ),
            _HomeTabButton(
              onPressed: () => context.read<HomeViewModel>().setTab(HomeTab.stats),
              groupValue: state,
              value: HomeTab.stats,
              icon: const Icon(Icons.show_chart_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTabButton extends StatelessWidget {
  const _HomeTabButton({
    required this.groupValue,
    required this.value,
    required this.icon,
    this.onPressed,
  });

  final HomeTab groupValue;
  final HomeTab value;
  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      iconSize: 32,
      color: groupValue != value
          ? null
          : Theme.of(context).colorScheme.secondary,
      icon: icon,
    );
  }
}
