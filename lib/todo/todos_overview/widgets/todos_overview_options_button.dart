import 'package:flutter/material.dart';
import 'package:todo_project/todo/todos_overview/todos_overview_provider.dart';

@visibleForTesting
enum TodosOverviewOption { toggleAll, clearCompleted }

class TodosOverviewOptionsButton extends StatelessWidget {
  const TodosOverviewOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final todosOverviewProvider = TodosOverviewProvider.of(
      context,
    ).todosOverviewViewModel;
    return ValueListenableBuilder(
      valueListenable: todosOverviewProvider,
      builder: (context, state, _) {
        final hasTodos = state.todos.isNotEmpty;
        final completedTodosAmount = state.todos
            .where((todo) => todo.isCompleted)
            .length;

        return PopupMenuButton<TodosOverviewOption>(
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          onSelected: (options) {
            switch (options) {
              case TodosOverviewOption.toggleAll:
                todosOverviewProvider.todosOverviewToggleAllRequested();
              case TodosOverviewOption.clearCompleted:
                todosOverviewProvider.todosOverviewClearCompletedRequested();
            }
          },
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                value: TodosOverviewOption.toggleAll,
                enabled: hasTodos,
                child: Text(
                  completedTodosAmount == state.todos.length
                      ? 'Mark all incomplete'
                      : 'Mark all complete',
                ),
              ),
              PopupMenuItem(
                value: TodosOverviewOption.clearCompleted,
                enabled: hasTodos && completedTodosAmount > 0,
                child: Text('Clear completed'),
              ),
            ];
          },
          icon: const Icon(Icons.more_vert_rounded),
        );
      },
    );
  }
}
