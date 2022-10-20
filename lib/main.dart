import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weighttracker/models/weightHistory.dart';
import 'package:weighttracker/screens/home.dart';


/// see https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple#changenotifier
///

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => WeightHistory(),  // this will track changes to WeightHistory and cause listeners to rebuild
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weight Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple.shade700,
        brightness: Brightness.dark)
      ),
      home: Weight(),
    );
  }
}
