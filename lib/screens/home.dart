import 'package:flutter/material.dart';
import 'package:weighttracker/models/chart.dart';
import 'package:weighttracker/models/weightHistory.dart';
import 'package:weighttracker/models/weightRecord.dart';
import 'package:weighttracker/screens/changeWeight.dart';
import 'package:provider/provider.dart';
import 'package:weighttracker/screens/viewEntries.dart';


class Weight extends StatefulWidget {
  /// Widget to keep track of the weight and show it on the homescreen
  @override
  _WeightState createState() => _WeightState();
}

class _WeightState extends State<Weight> {
  final TextStyle _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weight Tracker'),
      ),
      body: Container(
        width: 400,
        height: 800,
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.all(8),
                width: 400,
                height: 200,
                child: MyLineChart()),
            Padding(padding: EdgeInsets.all(20)),
            Consumer<WeightHistory>(
                builder: (context, weight_history, child) => FutureBuilder(
                      future: weight_history.value,
                      initialData: [WeightRecord(50, DateTime.now())],
                      builder: (BuildContext context,
                          AsyncSnapshot<List<WeightRecord>> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.length == 0) {
                            return Text('Press "Change" to set your weight.');
                          } else {
                            return Text(
                              '${snapshot.data!.last.weight.toStringAsFixed(1)} kg',
                              style: TextStyle(
                                  fontSize: 42, fontWeight: FontWeight.bold),
                            );
                          }
                        } else {
                          return Text('Press "Change" to set your weight.');
                        }
                      },
                    )),
            Padding(padding: EdgeInsets.all(20)),
            Row(
              children: [
                _changeButton(),
                Padding(padding: EdgeInsets.all(10)),
                _viewAllButton()
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            )

          ],
        ),
      ),
    );
  }


  Widget _changeButton() {
    /// Button to go to the screen to enter new weight
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChangeWeightScreen();
        }));
      },
      child: Text('Change'),
    );
  }

  Widget _viewAllButton() {
    /// Button to go to the screen to view and edit all weight entries
    return ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ViewEntriesScreen();
          }
          ));
        },
        child: Text('View all'),
    );
  }
}
