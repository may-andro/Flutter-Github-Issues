import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_github/app.dart';

import 'locator.dart';
import 'redux/app_store.dart';

void main() => run();

FirebaseAnalytics _firebaseAnalytics;

Future run() async {
  WidgetsFlutterBinding.ensureInitialized();

  setup();
  var store = await createStore();

  await Firebase.initializeApp();
  setUpFirebaseStuff();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(App(store: store));
  });
}

void setUpFirebaseStuff() {
	_firebaseAnalytics = FirebaseAnalytics();
	_firebaseAnalytics.logEvent(name: "App Started");

	FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
	FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

}
