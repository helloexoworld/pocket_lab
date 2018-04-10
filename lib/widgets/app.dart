import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:pocket_lab/widgets/poi_graph_page.dart';
import 'package:pocket_lab/widgets/poi_list_page.dart';

class App extends StatelessWidget {
  Router router;

  App() {
    router = new Router();

    router.define('/', handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return new PoiListPage();
    }));

    router.define('/graph/:id', handler: new Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      String keplerId = params['id'][0];
      return new PoiGraphPage(keplerId);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'HelloExoWorld Pocket Lab',
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: new PoiListPage(),
      onGenerateRoute: router.generator,
    );
  }
}
