import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_project/config/locator_config.dart';
import 'package:todo_project/core/utils/internal_notification/notify_service.dart';
import 'package:todo_project/core/utils/navigation/router_service.dart';
import 'package:todo_project/todo/todo_repository.dart';
import 'package:todo_project/todo/todos_overview/todos_overview_view_model.dart';
import 'package:todo_project/todo/todos_overview/widgets/todo_list_tile.dart';
import 'package:todo_project/core/utils/navigation/route_data.dart';
import 'package:todo_project/todo/todos_overview/widgets/todos_overview_filter_button.dart';
import 'package:todo_project/todo/todos_overview/widgets/todos_overview_options_button.dart';

class TodosOverviewPage extends StatelessWidget {
  const TodosOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodosOverviewViewModel(
        todosRepository: locator<TodosRepository>(),
        notifyService: locator<NotifyService>(),
      ),
      child: const TodosOverviewView(),
    );
  }
}

class TodosOverviewView extends StatefulWidget {
  const TodosOverviewView({super.key});

  @override
  State<TodosOverviewView> createState() => _TodosOverviewViewState();
}

class _TodosOverviewViewState extends State<TodosOverviewView> {
  @override
  void initState() {
    super.initState();
    final todosOverviewViewModel = context.read<TodosOverviewViewModel>();
    todosOverviewViewModel.addListener(
      () {
        final state = todosOverviewViewModel.value;
        final deletedTodo = state.lastDeletedTodo;
        if (state.lastDeletedTodo != null) {
          final messenger = ScaffoldMessenger.of(context);
          messenger
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text('Deleting: ${deletedTodo!.title}'),
                action: SnackBarAction(
                  label: 'cancel',
                  onPressed: () {
                    messenger.hideCurrentSnackBar();
                    todosOverviewViewModel.todosOverviewUndoDeletionRequested();
                  },
                ),
              ),
            );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TodosOverviewViewModel>().value;
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
        actions: [
          TodosOverviewFilterButton(),
          TodosOverviewOptionsButton(),
        ],
      ),
      body: CupertinoScrollbar(
        child: ListView.builder(
          itemCount: state.filteredTodos.length,
          itemBuilder: (_, index) {
            final todo = state.filteredTodos.elementAt(index);
            return TodoListTile(
              todo: todo,
              onToggleCompleted: (isCompleted) {
                context
                    .read<TodosOverviewViewModel>()
                    .todosOverviewTodoCompletionToggled(
                      todo: todo,
                      isCompleted: isCompleted,
                    );
              },
              onDismissed: (_) {
                context.read<TodosOverviewViewModel>().todosOverviewTodoDeleted(
                  todo: todo,
                );
              },
              onTap: () {
                locator<RouterService>().goTo(
                  Path(name: '/editTodoPage', extra: todo),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
