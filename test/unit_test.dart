import 'package:test/test.dart';
import 'package:collection/collection.dart';

import 'package:weighttracker/models/weightRecord.dart';

void main() {
  // test('adding a more recent entry changes current weight', () {
  //   final weights = WeightHistory();
  //   final newWeight = 20.0;
  //   final newDateTime = DateTime.now();
  //   weights.addListener(() {
  //     expect(weights.currentWeight, equals(newWeight));
  //   });
  //   weights.add(WeightRecord(newWeight, newDateTime));
  // });

  test('test getWeeklyAverage returns correct averages', () {
    final weights = [
      WeightRecord(70.3, DateTime(2022, 3, 12, 8, 31)),
      WeightRecord(70.9, DateTime(2022, 3, 13, 8, 31)),
      WeightRecord(75.7, DateTime(2022, 3, 27, 8, 31)),
      WeightRecord(74.1, DateTime(2022, 3, 19, 8, 31)),
    ];

    final expectedAverage = [
      WeightRecord(70.6, DateTime(2022, 3, 7)),
      WeightRecord(75.7, DateTime(2022, 3, 21)),
      WeightRecord(74.1, DateTime(2022, 3, 14)),
    ];  // note that the function conserves the input order

    expect(ListEquality().equals(getWeeklyAverage(weights), expectedAverage), true);

  });


  test('test getMonthlyAverage returns correct averages', () {
    final weights = [
      WeightRecord(70.3, DateTime(2022, 3, 12, 8, 31)),
      WeightRecord(70.9, DateTime(2022, 3, 13, 8, 31)),
      WeightRecord(75.7, DateTime(2022, 2, 27, 8, 31)),
      WeightRecord(74.1, DateTime(2022, 2, 19, 8, 31)),
    ];

    final expectedAverage = [
      WeightRecord(70.6, DateTime(2022, 3)),
      WeightRecord(74.9, DateTime(2022, 2)),
    ];  // note that the function conserves the input order

    expect(ListEquality().equals(getMonthlyAverage(weights), expectedAverage), true);

  });
}
