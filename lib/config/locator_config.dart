import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_project/todo/todos_api.dart';
import 'package:todo_project/core/utils/http/http_abstraction.dart';
import 'package:todo_project/core/utils/http/http_interceptor.dart';
import 'package:todo_project/config/route_config.dart';
import 'package:todo_project/core/utils/navigation/router_service.dart';
import 'package:todo_project/core/utils/internal_notification/notify_service.dart';
import 'package:todo_project/todo/todo_repository.dart';

final locator = GetIt.instance;

void setup() {
  locator.registerSingleton<RouterService>(
    RouterService(supportedRoutes: routes),
  );
  locator.registerSingleton<NotifyService>(NotifyService());
  locator.registerSingletonAsync<SharedPreferences>(
    () async => await SharedPreferences.getInstance(),
  );
  locator.registerSingleton<HttpAbstraction>(
    HttpAbstraction(interceptors: [LoggingInterceptor(logBody: !kReleaseMode)]),
  );
  locator.registerLazySingleton(
    () => TodosRepository(
      todosApi: LocalStorageTodosApi(
        plugin: locator<SharedPreferences>(),
      ),
    ),
    dispose: (todosRepository) => todosRepository.dispose(),
  );
}

// final modules = [
//   Module<RouterService>(
//     builder: () => RouterService(supportedRoutes: routes),
//     lazy: false,
//   ),
//   Module<NotifyService>(builder: () => NotifyService(), lazy: false),
//   Module(builder: () => SharedPreferencesAbstraction(), lazy: false),
//   Module<HttpAbstraction>(
//     builder:
//         () => HttpAbstraction(
//           interceptors: [LoggingInterceptor(logBody: !kReleaseMode)],
//         ),
//     lazy: true,
//   ),
//   Module<TodosRepository>(
//     builder:
//         () => TodosRepository(
//           todosApi: LocalStorageTodosApi(
//             plugin: locator<SharedPreferencesAbstraction>().prefs,
//           ),
//         ),
//     lazy: true,
//   ),
// ];
