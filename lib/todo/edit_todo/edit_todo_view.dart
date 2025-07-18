import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_project/config/locator_config.dart';
import 'package:todo_project/core/models/todo.dart';
import 'package:todo_project/core/utils/internal_notification/notify_service.dart';
import 'package:todo_project/todo/edit_todo/edit_todo_view_model.dart';
import 'package:todo_project/todo/todo_repository.dart';

class EditTodoPage extends StatefulWidget {
  const EditTodoPage({this.initialTodo, super.key});

  final Todo? initialTodo;

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  
  @override
  void initState() {
    super.initState();
    registerEditTodoViewModel();
  }

  void registerEditTodoViewModel() {
    locator.pushNewScope(
      scopeName: 'editTodoViewModel',
      init: (di) {
        di.registerSingleton<EditTodoViewModel>(
          EditTodoViewModel(
            todosRepository: locator<TodosRepository>(),
            initialTodo: widget.initialTodo,
            notifyService: locator<NotifyService>(),
          ),
          dispose: (editTodoViewModel) => editTodoViewModel.dispose(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: locator<EditTodoViewModel>(),
      builder: (context, state, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.isNewTodo ? 'New todo' : 'Edit todo'),
          ),
          floatingActionButton: FloatingActionButton(
            shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32)),
            ),
            onPressed: state.isLoading
                ? null
                : () => locator<EditTodoViewModel>().onSubmitted(),
            child: state.isLoading
                ? const CupertinoActivityIndicator()
                : const Icon(Icons.check_rounded),
          ),
          body: CupertinoScrollbar(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [_TitleField(), _DescriptionField()],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    locator.popScope();
    super.dispose();
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: locator<EditTodoViewModel>(),
      builder: (context, state, _) {
        return TextFormField(
          key: const Key('editTodoView_title_textFormField'),
          initialValue: state.title,
          decoration: InputDecoration(
            enabled: !state.isLoading,
            labelText: 'Title',
            hintText: state.initialTodo?.title ?? '',
          ),
          maxLength: 50,
          inputFormatters: [
            LengthLimitingTextInputFormatter(50),
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
          ],
          onChanged: (title) =>
              locator<EditTodoViewModel>().onTitleChanged(title: title),
        );
      },
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: locator<EditTodoViewModel>(),
      builder: (context, state, _) {
        return TextFormField(
          key: const Key('editTodoView_description_textFormField'),
          initialValue: state.description,
          decoration: InputDecoration(
            enabled: !state.isLoading,
            labelText: 'Description',
            hintText: state.initialTodo?.description ?? '',
          ),
          maxLength: 300,
          maxLines: 7,
          inputFormatters: [LengthLimitingTextInputFormatter(300)],
          onChanged: (description) {
            locator<EditTodoViewModel>().onDescriptionChanged(
              description: description,
            );
          },
        );
      },
    );
  }
}
