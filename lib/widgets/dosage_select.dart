/// PillPal
///
/// Shows the page that allows the user to select the dosage of their medication.

import 'package:flutter/material.dart';

class DosageSelect extends StatefulWidget {
  final Map<String, dynamic> data;
  int count;
  int initial;

  DosageSelect(this.data, this.count, this.initial);
  @override
  State<StatefulWidget> createState() {
    return DosageSelectState(data, count, initial);
  }
}

class DosageSelectState extends State<DosageSelect> {
  Map<String, dynamic> data;
  int count;
  late int selected;

  DosageSelectState(this.data, this.count, initial) {
    selected = initial;
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