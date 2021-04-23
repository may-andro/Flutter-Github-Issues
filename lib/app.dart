import 'package:flutter/material.dart';
import 'package:flutter_github/ui/home/issues/issues_page.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'redux/app_state.dart';

class App extends StatelessWidget {
  final Store<AppState> store;

  App({@required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: StoreConnector<AppState, AppState>(
            converter: (store) => store.state,
            builder: (context, appState) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Issues',
                theme: appState.themeData,
                home: Scaffold(
                  body: IssuesPage(),
                ),
              );
            })
    );
  }
}
