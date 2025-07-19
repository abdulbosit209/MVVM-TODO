import 'package:flutter/material.dart';
import 'package:todo_project/todo/edit_todo/edit_todo_view_model.dart';

class EditTodoProvider extends InheritedWidget {
  const EditTodoProvider({
    required this.editTodoViewModel,
    required super.child,
    super.key,
  });

  final EditTodoViewModel editTodoViewModel;

  static EditTodoProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<EditTodoProvider>();
  }

  static EditTodoProvider of(BuildContext context) {
    final EditTodoProvider? result = maybeOf(context);
    assert(result != null, 'No EditTodoProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(EditTodoProvider oldWidget) =>
      editTodoViewModel != oldWidget.editTodoViewModel;
}
