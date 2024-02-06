// ignore: file_names
import 'package:flutter/material.dart';

class NoDuplicatePageRoute<T> extends MaterialPageRoute<T> {
  NoDuplicatePageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
          builder: builder,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    // Check if the route is already present in the stack
    if (nextRoute is MaterialPageRoute &&
        nextRoute.builder == builder &&
        nextRoute.settings.name == settings.name) {
      return false;
    }
    return super.canTransitionTo(nextRoute);
  }
}
