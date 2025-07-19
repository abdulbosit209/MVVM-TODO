import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_project/config/locator_config.dart';
import 'package:todo_project/core/utils/internal_notification/notify_service.dart';
import 'package:todo_project/core/utils/navigation/router_service.dart';
import 'package:todo_project/todo/todo_repository.dart';
import 'package:todo_project/todo/todos_overview/todos_overview_provider.dart';
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
  late final TodosOverviewViewModel todosOverviewViewModel;

  @override
  void initState() {
    super.initState();
    todosOverviewViewModel = TodosOverviewViewModel(
      todosRepository: locator<TodosRepository>(),
      notifyService: locator<NotifyService>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TodosOverviewProvider(
      todosOverviewViewModel: todosOverviewViewModel,
      child: _TodosOverviewView(),
    );
  }

  @override
  void dispose() {
    todosOverviewViewModel.dispose();
    super.dispose();
  }
}

class _TodosOverviewView extends StatefulWidget {
  const _TodosOverviewView();

  @override
  State<_TodosOverviewView> createState() => _TodosOverviewViewState();
}

class _TodosOverviewViewState extends State<_TodosOverviewView> {
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final viewModel = TodosOverviewProvider.of(context).todosOverviewViewModel;

    TodosOverviewState previous = viewModel.value;

    viewModel.addListener(() {
      final current = viewModel.value;

      if (current.lastDeletedTodo != previous.lastDeletedTodo &&
          current.lastDeletedTodo != null) {
        final deleted = current.lastDeletedTodo!;
        final messenger = ScaffoldMessenger.of(context);
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('Deleting: ${deleted.title}'),
              action: SnackBarAction(
                label: 'cancel',
                onPressed: () {
                  messenger.hideCurrentSnackBar();
                  viewModel.todosOverviewUndoDeletionRequested();
                },
              ),
            ),
          );
      }

      previous = current;
    });
  }

  @override
  Widget build(BuildContext context) {
    final todosOverviewProvider = TodosOverviewProvider.of(
      context,
    ).todosOverviewViewModel;

    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
        actions: [
          TodosOverviewFilterButton(),
          TodosOverviewOptionsButton(),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: todosOverviewProvider,
        builder: (context, state, _) {
          return CupertinoScrollbar(
            child: ListView.builder(
              itemCount: state.filteredTodos.length,
              itemBuilder: (_, index) {
                final todo = state.filteredTodos.elementAt(index);
                return TodoListTile(
                  todo: todo,
                  onToggleCompleted: (isCompleted) {
                    todosOverviewProvider.todosOverviewTodoCompletionToggled(
                      todo: todo,
                      isCompleted: isCompleted,
                    );
                  },
                  onDismissed: (_) {
                    todosOverviewProvider.todosOverviewTodoDeleted(todo: todo);
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
}
