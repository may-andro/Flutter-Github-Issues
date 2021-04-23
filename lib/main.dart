import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_github/app.dart';

import 'locator.dart';
import 'redux/app_store.dart';

void main() => run();

Future run() async {
  setup();
  var store = await createStore();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(App(store: store));
  });
}
