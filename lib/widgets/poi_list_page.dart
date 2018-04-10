import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pocket_lab/hew/hew_repository.dart';
import 'package:pocket_lab/hew/models/gts.dart';

class PoiListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _PoiListPageState();
  }
}

class _PoiListPageState extends State<PoiListPage> {
  Future<List<Gts>> _gtsList;

  @override
  void initState() {
    super.initState();
    _loadGtsList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Pocket lab")),
        body: new Container(
            child: new FutureBuilder(
                future: _gtsList,
                builder:
                    (BuildContext context, AsyncSnapshot<List<Gts>> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return _buildError(Icons.sync_problem, "No connection");
                    case ConnectionState.waiting:
                      return const Center(
                          child: const CircularProgressIndicator());
                    default:
                      if (snapshot.hasError) {
                        return _buildError(
                            Icons.error, "Failed to retreive data");
                      } else {
                        var data = snapshot.data;
                        return new RefreshIndicator(
                          onRefresh: _loadGtsList,
                          child: new ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (BuildContext ctx, int index) {
                              return new PoiRow(data[index]);
                            },
                            physics: const AlwaysScrollableScrollPhysics(),
                          ),
                        );
                      }
                  }
                })));
  }

  Future<List<Gts>> _loadGtsList() {
    var client = new HewRepository();
    var list = client.findAll();
    setState(() {
      _gtsList = list;
    });
    return list;
  }

  Widget _buildError(IconData icon, String text) {
    return new Center(
        child: new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Icon(
          icon,
          color: Colors.black26,
        ),
        new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Text(text),
        ),
        new MaterialButton(
            child: new Text("Retry"),
            color: Colors.black12,
            onPressed: _loadGtsList),
      ],
    ));
  }
}

class PoiRow extends StatelessWidget {
  final Gts _gts;

  PoiRow(this._gts);

  @override
  Widget build(BuildContext context) {
    return new InkWell(
          onTap: () => _openPoiGraph(context, _gts.labels["KEPLERID"]),
          child: new Container(
            decoration: new BoxDecoration(
              border: new BorderDirectional(
                  bottom: new BorderSide(color: Colors.black12)),
            ),
            padding: new EdgeInsets.all(16.0),
            child: new Text(
              _gts.labels["OBJECT"],
              style: new TextStyle(fontSize: 16.0),
            ),
          ),
        );
  }

  _openPoiGraph(BuildContext context, String keplerId) {
    Navigator.pushNamed(context, '/graph/$keplerId');
  }
}
