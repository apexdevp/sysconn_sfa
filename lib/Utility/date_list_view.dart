import 'package:flutter/material.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';

class DateListView {
  static List<String> dateList = ["Today","Yesterday","Current Week","Last Week","Current Month","Last Month","Current Quarter","Last Quarter","Current Financial Year","Last Financial Year","Current Calender Year","Last Calender Year","Custom Date"];
  static String selectedStringDateLocal = 'Current Financial Year';
  static String? dateSelectedFormat = DateListView.getDateSelectedFormat(selectedStringDateLocal);

  static DateTime? selectedFromDateOfDateController = findStartOfThisYear(DateTime.now());
  static DateTime? selectedToDateOfDateController = findLastOfThisYear(DateTime.now());

  static void setdashboarddate(String selectedStringDate,BuildContext context) {
    DateListView.selectedStringDateLocal = selectedStringDate;
    DateListView.dateSelectedFormat = DateListView.getDateSelectedFormat(selectedStringDate);
    DateListView.onPressedPopupMenuDate(selectedStringDate, context);
  }

  static String getDateSelectedFormat(String selectedFormat){
    String selectedDateFormat = '';
    if(selectedFormat == 'Today' || selectedFormat == 'Yesterday'){
      selectedDateFormat = 'Day';
    }else if(selectedFormat == 'Current Week' || selectedFormat == 'Last Week'){
      selectedDateFormat = 'WK';
    }else if(selectedFormat == 'Current Month' || selectedFormat == 'Last Month'){
      selectedDateFormat = 'MTH';
    }else if(selectedFormat == 'Current Quarter' || selectedFormat == 'Last Quarter'){
      selectedDateFormat = 'QTR';
    }else if(selectedFormat == 'Current Financial Year' || selectedFormat == 'Last Financial Year'){
      selectedDateFormat = 'FY';
    }else if(selectedFormat == 'Current Calender Year' || selectedFormat == 'Last Calender Year'){
      selectedDateFormat = 'CY';
    }else {
      selectedDateFormat = 'Date';
    }
    return selectedDateFormat;
  }

  //===============================================================================================================

  static DateTime findYesterday(DateTime dateTime) {
    return dateTime.subtract(Duration(days: 1));
  }

  // week
  static DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  static DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  static DateTime findFirstDateOfLastWeek(DateTime dateTime) {
    DateListView.selectedFromDateOfDateController = findFirstDateOfTheWeek(DateListView.selectedFromDateOfDateController!);
    DateListView.selectedFromDateOfDateController = DateListView.selectedFromDateOfDateController!.subtract(Duration(days: 1));
    DateListView.selectedFromDateOfDateController = findFirstDateOfTheWeek(DateListView.selectedFromDateOfDateController!);
    return DateListView.selectedFromDateOfDateController!;
  }

  static DateTime findLastDateOfLastWeek(DateTime dateTime) {
    DateListView.selectedToDateOfDateController = findFirstDateOfTheWeek(DateListView.selectedToDateOfDateController!);
    DateListView.selectedToDateOfDateController = DateListView.selectedToDateOfDateController!.subtract(Duration(days: 1));
    DateListView.selectedToDateOfDateController = findLastDateOfTheWeek(DateListView.selectedToDateOfDateController!);
    return DateListView.selectedToDateOfDateController!;
  }
  static DateTime findFirstDateOfPreviousWeek(DateTime dateTime) {
    final DateTime sameWeekDayOfLastWeek = dateTime.subtract(Duration(days: 7));
    return findFirstDateOfTheWeek(sameWeekDayOfLastWeek);
  }
  static DateTime findLastDateOfPreviousWeek(DateTime dateTime) {
    final DateTime sameWeekDayOfLastWeek = dateTime.subtract(Duration(days: 7));
    return findLastDateOfTheWeek(sameWeekDayOfLastWeek);
  }

  //month
  static DateTime findStartOfLastMonth(DateTime dateTime) {
    return DateTime(dateTime.year,dateTime.month-1,1);
  }
  static DateTime findLastOfLastMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month , 0);
  }
  static DateTime findStartOfThisMonth(DateTime dateTime) {
    return DateTime(dateTime.year,dateTime.month,1);
  }
  static DateTime findLastOfThisMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month + 1, 0);
  }

  // quarter
  static DateTime findStartOfQuarter(DateTime dateTime){
    int quarterNumber = ((dateTime.month-1)/3+1).toInt();
    return DateTime(dateTime.year, (quarterNumber-1)*3+1,1);
  }
  static DateTime findLastOfQuarter(DateTime dateTime){
    int quarterNumber = ((dateTime.month-1)/3+1).toInt();
    DateTime firstDayOfQuarter = DateTime(dateTime.year, (quarterNumber-1)*3+1,1);
    return DateTime(firstDayOfQuarter.year,firstDayOfQuarter.month+3,0);
  }
  static DateTime findStartOfLastQuarter(DateTime dateTime){
    int quarterNumber = ((dateTime.month-1)/3+1).toInt();
    DateTime date = DateTime(dateTime.year, (quarterNumber-1)*3+1,1);
    date = date.subtract(Duration(days: 1));
    quarterNumber = ((date.month-1)/3+1).toInt();
    return DateTime(date.year, (quarterNumber-1)*3+1,1);
  }
  static DateTime findLastOfLastQuarter(DateTime dateTime){
    DateTime date = findStartOfQuarter(dateTime);
    date = date.subtract(Duration(days: 1));
    int quarterNumber = ((date.month-1)/3+1).toInt();
    DateTime firstDayOfQuarter = DateTime(date.year, (quarterNumber-1)*3+1,1);
    return DateTime(firstDayOfQuarter.year,firstDayOfQuarter.month+3,0);
  }

  // year
  static DateTime findStartOfLastCalenderYear(DateTime dateTime) {
    DateTime date = findStartOfThisYear(dateTime);
    date = DateTime(date.year, 1);
    return date;
  }
  static DateTime findLastOfLastCalenderYear(DateTime dateTime) {
    DateTime date = findLastOfThisYear(dateTime);
    date = DateTime(date.year - 1, 1, 0);
    return date;
  }
  static DateTime findStartOfCurrentCalenderYear(DateTime dateTime) {
    DateTime date;
    date = DateTime(dateTime.year, 1);
    return date;
  }
  static DateTime findLastOfCurrentCalenderYear(DateTime dateTime) {
    DateTime date;
    date = DateTime(dateTime.year + 1, 1, 0);
    return date;
  }
  static DateTime findStartOfPreviousCalenderYear(DateTime dateTime) {
    DateTime date = findStartOfCurrentCalenderYear(dateTime);
    date = DateTime(date.year - 1, 1);
    return date;
  }
  static DateTime findLastOfPreviousCalenderYear(DateTime dateTime) {
    DateTime date = findLastOfCurrentCalenderYear(dateTime);
    date = DateTime(date.year, 0);
    return date;
  }
  static DateTime findStartOfThisYear(DateTime dateTime){
    DateTime date;
    if(dateTime.month<4){
      date = DateTime(dateTime.year-1,4,1);
    }
    else{
      date = DateTime(dateTime.year,4,1);
    }
    return date;
  }
  static DateTime findLastOfThisYear(DateTime dateTime){
    DateTime date;
    if(dateTime.month<4){
      date = DateTime(dateTime.year,4,0);
    }
    else{
      date = DateTime(dateTime.year+1,4,0);
    }
    return date;
  }
  static DateTime findStartOfLastYear(DateTime dateTime){
    DateTime date = findStartOfThisYear(dateTime);
    date = DateTime(date.year-1,4,1);
    return date;
  }
  static DateTime findLastOfLastYear(DateTime dateTime){
    DateTime date = findLastOfThisYear(dateTime);
    date = DateTime(date.year-1,4,0);
    return date;
  }

  //==================================================================================================================
  // day
  static DateTime findTomorrow(DateTime dateTime) {
    // return DateListView.selectedFromDateOfDateController!.add(Duration(days: 1));   // komal // 21-11-2022 // yesterday and day issue
    return dateTime.add(Duration(days: 1));
  }

  // week
  static DateTime findFirstDateOfNextWeek(DateTime dateTime) {
    DateListView.selectedFromDateOfDateController = findLastDateOfTheWeek(DateListView.selectedFromDateOfDateController!);
    DateListView.selectedFromDateOfDateController = DateListView.selectedFromDateOfDateController!.add(Duration(days: 1));
    DateListView.selectedFromDateOfDateController = findFirstDateOfTheWeek(DateListView.selectedFromDateOfDateController!);
    return DateListView.selectedFromDateOfDateController!;
  }
  static DateTime findLastDateOfNextWeek(DateTime dateTime) {
    DateListView.selectedToDateOfDateController = findLastDateOfTheWeek(DateListView.selectedToDateOfDateController!);
    DateListView.selectedToDateOfDateController = DateListView.selectedToDateOfDateController!.add(Duration(days: 1));
    DateListView.selectedToDateOfDateController = findLastDateOfTheWeek(DateListView.selectedToDateOfDateController!);
    return DateListView.selectedToDateOfDateController!;
  }

  // month
  static DateTime findStartOfNextMonth(DateTime dateTime) {
    return DateTime(dateTime.year,dateTime.month+1,1);
  }
  static DateTime findLastOfNextMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month+2,0);
  }

  // quarter
  static DateTime findStartOfNextQuarter(DateTime dateTime){
    int quarterNumber = ((dateTime.month-1)/3+1).toInt();
    DateTime firstDayOfQuarter = DateTime(dateTime.year, (quarterNumber-1)*3+1,1);
    DateTime date = DateTime(firstDayOfQuarter.year,firstDayOfQuarter.month+3,0);
    date = date.add(Duration(days: 1));
    quarterNumber = ((date.month-1)/3+1).toInt();
    return DateTime(date.year, (quarterNumber-1)*3+1,1);
  }
  static DateTime findLastOfNextQuarter(DateTime dateTime){
    int quarterNumber = ((dateTime.month-1)/3+1).toInt();
    DateTime firstDayOfQuarter = DateTime(dateTime.year, (quarterNumber-1)*3+1,1);
    DateTime date = DateTime(firstDayOfQuarter.year,firstDayOfQuarter.month+3,0);
    date = date.add(Duration(days: 1));
    quarterNumber = ((date.month-1)/3+1).toInt();
    firstDayOfQuarter = DateTime(date.year, (quarterNumber-1)*3+1,1);
    return DateTime(firstDayOfQuarter.year,firstDayOfQuarter.month+3,0);
  }

  // year
  static DateTime findStartOfNextCalenderYear(DateTime dateTime) {
    DateTime date = findStartOfThisYear(dateTime);
    date = DateTime(date.year + 2, 1);
    return date;
  }
  static DateTime findLastOfNextCalenderYear(DateTime dateTime) {
    DateTime date = findLastOfThisYear(dateTime);
    date = DateTime(date.year + 1, 1, 0);
    return date;
  }
  static DateTime findStartOfNextYear(DateTime dateTime){
    DateTime date = findStartOfThisYear(dateTime);
    date = DateTime(date.year+1,4,1);
    return date;
  }
  static DateTime findLastOfNextYear(DateTime dateTime){
    DateTime date = findLastOfThisYear(dateTime);
    date = DateTime(date.year+1,4,0);
    return date;
  }

  //==================================================================================================================

  static Future onPressedPopupMenuDate(selectedStringDate,context) async {
    DateTime todayDate = DateTime.now();
    if(selectedStringDate=="Today"){
      DateListView.selectedFromDateOfDateController = DateTime.now();
      DateListView.selectedToDateOfDateController = DateTime.now();
      // DateListView.dateController.text= "${DateFormat('dd/MM/yyyy').format(todayDate).toString()} - ${DateFormat('dd/MM/yyyy').format(todayDate).toString()}";
    }
    if(selectedStringDate=="Yesterday"){
      DateListView.selectedFromDateOfDateController = DateTime(todayDate.year, todayDate.month, todayDate.day-1);
      DateListView.selectedToDateOfDateController = DateTime(todayDate.year, todayDate.month, todayDate.day-1);
      // DateListView.dateController.text= "${DateFormat('dd/MM/yyyy').format(DateListView.selectedFromDateOfDateController!).toString()} - ${DateFormat('dd/MM/yyyy').format(DateListView.selectedToDateOfDateController!).toString()}";
    }
    if(selectedStringDate=="Current Week"){
      DateListView.selectedFromDateOfDateController = findFirstDateOfTheWeek(todayDate);
      DateListView.selectedToDateOfDateController = findLastDateOfTheWeek(todayDate);
      // DateListView.dateController.text= "${DateFormat('dd/MM/yyyy').format(findFirstDateOfTheWeek(todayDate)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastDateOfTheWeek(todayDate)).toString()}";
    }
    if(selectedStringDate=="Current Month"){
      DateListView.selectedFromDateOfDateController = findStartOfThisMonth(todayDate);
      DateListView.selectedToDateOfDateController = findLastOfThisMonth(todayDate);
      // DateListView.dateController.text= "${DateFormat('dd/MM/yyyy').format(findStartOfThisMonth(todayDate)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfThisMonth(todayDate)).toString()}";
    }
    if(selectedStringDate=="Last Month"){
      DateListView.selectedFromDateOfDateController = findStartOfLastMonth(todayDate);
      DateListView.selectedToDateOfDateController = findLastOfLastMonth(todayDate);
      // DateListView.dateController.text= "${DateFormat('dd/MM/yyyy').format(findStartOfLastMonth(todayDate)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfLastMonth(todayDate)).toString()}";
    }
    if(selectedStringDate=="Current Quarter"){
      DateListView.selectedFromDateOfDateController = findStartOfQuarter(todayDate);
      DateListView.selectedToDateOfDateController = findLastOfQuarter(todayDate);
      // DateListView.dateController.text= "${DateFormat('dd/MM/yyyy').format(findStartOfQuarter(todayDate)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfQuarter(todayDate)).toString()}";
    }
    if(selectedStringDate=="Current Financial Year"){
      DateListView.selectedFromDateOfDateController= findStartOfThisYear(todayDate);
      DateListView.selectedToDateOfDateController= findLastOfThisYear(todayDate);
      // DateListView.dateController.text= "${DateFormat('dd/MM/yyyy').format(findStartOfThisYear(todayDate)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfThisYear(todayDate)).toString()}";
    }
    if(selectedStringDate=="Last Financial Year"){
      DateListView.selectedFromDateOfDateController= findStartOfLastYear(todayDate);
      DateListView.selectedToDateOfDateController= findLastOfLastYear(todayDate);
      // DateListView.dateController.text= "${DateFormat('dd/MM/yyyy').format(findStartOfLastYear(todayDate)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfLastYear(todayDate)).toString()}";
    }

    // komal // new format added
    if (selectedStringDate == "Last Week") {
      DateListView.selectedFromDateOfDateController = findFirstDateOfPreviousWeek(todayDate);
      DateListView.selectedToDateOfDateController = findLastDateOfPreviousWeek(todayDate);
      // DateListView.dateController.text = "${DateFormat('dd/MM/yyyy').format(findFirstDateOfPreviousWeek(todayDate)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastDateOfPreviousWeek(todayDate)).toString()}";
    }
    if (selectedStringDate == "Last Quarter") {
      DateListView.selectedFromDateOfDateController = findStartOfLastQuarter(todayDate);
      DateListView.selectedToDateOfDateController = findLastOfLastQuarter(todayDate);
      // DateListView.dateController.text = "${DateFormat('dd/MM/yyyy').format(findStartOfLastQuarter(todayDate)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfLastQuarter(todayDate)).toString()}";
    }
    if (selectedStringDate == "Current Calender Year") {
      DateListView.selectedFromDateOfDateController = findStartOfCurrentCalenderYear(todayDate);
      DateListView.selectedToDateOfDateController = findLastOfCurrentCalenderYear(todayDate);
      // DateListView.dateController.text = "${DateFormat('dd/MM/yyyy').format(findStartOfCurrentCalenderYear(todayDate)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfCurrentCalenderYear(todayDate)).toString()}";
    }
    if (selectedStringDate == "Last Calender Year") {
      DateListView.selectedFromDateOfDateController = findStartOfPreviousCalenderYear(todayDate);
      DateListView.selectedToDateOfDateController = findLastOfPreviousCalenderYear(todayDate);
      // DateListView.dateController.text = "${DateFormat('dd/MM/yyyy').format(findStartOfPreviousCalenderYear(todayDate)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfPreviousCalenderYear(todayDate)).toString()}";
    }
    if(selectedStringDate=="Custom Date"){
      await selectDateRange( DateListView.selectedFromDateOfDateController!, DateListView.selectedToDateOfDateController!).then((datetimerange) {
        DateListView.selectedFromDateOfDateController = datetimerange.start;
        DateListView.selectedToDateOfDateController = datetimerange.end;
      });
    }
  }

  static void onPressedBackArrowDate(){
    if(DateListView.selectedStringDateLocal == "Today"){
      // DateListView.dateController.text= "${DateFormat('dd/MM/yyyy').format(findYesterday(DateListView.selectedFromDateOfDateController!)).toString()} - ${DateFormat('dd/MM/yyyy').format(findYesterday(DateListView.selectedToDateOfDateController!)).toString()}";
      DateListView.selectedFromDateOfDateController = findYesterday(DateListView.selectedFromDateOfDateController!);
      DateListView.selectedToDateOfDateController = findYesterday(DateListView.selectedToDateOfDateController!);
    }
    if(DateListView.selectedStringDateLocal=="Yesterday"){
      // DateListView.dateController.text= "${DateFormat('dd/MM/yyyy').format(findYesterday(DateListView.selectedFromDateOfDateController!)).toString()} - ${DateFormat('dd/MM/yyyy').format(findYesterday(DateListView.selectedToDateOfDateController!)).toString()}";
      DateListView.selectedFromDateOfDateController = findYesterday(DateListView.selectedFromDateOfDateController!);
      DateListView.selectedToDateOfDateController = findYesterday(DateListView.selectedToDateOfDateController!);
    }
    if(DateListView.selectedStringDateLocal=="Current Week"){
      // DateListView.dateController.text= "${DateFormat('dd/MM/yyyy').format(findFirstDateOfLastWeek(DateListView.selectedFromDateOfDateController!)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastDateOfLastWeek(DateListView.selectedToDateOfDateController!)).toString()}";
      DateListView.selectedFromDateOfDateController = findFirstDateOfLastWeek(DateListView.selectedFromDateOfDateController!);
      DateListView.selectedToDateOfDateController = findLastDateOfLastWeek(DateListView.selectedToDateOfDateController!);
    }
    if(DateListView.selectedStringDateLocal=="Current Month"){
      // DateListView.dateController.text= "${DateFormat('dd/MM/yyyy').format(findStartOfLastMonth(DateListView.selectedFromDateOfDateController!)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfLastMonth(DateListView.selectedToDateOfDateController!)).toString()}";
      DateListView.selectedFromDateOfDateController = findStartOfLastMonth(DateListView.selectedFromDateOfDateController!);
      DateListView.selectedToDateOfDateController = findLastOfLastMonth(DateListView.selectedToDateOfDateController!);
    }
    if(DateListView.selectedStringDateLocal=="Last Month"){
      // DateListView.dateController.text= "${DateFormat('dd/MM/yyyy').format(findStartOfLastMonth(DateListView.selectedFromDateOfDateController!)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfLastMonth(DateListView.selectedToDateOfDateController!)).toString()}";
      DateListView.selectedFromDateOfDateController = findStartOfLastMonth(DateListView.selectedFromDateOfDateController!);
      DateListView.selectedToDateOfDateController = findLastOfLastMonth(DateListView.selectedToDateOfDateController!);
    }
    if(DateListView.selectedStringDateLocal=="Current Quarter"){
      // DateListView.dateController.text= "${DateFormat('dd/MM/yyyy').format(findStartOfLastQuarter(DateListView.selectedFromDateOfDateController!)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfLastQuarter(DateListView.selectedToDateOfDateController!)).toString()}";
      DateListView.selectedFromDateOfDateController = findStartOfLastQuarter(DateListView.selectedFromDateOfDateController!);
      DateListView.selectedToDateOfDateController = findLastOfLastQuarter(DateListView.selectedToDateOfDateController!);
    }
    if(DateListView.selectedStringDateLocal=="Current Financial Year"){
      // DateListView.dateController.text= "${DateFormat('dd/MM/yyyy').format(findStartOfLastYear(DateListView.selectedFromDateOfDateController!)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfLastYear(DateListView.selectedToDateOfDateController!)).toString()}";
      DateListView.selectedFromDateOfDateController = findStartOfLastYear(DateListView.selectedFromDateOfDateController!);
      DateListView.selectedToDateOfDateController = findLastOfLastYear(DateListView.selectedToDateOfDateController!);
    }
    if(DateListView.selectedStringDateLocal=="Last Financial Year"){
      // DateListView.dateController.text= "${DateFormat('dd/MM/yyyy').format(findStartOfLastYear(DateListView.selectedFromDateOfDateController!)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfLastYear(DateListView.selectedToDateOfDateController!)).toString()}";
      DateListView.selectedFromDateOfDateController = findStartOfLastYear(DateListView.selectedFromDateOfDateController!);
      DateListView.selectedToDateOfDateController = findLastOfLastYear(DateListView.selectedToDateOfDateController!);
    }
    // komal // new format added
    if (DateListView.selectedStringDateLocal == "Last Week") {
      // DateListView.dateController.text = "${DateFormat('dd/MM/yyyy').format(findFirstDateOfLastWeek(DateListView.selectedFromDateOfDateController!)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastDateOfLastWeek(DateListView.selectedToDateOfDateController!)).toString()}";
      DateListView.selectedFromDateOfDateController = findFirstDateOfLastWeek(DateListView.selectedFromDateOfDateController!);
      DateListView.selectedToDateOfDateController = findLastOfLastQuarter(DateListView.selectedToDateOfDateController!);
    }
    if (DateListView.selectedStringDateLocal == "Last Quarter") {
      // DateListView.dateController.text = "${DateFormat('dd/MM/yyyy').format(findStartOfLastQuarter(DateListView.selectedFromDateOfDateController!)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfLastQuarter(DateListView.selectedToDateOfDateController!)).toString()}";
      DateListView.selectedFromDateOfDateController = findStartOfLastQuarter(DateListView.selectedFromDateOfDateController!);
      DateListView.selectedToDateOfDateController = findLastOfLastQuarter(DateListView.selectedToDateOfDateController!);
    }
    if (DateListView.selectedStringDateLocal == "Current Calender Year") {
      // DateListView.dateController.text = "${DateFormat('dd/MM/yyyy').format(findStartOfLastCalenderYear(DateListView.selectedFromDateOfDateController!)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfLastCalenderYear(DateListView.selectedToDateOfDateController!)).toString()}";
      DateListView.selectedFromDateOfDateController = findStartOfLastCalenderYear(DateListView.selectedFromDateOfDateController!);
      DateListView.selectedToDateOfDateController = findLastOfLastCalenderYear(DateListView.selectedToDateOfDateController!);
    }
    if (DateListView.selectedStringDateLocal == "Last Calender Year") {
      // DateListView.dateController.text = "${DateFormat('dd/MM/yyyy').format(findStartOfLastCalenderYear(DateListView.selectedFromDateOfDateController!)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfLastCalenderYear(DateListView.selectedToDateOfDateController!)).toString()}";
      DateListView.selectedFromDateOfDateController = findStartOfLastCalenderYear(DateListView.selectedFromDateOfDateController!);
      DateListView.selectedToDateOfDateController = findLastOfLastCalenderYear(DateListView.selectedToDateOfDateController!);
    }
    if(DateListView.selectedStringDateLocal=="Custom Date"){

    }
    // DateListView.dateErrorText = null;
  }

  static void onPressedForwardArrowDate(){
    if(DateListView.selectedStringDateLocal == "Today"){
      // DateListView.dateController.text= "${DateFormat('dd/MM/yyyy').format(findTomorrow(DateListView.selectedFromDateOfDateController!)).toString()} - ${DateFormat('dd/MM/yyyy').format(findTomorrow(DateListView.selectedToDateOfDateController!)).toString()}";
      DateListView.selectedFromDateOfDateController = findTomorrow(DateListView.selectedFromDateOfDateController!);
      DateListView.selectedToDateOfDateController = findTomorrow(DateListView.selectedToDateOfDateController!);
    }
    if(DateListView.selectedStringDateLocal=="Yesterday"){
      // DateListView.dateController.text= "${DateFormat('dd/MM/yyyy').format(findTomorrow(DateListView.selectedFromDateOfDateController!)).toString()} - ${DateFormat('dd/MM/yyyy').format(findTomorrow(DateListView.selectedToDateOfDateController!)).toString()}";
      DateListView.selectedFromDateOfDateController = findTomorrow(DateListView.selectedFromDateOfDateController!);
      DateListView.selectedToDateOfDateController = findTomorrow(DateListView.selectedToDateOfDateController!);
    }
    if(DateListView.selectedStringDateLocal=="Current Week"){
      // DateListView.dateController.text= "${DateFormat('dd/MM/yyyy').format(findFirstDateOfNextWeek(DateListView.selectedFromDateOfDateController!)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastDateOfNextWeek(DateListView.selectedToDateOfDateController!)).toString()}";
      DateListView.selectedFromDateOfDateController = findFirstDateOfNextWeek(DateListView.selectedFromDateOfDateController!);
      DateListView.selectedToDateOfDateController = findLastDateOfNextWeek(DateListView.selectedToDateOfDateController!);
    }
    if(DateListView.selectedStringDateLocal=="Current Month"){
      // DateListView.dateController.text= "${DateFormat('dd/MM/yyyy').format(findStartOfNextMonth(DateListView.selectedFromDateOfDateController!)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfNextMonth(DateListView.selectedToDateOfDateController!)).toString()}";
      DateListView.selectedFromDateOfDateController = findStartOfNextMonth(DateListView.selectedFromDateOfDateController!);
      DateListView.selectedToDateOfDateController = findLastOfNextMonth(DateListView.selectedToDateOfDateController!);
    }
    if(DateListView.selectedStringDateLocal=="Last Month"){
      // DateListView.dateController.text= "${DateFormat('dd/MM/yyyy').format(findStartOfNextMonth(DateListView.selectedFromDateOfDateController!)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfNextMonth(DateListView.selectedToDateOfDateController!)).toString()}";
      DateListView.selectedFromDateOfDateController = findStartOfNextMonth(DateListView.selectedFromDateOfDateController!);
      DateListView.selectedToDateOfDateController = findLastOfNextMonth(DateListView.selectedToDateOfDateController!);
    }
    if(DateListView.selectedStringDateLocal=="Current Quarter"){
      // DateListView.dateController.text= "${DateFormat('dd/MM/yyyy').format(findStartOfNextQuarter(DateListView.selectedFromDateOfDateController!)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfNextQuarter(DateListView.selectedToDateOfDateController!)).toString()}";
      DateListView.selectedFromDateOfDateController = findStartOfNextQuarter(DateListView.selectedFromDateOfDateController!);
      DateListView.selectedToDateOfDateController = findLastOfNextQuarter(DateListView.selectedToDateOfDateController!);
    }
    if(DateListView.selectedStringDateLocal=="Current Financial Year"){
      // DateListView.dateController.text= "${DateFormat('dd/MM/yyyy').format(findStartOfNextYear(DateListView.selectedFromDateOfDateController!)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfNextYear(DateListView.selectedToDateOfDateController!)).toString()}";
      DateListView.selectedFromDateOfDateController = findStartOfNextYear(DateListView.selectedFromDateOfDateController!);
      DateListView.selectedToDateOfDateController = findLastOfNextYear(DateListView.selectedToDateOfDateController!);
    }
    if(DateListView.selectedStringDateLocal=="Last Financial Year"){
      // DateListView.dateController.text= "${DateFormat('dd/MM/yyyy').format(findStartOfNextYear(DateListView.selectedFromDateOfDateController!)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfNextYear(DateListView.selectedToDateOfDateController!)).toString()}";
      DateListView.selectedFromDateOfDateController = findStartOfNextYear(DateListView.selectedFromDateOfDateController!);
      DateListView.selectedToDateOfDateController = findLastOfNextYear(DateListView.selectedToDateOfDateController!);
    }
    // komal // new date format added
    if (DateListView.selectedStringDateLocal == "Last Week") {
      // DateListView.dateController.text = "${DateFormat('dd/MM/yyyy').format(findFirstDateOfNextWeek(DateListView.selectedFromDateOfDateController!)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastDateOfNextWeek(DateListView.selectedToDateOfDateController!)).toString()}";
      DateListView.selectedFromDateOfDateController = findFirstDateOfNextWeek(DateListView.selectedFromDateOfDateController!);
      DateListView.selectedToDateOfDateController = findLastDateOfNextWeek(DateListView.selectedToDateOfDateController!);
    }
    if (DateListView.selectedStringDateLocal == "Last Quarter") {
      // DateListView.dateController.text = "${DateFormat('dd/MM/yyyy').format(findStartOfNextQuarter(DateListView.selectedFromDateOfDateController!)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfNextQuarter(DateListView.selectedToDateOfDateController!)).toString()}";
      DateListView.selectedFromDateOfDateController = findStartOfNextQuarter(DateListView.selectedFromDateOfDateController!);
      DateListView.selectedToDateOfDateController = findLastOfNextQuarter(DateListView.selectedToDateOfDateController!);
    }
    if (DateListView.selectedStringDateLocal == "Current Calender Year") {
      // DateListView.dateController.text = "${DateFormat('dd/MM/yyyy').format(findStartOfNextCalenderYear(DateListView.selectedFromDateOfDateController!)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfNextCalenderYear(DateListView.selectedToDateOfDateController!)).toString()}";
      DateListView.selectedFromDateOfDateController = findStartOfNextCalenderYear(DateListView.selectedFromDateOfDateController!);
      DateListView.selectedToDateOfDateController = findLastOfNextCalenderYear(DateListView.selectedToDateOfDateController!);
    }
    if (DateListView.selectedStringDateLocal == "Last Calender Year") {
      // DateListView.dateController.text = "${DateFormat('dd/MM/yyyy').format(findStartOfNextCalenderYear(DateListView.selectedFromDateOfDateController!)).toString()} - ${DateFormat('dd/MM/yyyy').format(findLastOfNextCalenderYear(DateListView.selectedToDateOfDateController!)).toString()}";
      DateListView.selectedFromDateOfDateController = findStartOfNextCalenderYear(DateListView.selectedFromDateOfDateController!);
      DateListView.selectedToDateOfDateController = findLastOfNextCalenderYear(DateListView.selectedToDateOfDateController!);
    }
    
    if(DateListView.selectedStringDateLocal=="Custom Date"){

    }
  }
}