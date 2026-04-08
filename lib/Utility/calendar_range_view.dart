import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/date_list_view.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';


class CalendarRangeView extends StatelessWidget {
  
  final Function() function;

  const CalendarRangeView({super.key,required this.function});    // this.fromDate,this.toDate,

  @override
  Widget build(BuildContext context) {
    // DateTime fromDateNew = fromDate == null?DateListView.selectedFromDateOfDateController!:fromDate!;
    // DateTime toDateNew = toDate == null?DateListView.selectedToDateOfDateController!:toDate!;
    Size size = MediaQuery.of(context).size;

    return StatefulBuilder(
      builder: (context,setState){
        return Container(
          margin: EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            border: Border.all(
              color: kContrastDarkColor
            ),
            color: Colors.white
          ),
          child: Row(
            children: [
              PopupMenuButton<String>(
                onSelected: (selectedStringDate) async {
                  setState((){
                    DateListView.selectedStringDateLocal = selectedStringDate;
                    DateListView.dateSelectedFormat =  DateListView.getDateSelectedFormat(selectedStringDate);
                  });
                  await DateListView.onPressedPopupMenuDate(selectedStringDate, context);
                  setState((){
                    // fromDateNew = DateListView.selectedFromDateOfDateController!;
                    // toDateNew = DateListView.selectedToDateOfDateController!;
                  });
                  await function();
                },
                offset: Offset.zero,
                icon: Icon(Icons.calendar_month_outlined,size: size.width * 0.04,),
                itemBuilder: (BuildContext context) {
                  return DateListView.dateList.map((String choice) {
                    return PopupMenuItem<String>(
                      height: 32,
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
              Text(DateListView.dateSelectedFormat!,style: kTxtStl13N,),
              SizedBox(
                width: size.width * 0.1,
                child: IconButton(
                  padding: EdgeInsets.all(0.0),
                  iconSize: size.width * 0.04,
                  icon: Icon(Icons.arrow_back_ios,size: size.width * 0.04,),
                  onPressed: () {
                    DateListView.onPressedBackArrowDate();
                    // fromDateNew = DateListView.selectedFromDateOfDateController!;
                    // toDateNew = DateListView.selectedToDateOfDateController!;
                    setState((){
        
                    });
                    function();
                  }
                ),
              ),
              // Text('${DateFormat('dd/MM/yyyy').format(fromDateNew)} - ${DateFormat('dd/MM/yyyy').format(toDateNew!)}',style: kTxtStl13N,),
              Text('${DateFormat('dd/MM/yyyy').format(DateListView.selectedFromDateOfDateController!)} - ${DateFormat('dd/MM/yyyy').format(DateListView.selectedToDateOfDateController!)}',style: kTxtStl13N,),
              SizedBox(
                width: size.width * 0.1,
                child: IconButton(
                  icon: Icon(Icons.arrow_forward_ios, size: size.width * 0.04,),
                  onPressed: () {
                    DateListView.onPressedForwardArrowDate();
                    // fromDateNew = DateListView.selectedFromDateOfDateController!;
                    // toDateNew = DateListView.selectedToDateOfDateController!;
                    setState((){
        
                    });
                    function();
                  }
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}