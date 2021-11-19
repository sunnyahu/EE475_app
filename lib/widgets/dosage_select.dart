/// PillPal
///
/// Shows the page that allows the user to select the dosage of their medication.

import 'package:flutter/material.dart';

class DosageSelect extends StatefulWidget {
  final Map<String, dynamic> data;
  int count;

  DosageSelect(this.data, this.count);
  @override
  State<StatefulWidget> createState() {
    return DosageSelectState(data, count);
  }
}

class DosageSelectState extends State<DosageSelect> {
  Map<String, dynamic> data;
  int count;
  late int selected;

  DosageSelectState(this.data, this.count) {
    selected = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dosage Selection'),
      ),
      body: Column(
        children: <Widget>[
          // List of Times to choose from.
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider();
              },
              // Using 24-Hour time with increments of 30 minutes.
              itemCount: count,
              itemBuilder: (BuildContext context, int index) {
                // Set of values
                return ListTile(
                  title: Text('$index'),
                  trailing: Icon(
                    index == selected ? Icons.check_circle : null,
                  ),
                  onTap: () {
                    data['dosage'] = index;
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
