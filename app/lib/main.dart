import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:munin/config/application.dart';
import 'package:munin/config/development.dart';
import 'package:munin/redux/app/AppState.dart';
import 'package:munin/router/routes.dart';
import 'package:munin/widgets/initial/MainMaterialApp.dart';
import 'package:redux/redux.dart';

void main() {
  Development();
}

class MuninApp extends StatefulWidget {
  final Application application;
  final Store<AppState> store;

  const MuninApp(this.application, this.store);

  @override
  State<StatefulWidget> createState() {
    return _MuninAppState();
  }
}

class _MuninAppState extends State<MuninApp> {
  @override
  void initState() {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: widget.store,
      child: MainMaterialApp(),
    );
  }
}
