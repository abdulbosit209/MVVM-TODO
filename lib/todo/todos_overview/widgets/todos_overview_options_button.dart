import 'package:flutter/material.dart';
import 'package:todo_project/todo/todos_overview/todos_overview_view_model.dart';

@visibleForTesting
enum TodosOverviewOption { toggleAll, clearCompleted }

class TodosOverviewOptionsButton extends StatelessWidget {
  const TodosOverviewOptionsButton({
    required this.editTodoViewModel,
    super.key,
  });

  final TodosOverviewViewModel editTodoViewModel;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: editTodoViewModel,
      builder: (context, state, _) {
        final hasTodos = state.todos.isNotEmpty;
        final completedTodosAmount =
            state.todos.where((todo) => todo.isCompleted).length;
        return PopupMenuButton<TodosOverviewOption>(
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          onSelected: (options) {
            switch (options) {
              case TodosOverviewOption.toggleAll:
                editTodoViewModel.todosOverviewToggleAllRequested();
              case TodosOverviewOption.clearCompleted:
                editTodoViewModel.todosOverviewClearCompletedRequested();
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
