import 'package:todo_project/core/utils/navigation/route_data.dart';
import 'package:todo_project/core/utils/navigation/router_service.dart';

class NotFoundViewModel {
  final RouterService _routerService;

  NotFoundViewModel({required RouterService routerService})
    : _routerService = routerService;

  void navigateToHome() {
    _routerService.replaceAll([Path(name: '/')]);
  }
}
