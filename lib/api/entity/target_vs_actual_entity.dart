import 'package:flutter/material.dart';
import 'package:sysconn_sfa/api/entity/target_vs_actual_det_entity.dart';

class TargetVsActualEntity {
  String? companyId;
  String? partnerCode;
  String? date;
  String? stockDivision;
  String? stockDivisionNew;
  String? division;
  String? salesPerson;
  String? salesPersonNew;
  String? typeNew;
  String? name;
  String? amount;
  String? type;
  String? actual;
  String? diff;
  String? id;
  TextEditingController? targetAmntCntrl;
  List<TargetVsActualDetEntity>? targetdet;

  TargetVsActualEntity({
    this.companyId,
    this.partnerCode,
    this.date,
    this.stockDivision,
    this.stockDivisionNew,
    this.salesPerson,
    this.type,
    this.typeNew,
    this.actual,
    this.diff,
    this.targetAmntCntrl,
    this.targetdet,
    this.id,
  });

  TargetVsActualEntity.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    partnerCode = json['partner_code'];
    date = json['date'];
    stockDivision = json['stock_division'];
    division = json['brand_name'];
    id = json["id"];
    name = json['name'];
    salesPerson = json['name'];
    amount = json['amount'] != ''
        ? num.parse(json['amount']).toStringAsFixed(2)
        : '';
    type = json['type'];
    actual = json['actual'];
    diff = json['differance'];
    if (json['targetdet'] != null) {
      targetdet = [];
      json['targetdet'].forEach((v) {
        targetdet!.add(TargetVsActualDetEntity.fromJson(v));
      });
    }
    //type = json['TYPE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (companyId != null) {
      data['company_id'] = companyId;
    }
    if (partnerCode != null) {
      data['partner_code'] = partnerCode;
    }
    if (date != null) {
      data['date'] = date;
    }
    if (stockDivision != null) {
      data['brand'] = stockDivision;
    }
    if (stockDivisionNew != null) {
      data['stockdivision_new'] = stockDivisionNew;
    }
    if (salesPerson != null) {
      data['sales_person'] = salesPerson;
    }
    if (salesPersonNew != null) {
      data['sales_person_new'] = salesPersonNew;
    }
    if (type != null) {
      data['type'] = type;
    }
    if (typeNew != null) {
      data['type_new'] = typeNew;
    }
    // if (amount != null) {
    //   data['amount'] = amount;
    // }
    if (targetdet != null) {
      data['targetdet'] = targetdet!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
