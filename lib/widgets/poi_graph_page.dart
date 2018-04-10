import 'dart:async';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:pocket_lab/hew/hew_repository.dart';
import 'package:pocket_lab/hew/models/gts.dart';

class PoiGraphPage extends StatefulWidget {
  final String _keplerId;

  PoiGraphPage(this._keplerId);

  @override
  State<StatefulWidget> createState() {
    return new _PoiGraphPageState(_keplerId);
  }
}

class _PoiGraphPageState extends State<PoiGraphPage> {
  final String _keplerId;
  Future<Gts> _gts;

  _PoiGraphPageState(this._keplerId);

  @override
  void initState() {
    super.initState();
    _loadGts();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Graph #$_keplerId")),
        body: new Container(
            child: new FutureBuilder(
                future: _gts,
                builder: (BuildContext context, AsyncSnapshot<Gts> snapshot) {
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
                            onRefresh: _loadGts, child: _buildChart(data));
                      }
                  }
                })));
  }

  Future<Gts> _loadGts() {
    var client = new HewRepository();
    var gts = client.fetch(_keplerId);
    setState(() {
      _gts = gts;
    });
    return gts;
  }

  Widget _buildChart(Gts gts) {
    return new charts.TimeSeriesChart(
        [
          new charts.Series<TimeSeriesIntensity, DateTime>(
              id: 'Intensity',
              domainFn: (TimeSeriesIntensity intensity, _) => intensity.time,
              measureFn: (TimeSeriesIntensity intensity, _) =>
              intensity.intensity,
              data: gts.values)
        ],
        animate: false,
        dateTimeFactory: const charts.LocalDateTimeFactory(),
        primaryMeasureAxis: new charts.NumericAxisSpec(
            tickProviderSpec:
            new charts.BasicNumericTickProviderSpec(zeroBound: false)),
    );
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
                onPressed: _loadGts),
          ],
        ));
  }
}
