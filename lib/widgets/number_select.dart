/// PillPal
///
/// Shows the page that allows the user to select the dosage of their medication.

import 'package:flutter/material.dart';

import '../../med/data/medication.dart';

@immutable
class NumberSelect extends StatefulWidget {
  final Medication medication;
  final int count;
  final String keyName;
  final String text;

  const NumberSelect(this.medication, this.count, this.keyName, this.text,
      {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      NumberSelectState(medication, count, keyName, text);
}

class NumberSelectState extends State<NumberSelect> {
  Medication medication;
  int count;
  String keyName;
  String text;
  late int selected;

  NumberSelectState(this.medication, this.count, this.keyName, this.text) {
    selected = medication.get(keyName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$text Selection'),
      ),
      body: Column(
        children: <Widget>[
          // List of Times to choose from.
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider();
              },
              // 1-10 for Dosage.
              itemCount: count,
              itemBuilder: (BuildContext context, int index) {
                index += 1;
                // Set of values
                return ListTile(
                  title: Text('$index'),
                  trailing: Icon(
                    index == selected ? Icons.check_circle : null,
                  ),
                  onTap: () {
                    medication.set(keyName, index);
                    setState(() {
                      selected = index;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
