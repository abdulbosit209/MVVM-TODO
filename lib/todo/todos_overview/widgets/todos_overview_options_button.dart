import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_project/todo/todos_overview/todos_overview_view_model.dart';

@visibleForTesting
enum TodosOverviewOption { toggleAll, clearCompleted }

class TodosOverviewOptionsButton extends StatelessWidget {
  const TodosOverviewOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TodosOverviewViewModel>().value;

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
            context.read<TodosOverviewViewModel>().todosOverviewToggleAllRequested();
          case TodosOverviewOption.clearCompleted:
            context.read<TodosOverviewViewModel>().todosOverviewClearCompletedRequested();
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
  }
}
