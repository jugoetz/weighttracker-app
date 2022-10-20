import 'package:flutter/material.dart';
import 'package:weighttracker/models/weightHistory.dart';
import 'package:weighttracker/models/weightRecord.dart';
import 'package:provider/provider.dart';


class ChangeWeightScreen extends StatelessWidget {
  /// Screen to set a new weight. Accessed from home screen via 'change' button

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Weight'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Enter new weight:', style: TextStyle(fontSize: 20)),
            SizedBox(
              height: 20,
            ),
            WeightForm(),
          ],
        ),
      ),
    );
  }
}

class WeightForm extends StatefulWidget {
  /// Form widget for the ChangeWeightScreen

  @override
  _WeightFormState createState() => _WeightFormState();
}

class _WeightFormState extends State<WeightForm> {
  /// State of the form widget for the ChangeWeightScreen
  double _formProgress = 0.0;
  final _weightFormController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // method to follow form progress to enable SET button
  void _updateFormProgress() {
    var _controllers = [
      _weightFormController,
      _dateController,
      _timeController
    ];
    var progress = 0.0;
    for (var controller in _controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / _controllers.length;
      }
    }

    setState(() {
      _formProgress = progress;
    });
  }

  // build method for the form
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      onChanged: _updateFormProgress,
      child: Column(
        children: [
          // Field for entering weight
          TextFormField(
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Enter your weight'),
            controller: _weightFormController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a number';
              }
              if (double.tryParse(value) == null) {
                // we land here if the string can't be parsed to double
                return 'Please enter a valid number';
              }
              if (double.parse(value) <= 0) {
                return 'Please enter a number above zero';
              }
              return null;
            },
          ),
          Row(
            children: [
              // Field for entering date
              SizedBox(
                width: 200,
                child: TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Enter date'),
                  controller: _dateController,
                  onTap: () async {
                    var date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100));
                    _dateController.text = date.toString().substring(0, 10); // returns yyyy-mm-dd
                  },
                ),
              ),
              // Field for entering time
              SizedBox(
                  width: 100,
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Enter time'),
                    controller: _timeController,
                    onTap: () async {
                      var time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      _timeController.text = time.toString().substring(10, 15); // returns hh:mm
                    },
                  )),
            ],
          ),
          // button to submit the form
          TextButton(
            style: ButtonStyle(),
            child: Text('Set'),
            onPressed: _formProgress == 1
                ? () {
                    if (_formKey.currentState!.validate()) {

                      Provider.of<WeightHistory>(context, listen: false).add(
                          WeightRecord(double.parse(_weightFormController.text),
                              DateTime.parse(_dateController.text + " " +  _timeController.text)));
                      Navigator.pop(context);
                    }
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
