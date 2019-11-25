
import 'package:first_app/DataClass/Infos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';


class InfosCard extends StatelessWidget {
  Infos data;

  InfosCard(Infos data) {
    this.data = data;
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('MMM dd, hh:mm');

    String date =
    formatter.format(DateTime.fromMicrosecondsSinceEpoch(data.id.time));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    data.title,
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
                Text(date, style: Theme.of(context).textTheme.caption)
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            Text(
              data.description,
              style: Theme.of(context).textTheme.body1,
            ),
            const SizedBox(
              height: 16.0,
            ),
          ],
        ),
      ),
    );
  }
}