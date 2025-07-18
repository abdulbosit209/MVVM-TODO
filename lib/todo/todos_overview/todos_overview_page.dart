import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_project/config/locator_config.dart';
import 'package:todo_project/core/utils/internal_notification/notify_service.dart';
import 'package:todo_project/core/utils/navigation/router_service.dart';
import 'package:todo_project/todo/todo_repository.dart';
import 'package:todo_project/todo/todos_overview/todos_overview_view_model.dart';
import 'package:todo_project/todo/todos_overview/widgets/todo_list_tile.dart';
import 'package:todo_project/core/utils/navigation/route_data.dart';
import 'package:todo_project/todo/todos_overview/widgets/todos_overview_filter_button.dart';
import 'package:todo_project/todo/todos_overview/widgets/todos_overview_options_button.dart';

class TodosOverviewPage extends StatefulWidget {
  const TodosOverviewPage({super.key});

  @override
  State<TodosOverviewPage> createState() => _TodosOverviewPageState();
}

class _TodosOverviewPageState extends State<TodosOverviewPage> {
  void registerTodosOverviewModel() {
    locator.pushNewScope(
      scopeName: 'todosOverViewModel',
      init: (di) {
        di.registerSingleton<TodosOverviewViewModel>(
          TodosOverviewViewModel(
            todosRepository: locator<TodosRepository>(),
            notifyService: locator<NotifyService>(),
          ),
          dispose: (todosOverviewViewModel) => todosOverviewViewModel.dispose(),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    registerTodosOverviewModel();

    locator<TodosOverviewViewModel>().addListener(
      () {
        final state = locator<TodosOverviewViewModel>().value;
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
                    locator<TodosOverviewViewModel>()
                        .todosOverviewUndoDeletionRequested();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
        actions: [
          TodosOverviewFilterButton(),
          TodosOverviewOptionsButton(),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: locator<TodosOverviewViewModel>(),
        builder: (context, state, _) {
          return CupertinoScrollbar(
            child: ListView.builder(
              itemCount: state.filteredTodos.length,
              itemBuilder: (_, index) {
                final todo = state.filteredTodos.elementAt(index);
                return TodoListTile(
                  todo: todo,
                  onToggleCompleted: (isCompleted) {
                    locator<TodosOverviewViewModel>()
                        .todosOverviewTodoCompletionToggled(
                          todo: todo,
                          isCompleted: isCompleted,
                        );
                  },
                  onDismissed: (_) {
                    locator<TodosOverviewViewModel>().todosOverviewTodoDeleted(
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
          );
        },
      ),
    );
  }
  @override
  void dispose() {
    locator.popScope();
    super.dispose();
  }
}
