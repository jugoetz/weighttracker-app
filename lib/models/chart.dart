
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:weighttracker/models/weightHistory.dart';
import 'package:weighttracker/models/weightRecord.dart';



/// everything below is for the chart.
/// Initially, the chart displays hardcoded sample data (as long as
/// weightHistory is empty). After a record has been added to weightHistory,
/// the user-supplied weightHistory is shown.
///
/// TODO finish chart formatting (see https://pub.dev/packages/fl_chart)

class MyLineChart extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<WeightHistory>(
        builder: (context, weight, cart) => FutureBuilder(
              future: weight.value,
              initialData: [WeightRecord(50, DateTime.now())],
              builder: (BuildContext context,
                  AsyncSnapshot<List<WeightRecord>> snapshot) {
                if (snapshot.hasData) {
                  final colorScheme = Theme.of(context).colorScheme;
                  if (snapshot.data!.length == 0) {
                    return Container(
                      child: Text(
                        'No weight recorded',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      alignment: Alignment.center,
                    );
                  } else {
                    return LineChart(dailyData(snapshot.data!, colorScheme));
                  }
                } else {
                  return Text("no data");
                }
              },
            ));
  }

  List<FlSpot> convertWeightRecordsToFlSpot(List<WeightRecord> weightHistory) {
    return weightHistory
        .map((e) =>
            FlSpot(e.datetime.millisecondsSinceEpoch.toDouble(), e.weight))
        .toList();
  }


  LineChartData dailyData(List<WeightRecord> weightRecords, ColorScheme colorScheme) {
    final List<WeightRecord> testWeights = [
      WeightRecord(70.3, DateTime(2021, 3, 25, 8, 31)),
      WeightRecord(75.7, DateTime(2021, 3, 28, 8, 31)),
      WeightRecord(74.1, DateTime(2021, 3, 29, 8, 31)),
    ];
    return LineChartData(
      lineBarsData: [
        LineChartBarData(  // individual records
          spots: convertWeightRecordsToFlSpot(
              weightRecords.length != 0 ? weightRecords : testWeights),
          colors: [Colors.transparent],
          barWidth: 3.0,
          isCurved: true,
          curveSmoothness: 0.15,
          dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
    radius: 2,
    color: colorScheme.primary,
    strokeWidth: 3,
    strokeColor: colorScheme.onTertiary);}),
        ),
        LineChartBarData(  // weekly average
          spots: convertWeightRecordsToFlSpot(getWeeklyAverage(
              weightRecords.length != 0 ? weightRecords : testWeights)),
          colors: [colorScheme.onPrimary],
          barWidth: 3.0,
          isCurved: true,
          curveSmoothness: 0.15,
          dotData: dotData,
        ),
        LineChartBarData(  // monthly average
          spots: convertWeightRecordsToFlSpot(getMonthlyAverage(
              weightRecords.length != 0 ? weightRecords : testWeights)),
          colors: [colorScheme.tertiary],
          barWidth: 3.0,
          isCurved: true,
          curveSmoothness: 0.3,
          dotData: dotData,
        ),
      ],
      backgroundColor: Colors.transparent,
      gridData: gridData,
      borderData: borderData,
      titlesData: titlesData,
      minY: (getMin(weightRecords) - 1.0).roundToDouble(),
      maxY: (getMax(weightRecords) + 1.0).roundToDouble(),

    );
  }

  FlDotData get dotData => FlDotData(show: false);

  FlGridData get gridData => FlGridData(
    show: true,
    drawHorizontalLine: true,
    drawVerticalLine: false,
    horizontalInterval: 1,
    getDrawingHorizontalLine: (double _) {return FlLine(strokeWidth: 1, color: Colors.grey.shade700);},

  );

  FlBorderData get borderData => FlBorderData(show: false);

  // TitlesData refers to axis labels, not to the title in the matplotlib sense
  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    rightTitles: SideTitles(showTitles: false),
    topTitles: SideTitles(showTitles: false),
    leftTitles: SideTitles(
      showTitles: true,
      reservedSize: 30,
    ),
    bottomTitles: SideTitles(
      showTitles: true,
      getTitles: (double value) {
        return DateFormat.MMM().format(DateTime.fromMillisecondsSinceEpoch(value.toInt()));
        // final now = DateTime.now().millisecondsSinceEpoch;
        // return ((now - value) / 3600000 ~/ 24).toString();
      },
      interval: 1000 * 60 * 60 * 24 * 31, // 30 d in ms
    ),
  );


}
