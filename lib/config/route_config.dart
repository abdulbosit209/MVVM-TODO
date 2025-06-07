import 'package:todo_project/core/models/todo.dart';
import 'package:todo_project/home/home_view.dart';
import 'package:todo_project/core/utils/navigation/route_data.dart';
import 'package:todo_project/not_found/not_found_view.dart';
import 'package:todo_project/todo/edit_todo/edit_todo_view.dart';

final routes = [
  RouteEntry(path: '/', builder: (key, routeData) => const HomeView()),
  RouteEntry(path: '/404', builder: (key, routeData) => const NotFoundView()),
  RouteEntry(
    path: '/editTodoPage',
    builder: (key, routeData) {
      final todo = routeData.extra as Todo?;
      return EditTodoPage(initialTodo: todo);
    },
  ),
];
