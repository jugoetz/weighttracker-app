import 'dart:collection';

import 'dart:math';

class WeightRecord {
  /// Class to hold individual weight records, consisting of a weight
  /// and the datetime of acquisition.
  // Variables
  final double weight;
  final DateTime datetime;

  // Constructor
  WeightRecord(
      this.weight,
      this.datetime
      );

  @override
  bool operator ==(covariant WeightRecord other) => (other.weight == weight) && (other.datetime == datetime);

  // Map method for saving an instance to DB
  Map<String, Object?> toMap() {
    return {'date': datetime.millisecondsSinceEpoch, 'weight': weight};
  }

  // fromMap method to retrieve an instance from DB
  WeightRecord.fromMap(Map<String, dynamic> res):
        datetime = DateTime.fromMillisecondsSinceEpoch(res["date"]),
        weight = res["weight"];


}

List<WeightRecord> sortWeightRecords(List<WeightRecord> weight) {
  weight.sort((a, b) => a.datetime.compareTo(b.datetime));
  return weight;
}

List<WeightRecord> getWeeklyAverage(List<WeightRecord> weights) {
  /// compute the average for weekly ranges
  // for every timestamp, get the stamp of the most recent Monday before it
  DateTime mostRecentMonday(DateTime date) =>
      DateTime(date.year, date.month, date.day - (date.weekday - 1));

  Iterable<DateTime> mondays = weights.map((w) => mostRecentMonday(w.datetime));

  List<WeightRecord> weightRecordsAndMondays = [for(int i=0; i < mondays.length; i++) WeightRecord(weights[i].weight, mondays.elementAt(i))];
  List<WeightRecord> aggregatedWeights = [];
  for (DateTime m in mondays.toSet()) {
    var weekly = weightRecordsAndMondays.where((element) => element.datetime == m);
    final double weightThisWeek;
    if (weekly.length > 1) {
      weightThisWeek = weekly.reduce((a, b) => WeightRecord(a.weight + b.weight, a.datetime)).weight / weekly.length;
    } else {
      weightThisWeek = weekly.elementAt(0).weight;
    }
    aggregatedWeights.add(WeightRecord(weightThisWeek, m));
  }

  return aggregatedWeights;
}

List<WeightRecord> getMonthlyAverage(List<WeightRecord> weights) {
  /// compute the average for monthly ranges
  // for every timestamp, get the stamp of the 1st of the month
  DateTime firstOfMonth(DateTime date) =>
      DateTime(date.year, date.month);

  Iterable<DateTime> firstDays = weights.map((w) => firstOfMonth(w.datetime));

  List<WeightRecord> weightRecordsAndFirstDays = [for(int i=0; i < firstDays.length; i++) WeightRecord(weights[i].weight, firstDays.elementAt(i))];
  List<WeightRecord> aggregatedWeights = [];
  for (DateTime m in firstDays.toSet()) {
    var weekly = weightRecordsAndFirstDays.where((element) => element.datetime == m);
    final double weightThisWeek;
    if (weekly.length > 1) {
      weightThisWeek = weekly.reduce((a, b) => WeightRecord(a.weight + b.weight, a.datetime)).weight / weekly.length;
    } else {
      weightThisWeek = weekly.elementAt(0).weight;
    }
    aggregatedWeights.add(WeightRecord(weightThisWeek, m));
  }

  return aggregatedWeights;
}

double getMin(List<WeightRecord> weights) {
  if (weights.length == 0) {
    return 0.0;
  } else {
    var min = weights[0].weight;
    for (final weight in weights) {
      if (weight.weight < min) {
        min = weight.weight;
      }
    }
    return min;
  }
}

double getMax(List<WeightRecord> weights) {
  if (weights.length == 0) {
    return 0.0;
  } else {
    var max = weights[0].weight;
    for (final weight in weights) {
      if (weight.weight > max) {
        max = weight.weight;
      }
    }
    return max;
  }
}