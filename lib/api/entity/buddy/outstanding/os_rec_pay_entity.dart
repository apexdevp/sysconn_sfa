class OutstandingRecPayEntity {
  String? _id;
  String? _partyname;
  double? _pendingamount;
  String? _creditdays;
  double? _creditlimit;
  double? _due;
  double? _overdue;
  String? _billdate;
  String? _billno;
  String? _duedate;
  String? _type;
  String? _nextfollowupdate; // Komal D 16-12-2021
  String? _billAmountControllerText;    // komal // 30-8-2022 // pending amount controller added to add value in receipt and payment transaction entry
  String? masterid; //pratiksha p 05-12-2023 add master id
  String? vchtype; //pratiksha p 05-12-2023 add vchtype
  // komal // commented bcze party group api is removed added agewise api for all type
  // komal // new api added for group os
  // String _groupid;
  // String _groupname;
  // double _amount;

  OutstandingRecPayEntity();

  String? get id => _id;
  set id(value){
    _id = value;
  }

  String? get partyname => _partyname;
  set partyname(value){
    _partyname = value;
  }
  
  double? get pendingamount => _pendingamount;
  set pendingamount(value){
    _pendingamount = value;
  }

  String? get creditdays => _creditdays;
  set creditdays(value){
    _creditdays = value;
  }

  double? get creditlimit => _creditlimit;
  set creditlimit(value){
    _creditlimit = value;
  }

  double? get due => _due;
  set due(value){
    _due = value;
  }

  double? get overdue => _overdue;
  set overdue(value){
    _overdue = value;
  }

  String? get billdate => _billdate;
  set billdate(value){
    _billdate = value;
  }

  String? get billno => _billno;
  set billno(value){
    _billno = value;
  }

  String? get duedate => _duedate;
  set duedate(value){
    _duedate = value;
  }

  String? get type => _type;
  set type(value){
    _type = value;
  }

  String? get nextfollowupdate => _nextfollowupdate; //Komal D 16-12-2021
  set nextfollowupdate(value){
    _nextfollowupdate = value;
  }

  // komal // commented bcze party group api is removed added agewise api for all type
  // komal // new api added for group os
  // String get groupid => _groupid;
  // set groupid(value){
  //   _groupid = value;
  // }

  // String get groupname => _groupname;
  // set groupname(value){
  //   _groupname = value;
  // }

  // double get amount => _amount;
  // set amount(value){
  //   _amount = value;
  // }

  String? get billAmountControllerText => _billAmountControllerText;   // komal // 30-8-2022 // pending amount controller added to add value in receipt and payment transaction entry

  set billAmountControllerText(value) {
    _billAmountControllerText = value;
  }
  
//   OutstandingRecPayEntity.fromJson(Map<String,dynamic> json) {
//     // _id = json['PARTYCODE'];   // komal // name changed bcze party api removed and agewise api added
//     _id = json['ID'];
//     // _partyname = json['PARTY_NAME'];    // koaml // name changed bcze party api removed and agewise api added
//     _partyname = json['NAME'];
//     _pendingamount = json['PENDING_AMOUNT'];
//     _creditdays = json['CREDIT_DAYS'];
//     _creditlimit = json['CREDIT_LIMIT'];
//     _due = json['DUE'];
    
//     // _overdue = json['OVER_DUE'];
//     // _overdue = (json['OVER_DUE'] != null && json['OVER_DUE'].toString().isNotEmpty)
//     // ? json['OVER_DUE'].toDouble()
//     // : 0.0;
// _overdue = (json['OVER_DUE'] != null && json['OVER_DUE'].toString().isNotEmpty)
//     ? double.tryParse(json['OVER_DUE'].toString()) ?? 0.0
//     : 0.0;
//     _billdate = json['BILL_DATE'];
//     _billno = json['BILL_NO'];
//     _duedate = json['DUE_DATE'];
//     _type = json['TYPE'];
//     _nextfollowupdate = json['NEXT_FOLLOWUP_DATE']; // Komal D 16-12-2021
//     _billAmountControllerText = '0';   // komal // 30-8-2022 // pending amount controller added to add value in receipt and payment transaction entry
//     masterid=json['MASTER_ID'];//pratiksha p 05-12-2023 add master id
//     vchtype=json['VCHTYPE_PARENT'];//pratiksha p 05-12-2023 addvchtype
//   }
 OutstandingRecPayEntity.fromJson(Map<String,dynamic> json) {
    // _id = json['PARTYCODE'];   // komal // name changed bcze party api removed and agewise api added
    _id = json['ID'];
    // _partyname = json['PARTY_NAME'];    // koaml // name changed bcze party api removed and agewise api added
    _partyname = json['NAME'];
    _pendingamount = json['pending_amount'];
    _creditdays = json['CREDIT_DAYS'];
    _creditlimit = json['CREDIT_LIMIT'];
    _due = json['DUE'];
    
    // _overdue = json['OVER_DUE'];
    // _overdue = (json['OVER_DUE'] != null && json['OVER_DUE'].toString().isNotEmpty)
    // ? json['OVER_DUE'].toDouble()
    // : 0.0;
_overdue = (json['over_due'] != null && json['over_due'].toString().isNotEmpty)
    ? double.tryParse(json['over_due'].toString()) ?? 0.0
    : 0.0;
    _billdate = json['bill_date'];
    _billno = json['bill_no'];
    _duedate = json['due_date'];
    _type = json['type'];
    _nextfollowupdate = json['NEXT_FOLLOWUP_DATE']; // Komal D 16-12-2021
    _billAmountControllerText = '0';   // komal // 30-8-2022 // pending amount controller added to add value in receipt and payment transaction entry
    masterid=json['master_id'];//pratiksha p 05-12-2023 add master id
    vchtype=json['vchtype_parent'];//pratiksha p 05-12-2023 addvchtype
  }

  // komal // commented bcze party group api is removed added agewise api for all type
  // komal // new api added for group os
  // OutstandingRecPayEntity.fromGroupOSJson(Map<String,dynamic> json) {
  //   _groupid = json['GROUP_ID'];
  //   _groupname = json['GROUP_NAME'];
  //   _amount = json['AMOUNT'];
  // }

  Map<String,dynamic> toMap(){
    var map = <String,dynamic>{};
    if(_id != null){
      // map['PARTYCODE'] = _id;    // komal // name changed bcze party api removed and agewise api added
      map['ID'] = _id;
    }
    if(_partyname != null){
      // map['PARTY_NAME'] = _partyname;    // komal // name changed bcze party api removed and agewise api added
      map['NAME'] = _partyname;
    }
    if(_pendingamount != null){
      map['PENDING_AMOUNT'] = _pendingamount;
    }
    if(_creditdays != null){
      map['CREDIT_DAYS'] = _creditdays;
    }
    if(_creditlimit != null){
      map['CREDIT_LIMIT'] = _creditlimit;
    }
    if(_due != null){
      map['DUE'] = _due;
    }
    if(_overdue != null){
      map['OVER_DUE'] = _overdue;
    }
    if(_billdate != null){
      map['BILL_DATE'] = _billdate;
    }
    if(_billno != null){
      map['BILL_NO'] = _billno;
    }
    if(_duedate != null){
      map['DUE_DATE'] = _duedate;
    }
    if(_type != null){
      map['TYPE'] = _type;
    }
    if(_nextfollowupdate != null){    // Komal D 16-12-2021
      map['NEXT_FOLLOWUP_DATE'] = _nextfollowupdate;
    }
    if(_billAmountControllerText != null){    // komal // 30-8-2022 // bill amount added in textfield of os bills list
      map['BILL_OS_AMOUNT'] = _billAmountControllerText;
    }
    return map;
  }
}