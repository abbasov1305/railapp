import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreatedTime extends StatelessWidget {
  Timestamp _time;
  CreatedTime(this._time);

  @override
  Widget build(BuildContext context) {
    DateTime _created = _time.toDate();
    return Container(
      alignment: Alignment.centerRight,
      child: Text(
        DateFormat.yMd().format(_created),
        style: TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }
}
