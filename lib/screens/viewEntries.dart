import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weighttracker/models/weightHistory.dart';
import 'package:weighttracker/models/weightRecord.dart';

class ViewEntriesScreen extends StatelessWidget {
  /// Screen to view and edit all weight entries

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Weight Entries"),
        ),
        body: Container(
            child: Consumer<WeightHistory>(
                builder: (context, weight_history, child) => FutureBuilder(
                      future: weight_history.value,
                      initialData: [WeightRecord(50, DateTime.now())],
                      builder: (BuildContext context,
                          AsyncSnapshot<List<WeightRecord>> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.length == 0) {
                            return Container(
                              child: Text(
                                  'No weight recorded',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              alignment: Alignment.center,
                            );
                          } else {
                            return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: Icon(Icons.monitor_weight),
                                    title: Text(
                                      snapshot.data!.reversed
                                              .elementAt(index)
                                              .weight
                                              .toString() +
                                          ' kg',
                                      maxLines: 1,
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                       Provider.of<WeightHistory> (context, listen: false).remove(snapshot.data!.reversed
                                           .elementAt(index)
                                           .datetime.millisecondsSinceEpoch);
                                      },
                                    ),
                                    subtitle: Text(DateFormat.yMMMd()
                                        .add_jm()
                                        .format(snapshot.data!.reversed
                                            .elementAt(index)
                                            .datetime)),
                                  );
                                });
                          }
                        } else {
                          return Text('No weight recorded');
                        }
                      },
                    ))));
  }
}



