import 'package:flutter/material.dart';
import 'package:weighttracker/db/database.dart';
import 'package:weighttracker/models/weightRecord.dart';


/// WeightHistory holds the user-supplied weight data points.
/// It is a list of WeightRecords, where each WeigthRecord has two variables
/// weight and datetime associated with it.

class WeightHistory extends ChangeNotifier {

  final handler = DBHandler();

  // get the list of weights
  Future<List<WeightRecord>> get value => handler.retrieveRecords();

  // add a new weight
  void add(WeightRecord weightRecord) {
    handler.insertRecord(weightRecord);
    notifyListeners(); // this will tell listening widgets to rebuild
  }

  // remove a weight
  void remove(int datetime) {
    handler.deleteRecord(datetime);
    notifyListeners();
  }

// TODO need to implement an edit function to allow for changing errors
}

