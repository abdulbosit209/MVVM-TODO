import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:todo_project/config/locator_config.dart';
import 'package:todo_project/core/models/todo.dart';
import 'package:todo_project/core/utils/internal_notification/haptic_feedback/haptic_feedback_listener.dart';
import 'package:todo_project/core/utils/internal_notification/notify_service.dart';
import 'package:todo_project/core/utils/internal_notification/toast/toast_event.dart';
import 'package:todo_project/core/utils/l10n/translate.dart';
import 'package:todo_project/core/utils/navigation/router_service.dart';
import 'package:todo_project/todo/todo_repository.dart';

class EditTodoViewModel {
  EditTodoViewModel({
    required TodosRepository todosRepository,
    required Todo? initialTodo,
    required NotifyService notifyService,
  }) : _todosRepository = todosRepository,
       _notifyService = notifyService {
    loginState = ValueNotifier(
      EditTodoState(initialTodo: initialTodo, isLoading: false),
    );
  }

  late final ValueNotifier<EditTodoState> loginState;
  final _logger = Logger('$EditTodoViewModel');

  final TodosRepository _todosRepository;
  final NotifyService _notifyService;

  void onTitleChanged({required String title}) {
    _logger.info('onTitleChanged: $title');
    loginState.value = loginState.value.copyWith(title: title);
  }

  void onDescriptionChanged({required String description}) {
    _logger.info('onDescriptionChanged: $description');
    loginState.value = loginState.value.copyWith(description: description);
  }

  Future<void> onSubmitted() async {
    _logger.info('Submitting');
    final todo = (loginState.value.initialTodo ?? Todo(title: '')).copyWith(
      title: loginState.value.title,
      description: loginState.value.description,
    );

    try {
      await _todosRepository.saveTodo(todo);
      _logger.finest('onSubmitted $todo');
      return locator<RouterService>().back();
    } catch (e) {
      _logger.shout('Exception: $e');
      _notifyService.setToastEvent(
        ToastEventError(message: Translate.current.errorGeneric),
      );
      _notifyService.setHapticFeedbackEvent(HapticFeedbackEvent.heavyImpact);
    }
  }

  void dispose() {
    _logger.info('Disposed');
    loginState.dispose();
  }
}

final class EditTodoState extends Equatable {
  const EditTodoState({
    this.isLoading = true,
    this.initialTodo,
    this.title = '',
    this.description = '',
  });

  final bool isLoading;
  final Todo? initialTodo;
  final String title;
  final String description;

  bool get isNewTodo => initialTodo == null;

  EditTodoState copyWith({
    bool? isLoading,
    Todo? initialTodo,
    String? title,
    String? description,
  }) {
    return EditTodoState(
      isLoading: isLoading ?? this.isLoading,
      initialTodo: initialTodo ?? this.initialTodo,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [isLoading, initialTodo, title, description];
}
