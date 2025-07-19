import 'package:flutter/material.dart';
import 'package:todo_project/todo/todos_overview/todos_overview_provider.dart';
import 'package:todo_project/todo/todos_overview/todos_overview_view_model.dart';

class TodosOverviewFilterButton extends StatelessWidget {
  const TodosOverviewFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final todosOverviewProvider = TodosOverviewProvider.of(
      context,
    ).todosOverviewViewModel;
    return ValueListenableBuilder(
      valueListenable: todosOverviewProvider,
      builder: (context, state, _) {
        return PopupMenuButton<TodosViewFilter>(
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          initialValue: state.filter,
          onSelected: (filter) {
            todosOverviewProvider.todosOverviewFilterChanged(filter: filter);
          },
          itemBuilder: (context) {
            return [
              PopupMenuItem(value: TodosViewFilter.all, child: Text('All')),
              PopupMenuItem(
                value: TodosViewFilter.activeOnly,
                child: Text('Active only'),
              ),
              PopupMenuItem(
                value: TodosViewFilter.completedOnly,
                child: Text('Completed only'),
              ),
            ];
          },
          icon: const Icon(Icons.filter_list_rounded),
        );
      },
    );
  }
}
