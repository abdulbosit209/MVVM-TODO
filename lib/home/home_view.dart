import 'package:flutter/material.dart';
import 'package:todo_project/config/locator_config.dart';
import 'package:todo_project/core/utils/navigation/router_service.dart';
import 'package:todo_project/core/utils/navigation/route_data.dart';
import 'package:todo_project/home/home_view_model.dart';
import 'package:todo_project/todo/stats/stats_page.dart';
import 'package:todo_project/todo/todos_overview/todos_overview_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    registerHomeViewModel();
  }

  void registerHomeViewModel() {
    locator.pushNewScope(
      scopeName: 'homeViewModel',
      init: (di) {
        di.registerSingleton<HomeViewModel>(
          HomeViewModel(),
          dispose: (homeViewModel) => homeViewModel.dispose(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: locator<HomeViewModel>(),
        builder: (context, state, _) {
          return IndexedStack(
            index: state.index,
            children: const [TodosOverviewPage(), StatsPage()],
          );
        },
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
      bottomNavigationBar: _HomeBottomNavBar(),
    );
  }

  @override
  void dispose() {
    locator.popScope();
    super.dispose();
  }
}

class _HomeBottomNavBar extends StatelessWidget {
  const _HomeBottomNavBar();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: locator<HomeViewModel>(),
      builder: (context, state, _) {
        return BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _HomeTabButton(
                onPressed: () => locator<HomeViewModel>().setTab(HomeTab.todos),
                groupValue: state,
                value: HomeTab.todos,
                icon: const Icon(Icons.list_rounded),
              ),
              _HomeTabButton(
                onPressed: () => locator<HomeViewModel>().setTab(HomeTab.stats),
                groupValue: state,
                value: HomeTab.stats,
                icon: const Icon(Icons.show_chart_rounded),
              ),
            ],
          ),
        );
      },
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
