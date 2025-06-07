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

class StatsViewModel {
  StatsViewModel({
    required TodosRepository todosRepository,
    required NotifyService notifyService,
  }) : _notifyService = notifyService {
    _todoSubscription = todosRepository.getTodos().listen(
      (event) => _statsSubscriptionRequested(event),
      onError: _displayErrorMessage,
    );
  }

  final NotifyService _notifyService;
  final _logger = Logger('$StatsViewModel');
  late final StreamSubscription<List<Todo>> _todoSubscription;
  final ValueNotifier<StatsState> todoOverViewState = ValueNotifier<StatsState>(
    StatsState(),
  );

  void _statsSubscriptionRequested(List<Todo> todos) {
    _logger.info('StatsSubscriptionRequested');
    todoOverViewState.value = todoOverViewState.value.copyWith(
      completedTodos: todos.where((todo) => todo.isCompleted).length,
      activeTodos: todos.where((todo) => !todo.isCompleted).length,
      isLoading: false,
    );
  }

  void _displayErrorMessage(dynamic error) {
    _logger.shout('StatsSubscriptionRequested failure: $error');
    _notifyService.setToastEvent(
      ToastEventError(message: Translate.current.errorGeneric),
    );
    _notifyService.setHapticFeedbackEvent(HapticFeedbackEvent.heavyImpact);
  }

  void dispose() {
    _todoSubscription.cancel();
    todoOverViewState.dispose();
  }
}

final class StatsState extends Equatable {
  const StatsState({
    this.isLoading = true,
    this.completedTodos = 0,
    this.activeTodos = 0,
  });

  final bool isLoading;
  final int completedTodos;
  final int activeTodos;

  @override
  List<Object> get props => [isLoading, completedTodos, activeTodos];

  StatsState copyWith({
    bool? isLoading,
    int? completedTodos,
    int? activeTodos,
  }) {
    return StatsState(
      isLoading: isLoading ?? this.isLoading,
      completedTodos: completedTodos ?? this.completedTodos,
      activeTodos: activeTodos ?? this.activeTodos,
    );
  }
}
