import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:todo_project/core/models/todo.dart';
import 'package:todo_project/core/utils/internal_notification/haptic_feedback/haptic_feedback_listener.dart';
import 'package:todo_project/core/utils/internal_notification/notify_service.dart';
import 'package:todo_project/core/utils/internal_notification/toast/toast_event.dart';
import 'package:todo_project/core/utils/l10n/translate.dart';
import 'package:todo_project/todo/todo_repository.dart';

class TodosOverviewViewModel extends ValueNotifier<TodosOverviewState> {
  TodosOverviewViewModel({
    required TodosRepository todosRepository,
    required NotifyService notifyService,
  }) : _notifyService = notifyService,
       _todosRepository = todosRepository,
       super(const TodosOverviewState()) {
    _todoSubscription = todosRepository.getTodos().listen(
      _todosOverviewSubscriptionRequested,
      onError: _displayErrorMessage,
    );
  }

  final TodosRepository _todosRepository;
  final NotifyService _notifyService;
  late final StreamSubscription<List<Todo>> _todoSubscription;
  final _logger = Logger('$TodosOverviewViewModel');

  void _todosOverviewSubscriptionRequested(List<Todo> todos) {
    _logger.info('TodosOverviewSubscriptionRequested');
    value = value.copyWith(
      todos: () => todos,
      isLoading: () => false,
    );
  }

  void _displayErrorMessage(dynamic error) {
    _logger.shout('TodosOverviewSubscriptionRequested failure: $error');
    _notifyService.setToastEvent(
      ToastEventError(message: Translate.current.errorGeneric),
    );
    _notifyService.setHapticFeedbackEvent(HapticFeedbackEvent.heavyImpact);
  }

  Future<void> todosOverviewTodoCompletionToggled({
    required Todo todo,
    required bool isCompleted,
  }) async {
    _logger.info('todosOverviewTodoCompletionToggled');
    final newTodo = todo.copyWith(isCompleted: isCompleted);
    await _todosRepository.saveTodo(newTodo);
  }

  Future<void> todosOverviewTodoDeleted({required Todo todo}) async {
    _logger.info('todosOverviewTodoDeleted');
    value = value.copyWith(lastDeletedTodo: () => todo);
    await _todosRepository.deleteTodo(todo.id);
  }

  Future<void> todosOverviewUndoDeletionRequested() async {
    assert(
      value.lastDeletedTodo != null,
      'Last deleted todo can not be null.',
    );
    _logger.info('todosOverviewUndoDeletionRequested');
    final todo = value.lastDeletedTodo!;
    value = value.copyWith(lastDeletedTodo: () => null);
    await _todosRepository.saveTodo(todo);
  }

  void todosOverviewFilterChanged({required TodosViewFilter filter}) {
    _logger.info('todosOverviewFilterChanged');
    value = value.copyWith(filter: () => filter);
  }

  Future<void> todosOverviewToggleAllRequested() async {
    _logger.info('todosOverviewToggleAllRequested');
    final areAllCompleted = value.todos.every(
      (todo) => todo.isCompleted,
    );
    await _todosRepository.completeAll(isCompleted: !areAllCompleted);
  }

  Future<void> todosOverviewClearCompletedRequested() async {
    _logger.info('todosOverviewClearCompletedRequested');
    await _todosRepository.clearCompleted();
  }

  @override
  void dispose() {
    _logger.info('disposed');
    _todoSubscription.cancel();
    super.dispose();
  }
}

enum TodosViewFilter { all, activeOnly, completedOnly }

extension TodosViewFilterX on TodosViewFilter {
  bool apply(Todo todo) {
    switch (this) {
      case TodosViewFilter.all:
        return true;
      case TodosViewFilter.activeOnly:
        return !todo.isCompleted;
      case TodosViewFilter.completedOnly:
        return todo.isCompleted;
    }
  }

  Iterable<Todo> applyAll(Iterable<Todo> todos) {
    return todos.where(apply);
  }
}

final class TodosOverviewState extends Equatable {
  const TodosOverviewState({
    this.isLoading = true,
    this.todos = const [],
    this.filter = TodosViewFilter.all,
    this.lastDeletedTodo,
  });

  final bool isLoading;
  final List<Todo> todos;
  final TodosViewFilter filter;
  final Todo? lastDeletedTodo;

  Iterable<Todo> get filteredTodos => filter.applyAll(todos);

  TodosOverviewState copyWith({
    bool Function()? isLoading,
    List<Todo> Function()? todos,
    TodosViewFilter Function()? filter,
    Todo? Function()? lastDeletedTodo,
  }) {
    return TodosOverviewState(
      isLoading: isLoading != null ? isLoading() : this.isLoading,
      todos: todos != null ? todos() : this.todos,
      filter: filter != null ? filter() : this.filter,
      lastDeletedTodo: lastDeletedTodo != null
          ? lastDeletedTodo()
          : this.lastDeletedTodo,
    );
  }

  @override
  List<Object?> get props => [isLoading, todos, filter, lastDeletedTodo];
}
