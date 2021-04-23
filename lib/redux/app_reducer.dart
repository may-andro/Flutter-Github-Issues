import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'app_actions.dart';
import 'app_state.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    themeData: changeThemeReducer(state.themeData, action),
  );
}

final changeThemeReducer = combineReducers<ThemeData>([
  TypedReducer<ThemeData, ChangeThemeAction>(_changeThemeReducer),
]);

ThemeData _changeThemeReducer(ThemeData themeData, ChangeThemeAction action) {
  return action.themeData;
}
