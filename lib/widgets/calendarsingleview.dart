import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';

class CalendarSingleView extends StatelessWidget {
  final DateTime fromDate;
  final DateTime toDate;
  final Function()? function;

  const CalendarSingleView({super.key, 
    required this.fromDate,
    required this.toDate,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 12, 4, 12),
      margin: EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Utility.borderCornerRadious),
        border: Border.all(color: Colors.grey),
        color: Colors.white,
      ),
      child: InkWell(
        onTap: function,
        child: Row(
          children: [
            Icon(FontAwesomeIcons.calendar, size: 19),
            SizedBox(width: 9.0),
            Text(
              '${DateFormat('dd/MM/yyyy').format(fromDate)} - ${DateFormat('dd/MM/yyyy').format(toDate)}',
              style: kTxtStl13N,
            ),
          ],
        ),
      ),
    );
  }
}
