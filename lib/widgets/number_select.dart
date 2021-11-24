/// PillPal
///
/// Shows the page that allows the user to select the dosage of their medication.

import 'package:flutter/material.dart';

class NumberSelect extends StatefulWidget {
  final Map<String, dynamic> data;
  int count;
  String keyName;
  String text;

  NumberSelect(this.data, this.count, this.keyName, this.text);
  @override
  State<StatefulWidget> createState() {
    return NumberSelectState(data, count, keyName, text);
  }
}

class NumberSelectState extends State<NumberSelect> {
  Map<String, dynamic> data;
  int count;
  String keyName;
  String text;
  late int selected;

  NumberSelectState(this.data, this.count, this.keyName, this.text) {
    selected = data[keyName];
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
                    data[keyName] = index;
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
