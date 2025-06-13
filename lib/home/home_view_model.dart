import 'package:flutter/foundation.dart';

enum HomeTab { todos, stats }

class HomeViewModel extends ValueNotifier<HomeTab> {
  HomeViewModel() : super(HomeTab.todos);

  void setTab(HomeTab tab) => value = tab;
}

