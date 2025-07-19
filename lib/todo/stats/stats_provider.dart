import 'package:flutter/material.dart';
import 'package:todo_project/todo/stats/stats_view_model.dart';

class StatsProvider extends InheritedWidget {
  const StatsProvider({
    required this.statsViewModel,
    required super.child,
    super.key,
  });

  final StatsViewModel statsViewModel;

  static StatsProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StatsProvider>();
  }

  static StatsProvider of(BuildContext context) {
    final StatsProvider? result = maybeOf(context);
    assert(result != null, 'No StatsProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(StatsProvider oldWidget) =>
      statsViewModel != oldWidget.statsViewModel;
}
