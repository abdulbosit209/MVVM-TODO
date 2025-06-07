import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class HomeViewModel {
  HomeViewModel();

  final ValueNotifier<HomeState> state = ValueNotifier<HomeState>(
    HomeState(),
  );

  void setTab(HomeTab tab) => state.value = HomeState(tab: tab);

  void dispose() {
    state.dispose();
  }
}

enum HomeTab { todos, stats }

final class HomeState extends Equatable {
  const HomeState({this.tab = HomeTab.todos});

  final HomeTab tab;

  @override
  List<Object> get props => [tab];
}
