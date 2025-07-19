
import 'package:flutter/material.dart';
import 'package:todo_project/todo/todos_overview/todos_overview_view_model.dart';

class TodosOverviewProvider extends InheritedWidget {
  const TodosOverviewProvider({
    required this.todosOverviewViewModel,
    required super.child,
    super.key,
  });

  final TodosOverviewViewModel todosOverviewViewModel;

  static TodosOverviewProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TodosOverviewProvider>();
  }

  static TodosOverviewProvider of(BuildContext context) {
    final TodosOverviewProvider? result = maybeOf(context);
    assert(result != null, 'No TodosOverviewProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(TodosOverviewProvider oldWidget) =>
      todosOverviewViewModel != oldWidget.todosOverviewViewModel;
}
