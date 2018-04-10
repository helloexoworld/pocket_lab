import 'package:meta/meta.dart';

class Gts {
  String className;
  Map labels;
  Map attributes;
  List<TimeSeriesIntensity> values;

  Gts({@required this.className, this.labels, this.attributes, this.values});

  static fromMap(Map map) {
      return new Gts(
        className: map['c'],
        attributes: map['a'],
        labels: map['l'],
        values: map['v'].map((item) => new TimeSeriesIntensity(new DateTime.fromMicrosecondsSinceEpoch(item[0]), item[1])).toList(),
    );
  }
}

class TimeSeriesIntensity {
  final DateTime time;
  final double intensity;

  TimeSeriesIntensity(this.time, this.intensity);
}
