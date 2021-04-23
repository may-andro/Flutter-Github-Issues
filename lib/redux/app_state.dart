import 'package:flutter/material.dart';
import 'package:flutter_github/utils/theme/theme_list.dart';

class AppState {
  final ThemeData themeData;

  AppState({this.themeData});

  factory AppState.initial() {
    return AppState(
      themeData: themeList[0],
    );
  }

  AppState copyWith({ThemeData givenThemeData}) {
    return AppState(
      themeData: givenThemeData ?? this.themeData,
    );
  }

  AppState setThemeData({ThemeData themeData}) {
    return copyWith(givenThemeData: themeData ?? this.themeData);
  }
}
