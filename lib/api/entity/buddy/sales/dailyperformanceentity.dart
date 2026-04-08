import 'package:sysconn_sfa/Utility/utility.dart';

class DailyPerformanceEntity {
  RouteEntity? route;
  VisitEntity? visit;
  PendingleadEntity? pendinglead;
  PendingsoEntity? pendingso;
  PendingsalescnEntity? pendingsalescn;
  CollectionEntity? collection;
  OsfollowupEntity? osfollowup;
  ExpensesincurredEntity? expenseincured;

  DailyPerformanceEntity({
    this.route,
    this.visit,
    this.pendinglead,
    this.pendingso,
    this.pendingsalescn,
    this.collection,
    this.osfollowup,
    this.expenseincured,
  });

  DailyPerformanceEntity.fromJson(Map<String, dynamic> json) {
    if (json['route'] != null) {
      route = RouteEntity.fromJson(json['route']);
    }
    if (json['visit'] != null) {
      visit = VisitEntity.fromJson(json['visit']);
    }
    if (json['pending_lead'] != null) {
      pendinglead = PendingleadEntity.fromJson(json['pending_lead']);
    }
    if (json['pending_so'] != null) {
      pendingso = PendingsoEntity.fromJson(json['pending_so']);
    }
    if (json['pending_sales_cn'] != null) {
      pendingsalescn = PendingsalescnEntity.fromJson(json['pending_sales_cn']);
    }
    if (json['collection'] != null) {
      collection = CollectionEntity.fromJson(json['collection']);
    }
    if (json['os_followup'] != null) {
      osfollowup = OsfollowupEntity.fromJson(json['os_followup']);
    }
    if (json['expenses_incurred'] != null) {
      expenseincured = ExpensesincurredEntity.fromJson(
        json['expenses_incurred'],
      );
    }
  }
}

class RouteEntity {
  String? routeName;
  String? activerouteCustomer;

  RouteEntity({this.routeName, this.activerouteCustomer});

  RouteEntity.fromJson(Map<String, dynamic> json) {
    routeName = json['routename'];
    activerouteCustomer = json['activeroutecustomer'];
  }
}

class VisitEntity {
  String? existingVisit;
  String? coldVisit;
  VisitEntity({this.coldVisit, this.existingVisit});

  VisitEntity.fromJson(Map<String, dynamic> json) {
    coldVisit = json['coldvisit'];
    existingVisit = json['existingvisit'];
  }
}

class PendingleadEntity {
  String? record;
  String? uniquesku;
  String? uniquecustomer;
  String? totalvalue;

  PendingleadEntity.fromJson(Map<String, dynamic> json) {
    record = json['record'];
    uniquesku = json['uniquesku'];
    uniquecustomer = json['uniquecustomer'];
    totalvalue = json['totalvalue'] != ''
        ? Utility.formattedNumber.format(num.parse(json['totalvalue']))
        : '';
  }
}

class PendingsoEntity {
  String? record;
  String? uniquesku;
  String? uniquecustomer;
  String? totalvalue;
  PendingsoEntity.fromJson(Map<String, dynamic> json) {
    record = json['record'];
    uniquesku = json['uniquesku'];
    uniquecustomer = json['uniquecustomer'];
    totalvalue = json['totalvalue'] != ''
        ? Utility.formattedNumber.format(num.parse(json['totalvalue']))
        : '';
  }
}

class PendingsalescnEntity {
  String? record;
  String? uniquesku;
  String? uniquecustomer;
  String? totalvalue;
  PendingsalescnEntity.fromJson(Map<String, dynamic> json) {
    record = json['record'];
    uniquesku = json['uniquesku'];
    uniquecustomer = json['uniquecustomer'];
    totalvalue = json['totalvalue'] != ''
        ? Utility.formattedNumber.format(num.parse(json['totalvalue']))
        : '';
  }
}

class CollectionEntity {
  String? totalcollection;

  CollectionEntity.fromJson(Map<String, dynamic> json) {
    totalcollection = json['totalcollection'] != ''
        ? Utility.formattedNumber.format(num.parse(json['totalcollection']))
        : '';
  }
}

class OsfollowupEntity {
  String? todaysfollowup;
  String? totalcustomer;
  String? overdueamt;
  OsfollowupEntity.fromJson(Map<String, dynamic> json) {
    todaysfollowup = json['todaysfollowup'];
    totalcustomer = json['totalcust'];
    overdueamt = json['overdueamt'] != ''
        ? Utility.formattedNumber.format(num.parse(json['overdueamt']))
        : '';
  }
}

class ExpensesincurredEntity {
  String? expensesincured;

  ExpensesincurredEntity.fromJson(Map<String, dynamic> json) {
    expensesincured = json['expensesincurred'] != ''
        ? Utility.formattedNumber.format(num.parse(json['expensesincurred']))
        : '';
  }
}
