


import 'package:first_app/DataClass/Events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';




class EventsCard extends StatelessWidget {
  Events data;

  EventsCard(Events data) {
    this.data = data;
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('MMM dd, hh:mm');

    String fromDateReadable =
    formatter.format(DateTime.fromMicrosecondsSinceEpoch(data.fromDate));

    String toDateReadable =
    formatter.format(DateTime.fromMicrosecondsSinceEpoch(data.toDate));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              data.title,
              style: Theme.of(context).textTheme.title,
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
            Row(
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  color: Colors.purple,
                  size: 16.0,
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Text(
                  data.place,
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.access_time,
                  color: Colors.purple,
                  size: 16.0,
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Text(
                  fromDateReadable,
                  style: Theme.of(context).textTheme.caption,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}