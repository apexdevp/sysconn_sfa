import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:sysconn_sfa/api/api_url.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/Utility/date_list_view.dart';
import 'package:sysconn_sfa/api/entity/company/categoty_type_enity.dart';
import 'package:sysconn_sfa/api/entity/company/company_profile_entity.dart';
import 'package:sysconn_sfa/api/entity/company/party_address_entity.dart';
import 'package:sysconn_sfa/api/entity/company/party_contact_entity.dart';
import 'package:sysconn_sfa/api/entity/company/party_contact_response_entity.dart';
import 'package:sysconn_sfa/api/entity/company/party_designation_entity.dart';
import 'package:sysconn_sfa/api/entity/company/persona_entity.dart';
import 'package:sysconn_sfa/api/entity/sales/retailer_complaint_entity.dart';
import 'package:sysconn_sfa/api/entity/sales/unbilled_item_entity.dart';
import 'package:sysconn_sfa/api/entity/taskboard/audit_log_model.dart';
import 'package:sysconn_sfa/api/entity/taskboard/sales_task_dropdown_model.dart';
import 'package:sysconn_sfa/api/entity/taskboard/support_task_dropdown_model.dart';
import 'package:sysconn_sfa/api/entity/taskboard/task_bizopportunities_dropdown_entity.dart';
import 'package:sysconn_sfa/api/entity/taskboard/taskboard_report_entity.dart';
import 'package:sysconn_sfa/api/entity/user/userentity.dart';
import 'package:sysconn_sfa/api/entity/login/loginentity.dart';
import 'package:sysconn_sfa/api/entity/company/partyentity.dart';
import 'package:sysconn_sfa/api/entity/company/companyentity.dart';
import 'package:sysconn_sfa/api/entity/company/ledger_entity.dart';
import 'package:sysconn_sfa/api/entity/company/voucherentity.dart';
import 'package:sysconn_sfa/api/entity/company/pricelistentity.dart';
import 'package:sysconn_sfa/api/entity/target_vs_actual_entity.dart';
import 'package:sysconn_sfa/api/entity/buddy/beatwiselistentity.dart';
import 'package:sysconn_sfa/api/entity/company/stock_item_entity.dart';
import 'package:sysconn_sfa/api/entity/sales/sales_ledger_entity.dart';
import 'package:sysconn_sfa/api/entity/buddy/customerdetailsentity.dart';
import 'package:sysconn_sfa/api/entity/buddy/visitAttendanceEntity.dart';
import 'package:sysconn_sfa/api/entity/company/group_master_entity.dart';
import 'package:sysconn_sfa/api/entity/expense/adv_expenses_entity.dart';
import 'package:sysconn_sfa/api/entity/buddy/lead/leaddetailsentity.dart';
import 'package:sysconn_sfa/api/entity/company/godown_master_entity.dart';
import 'package:sysconn_sfa/api/entity/sales/sales_dashboard_entity.dart';
import 'package:sysconn_sfa/api/entity/expense/expense_header_entity.dart';
import 'package:sysconn_sfa/api/entity/expense/expense_ledger_entity.dart';
import 'package:sysconn_sfa/api/entity/order/sales_order_cart_entity.dart';
import 'package:sysconn_sfa/api/entity/expense/expenses_report_entity.dart';
import 'package:sysconn_sfa/api/entity/buddy/sales/sales_header_entity.dart';
import 'package:sysconn_sfa/api/entity/expense/expense_document_entity.dart';
import 'package:sysconn_sfa/api/entity/order/sales_order_header_entity.dart';
import 'package:sysconn_sfa/api/entity/order/sales_order_report_entity.dart';
import 'package:sysconn_sfa/api/entity/sales/sales_register_rep_entity.dart';
import 'package:sysconn_sfa/api/entity/buddy/beatwisecustomerlistentity.dart';
import 'package:sysconn_sfa/api/entity/sales/sales_weekly_report_entity.dart';
import 'package:sysconn_sfa/api/entity/sales/sales_monthly_report_entity.dart';
import 'package:sysconn_sfa/api/entity/buddy/expenses/adv_expenses_entity.dart';
import 'package:sysconn_sfa/api/entity/buddy/expenses/notification_entity.dart';
import 'package:sysconn_sfa/api/entity/buddy/sales/dailyperformanceentity.dart';
import 'package:sysconn_sfa/api/entity/buddy/sales/inactivecustomerentity.dart';
import 'package:sysconn_sfa/api/entity/buddy/sales/sales_inventory_entity.dart';
import 'package:sysconn_sfa/api/entity/company/filtertypecustcategorylist.dart';
import 'package:sysconn_sfa/api/entity/buddy/expenses/expense_header_entity.dart';
import 'package:sysconn_sfa/api/entity/buddy/expenses/expense_ledger_entity.dart';
import 'package:sysconn_sfa/api/entity/buddy/retailercomplaintrequestEntity.dart';
import 'package:sysconn_sfa/api/entity/buddy/collection/receiptheader_entity.dart';
import 'package:sysconn_sfa/api/entity/buddy/collection/receipt_header_entity.dart';
import 'package:sysconn_sfa/api/entity/buddy/outstanding/os_ageing_sum_entity.dart';
import 'package:sysconn_sfa/api/entity/buddy/outstanding/os_receivable_entity.dart';
import 'package:sysconn_sfa/api/entity/buddy/outstanding/paymentfollowupentity.dart';
import 'package:sysconn_sfa/api/entity/buddy/closing_stock/pendingclosingstockentity.dart';

class ApiCall {
  //==================//////////////company///////=====================================

  static Future<int> getCompanyDataAPI() async {
    var companyUrl =
        '${ApiUrl.cmpMasterUrl}company_id=${Utility.companyId}&mobile_no=${Utility.cmpmobileno}&db_nm=${Utility.sysDbName}'; //Rupali 17-11-2025// partner_code=${Utility.partnerCode}&
    if (kDebugMode) {
      print(companyUrl);
    }
    try {
      var companyResponse = await http.get(
        Uri.parse(companyUrl),
        headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      );
      if (companyResponse.statusCode == 200) {
        var companyData = await convert.jsonDecode(
          companyResponse.body,
        )['data'];
        Utility.companyMasterEntity = CompanyEntity.companyMasterMap(
          companyData[0],
        );
        Utility.partyId = CompanyEntity.companyMasterMap(
          companyData[0],
        ).partyId!;
        Utility.vchTypeCode = CompanyEntity.companyMasterMap(
          companyData[0],
        ).soVchTypeCode!;
        //Utility.isDelNoteEnable = CompanyEntity.companyMasterMap(companyData[0]).soEnableDelNote== '1' ? true : false;
        Utility.rateType = CompanyEntity.companyMasterMap(
          companyData[0],
        ).soRateType!;
        //print('Utility.companyMasterEntity ${Utility.companyMasterEntity.toMap()}');
      }
    } catch (ex) {
      //print(ex);
    }
    return 1;
  }

static Future<List<CompanyProfileEntity>> getCompanyProfileAPI() async {
  List<CompanyProfileEntity> list = [];

  var url =
      '${ApiUrl.companyProfileUrl}company_id=${Utility.companyId}&party_id=${Utility.customerPersonaId}&db_nm=${Utility.sysDbName}';

  if (kDebugMode) {
    print(url);
  }
  final response = await http.get(
    Uri.parse(url),
    headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken ),
  );

  if (response.statusCode == 200) {
    List data = convert.jsonDecode(response.body)['data'];

    if (data.isNotEmpty) {
      for (int i = 0; i < data.length; i++) {
        CompanyProfileEntity entity =
            CompanyProfileEntity.fromMap(data[i]);

        list.add(entity);

        print('CompanyProfile ${data[i]}');
      }
    }
  }

  return list;
}

static Future<List<CategoryTypeCategoryEntity>>
  getCustCategoriesHierarchyAPI({required String categorytypeId}) async {
    List<CategoryTypeCategoryEntity> categoryEntityList = [];
    var url =
        '${ApiUrl.allcategorytypeUrl2}company_id=${Utility.companyId}&categorytypeid=$categorytypeId&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(url);
    }
    var response = await http.get(
      Uri.parse(url),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (response.statusCode == 200) {
      var categoryData = await convert.jsonDecode(response.body)['data'];

      if (categoryData != null && categoryData.isNotEmpty) {
        for (int i = 0; i < categoryData.length; i++) {
          CategoryTypeCategoryEntity categoryEntity =
              CategoryTypeCategoryEntity.fromMap(categoryData[i]);

          categoryEntityList.add(categoryEntity);
        }
      }
    }

    return categoryEntityList;
  }
 static Future<List<Personacategory>> getCustomerPersonaAPI({
    required String companyId,
    required String retailerCode,
  }) async {
    List<Personacategory> personaList = [];

    var url =
        '${ApiUrl.allcategorytypeUrl1}COMPANY_ID=$companyId&RETAILER_CODE=$retailerCode&db_nm=${Utility.sysDbName}';

    if (kDebugMode) {
      print(url);
    }

    var response = await http.get(
      Uri.parse(url),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );

    if (response.statusCode == 200) {
      var data = convert.jsonDecode(response.body)['data'];

      if (data != null && data.isNotEmpty) {
        for (var item in data) {
          personaList.add(Personacategory.fromPersonaMap(item));
        }
      }
    }

    return personaList;
  }

static Future<PartyContactResponse> getPartyContactsDetAPI() async {
    final url =
        '${ApiUrl.partyContactsMasterUrl}company_id=${Utility.companyId}&retailer_code=${Utility.customerPersonaId}&db_nm=${Utility.sysDbName}';

    if (kDebugMode) {
      print(url);
    }

    final response = await http.get(
      Uri.parse(url),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );

    List<PartyContactEntity> contacts = [];
    List<PartyDesignationEntity> designations = [];

    if (response.statusCode == 200) {
      final decoded = convert.jsonDecode(response.body);
      final data = decoded['data'];

      /// CONTACT DETAILS (GRID)
      if (data['contactdetails'] != null) {
        contacts = (data['contactdetails'] as List)
            .map((e) => PartyContactEntity.formPartyMap(e))
            .toList();
      }

      /// DESIGNATION DROPDOWN
      if (data['designationdropdown'] != null) {
        designations = (data['designationdropdown'] as List)
            .map((e) => PartyDesignationEntity.formPartyDesignationMap(e))
            .toList();
      }
    }

    return PartyContactResponse(contacts: contacts, designations: designations);
  }

 static Future<List<PartyAddressEntity>> getPartyAddressesDetAPI() async {
    List<PartyAddressEntity> partyAddressesListData = [];
    var partyAddressesDetailsUrl =
        '${ApiUrl.partyAddressessUrl}company_id=${Utility.companyId}&retailer_code=${Utility.customerPersonaId}&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(partyAddressesDetailsUrl);
    }
    final partyAddressesResponse = await http.get(
      Uri.parse(partyAddressesDetailsUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (partyAddressesResponse.statusCode == 200) {
      List partyAddressesValue = convert.jsonDecode(
        partyAddressesResponse.body,
      )['data'];
      if (partyAddressesValue.isNotEmpty) {
        for (int i = 0; i < partyAddressesValue.length; i++) {
          PartyAddressEntity partyAddressEntity = PartyAddressEntity.fromMap(
            partyAddressesValue[i],
          );

          partyAddressesListData.add(partyAddressEntity);
          // }
          print('partyAddressesListData ${partyAddressesValue[i]}');
        }
      }
    }
    return partyAddressesListData;
  }

  // static Future<List<PartyEntity>> getPartyDetCMPApi({
  //   String partyId = '',
  //   String partyGroup = '',
  // }) async {
  //   List<PartyEntity> partyListData = [];
  //   var partyDetailsUrl =
  //       '${ApiUrl.partyMasterUrl}company_id=${Utility.companyId}&party_id=$partyId&party_type=$partyGroup&db_nm=${Utility.sysDbName}';
  //   if (kDebugMode) {
  //     print('partyDetailsUrl:$partyDetailsUrl');
  //   }
  //   final partyDtlReponse = await http.get(
  //     Uri.parse(partyDetailsUrl),
  //     headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
  //   );
  //   if (partyDtlReponse.statusCode == 200) {
  //     List partyDtlValue = convert.jsonDecode(partyDtlReponse.body)['data'];
  //     if (partyDtlValue.isNotEmpty) {
  //       for (int i = 0; i < partyDtlValue.length; i++) {
  //         PartyEntity partyEntity = PartyEntity.formPartyMap(partyDtlValue[i]);
  //         partyListData.add(partyEntity);
  //       }
  //     }
  //   }
  //   return partyListData;
  // }

  static Future<List<PartyEntity>> getPartyDetCMPApi({
    String partyId = '',
    String partyType = '',
  }) async {
    List<PartyEntity> partyListData = [];
    var partyDetailsUrl =
        '${ApiUrl.partyMasterUrl}company_id=${Utility.companyId}&party_id=$partyId&party_type=$partyType&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(partyDetailsUrl);
    }
    final partyDtlReponse = await http.get(
      Uri.parse(partyDetailsUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (partyDtlReponse.statusCode == 200) {
      List partyDtlValue = convert.jsonDecode(partyDtlReponse.body)['data'];
      if (partyDtlValue.isNotEmpty) {
        for (int i = 0; i < partyDtlValue.length; i++) {
          PartyEntity partyEntity = PartyEntity.formPartyMap(partyDtlValue[i]);
          // if(partyId != ''){
          //   Utility.partyDetailsEntity = partyEntity;
          // }else{
          partyListData.add(partyEntity);
          // }
          print('partyListData ${partyDtlValue[i]}');
        }
      }
    }
    return partyListData;
  }

  static Future<List<CompanyEntity>> getAllCompanyDetApi() async {
    List<CompanyEntity> allCmpDtlList = [];
    var allCompanyUrl =
        '${ApiUrl.cmpListUrl}db_nm=${Utility.sysDbName}'; //Rupali 17-11-2025
    //'${ApiUrl.cmpListUrl}email_id=${Utility.useremailid}&db_nm=${Utility.sysDbName}';  //Rupali 17-11-2025
    if (kDebugMode) {
      print(allCompanyUrl);
    }
    var allCmpReponse = await http
        .get(
          Uri.parse(allCompanyUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    //final allCmpReponse = await http.get(Uri.parse(allCompanyUrl));
    if (allCmpReponse.statusCode == 200) {
      List allCmpDtlValue = convert.jsonDecode(allCmpReponse.body)['data'];
      if (allCmpDtlValue.isNotEmpty) {
        for (int i = 0; i < allCmpDtlValue.length; i++) {
          CompanyEntity companyEntity = CompanyEntity.formMap(
            allCmpDtlValue[i],
          );
          allCmpDtlList.add(companyEntity);
        }
      }
    }
    return allCmpDtlList;
  }


  static Future<List<LedgerMasterEntity>> getLedgerDetCMPApi({
    String ledgerId = '',
    String ledgerType = '',
  }) async {
    List<LedgerMasterEntity> ledgerListData = [];
    var ledgerDetailsUrl =
        '${ApiUrl.ledgerMasterUrl}company_id=${Utility.companyId}&type=$ledgerType&ledger_id=$ledgerId&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print('ledgerDetailsUrl:$ledgerDetailsUrl');
    }
    final ledgerDtlReponse = await http.get(
      Uri.parse(ledgerDetailsUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (ledgerDtlReponse.statusCode == 200) {
      List ledgerDtlValue = convert.jsonDecode(ledgerDtlReponse.body)['data'];
      if (ledgerDtlValue.isNotEmpty) {
        for (int i = 0; i < ledgerDtlValue.length; i++) {
          LedgerMasterEntity ledgerEntity = LedgerMasterEntity.formMap(
            ledgerDtlValue[i],
          );
          ledgerListData.add(ledgerEntity);
        }
      }
      // print('ledgerListData $ledgerDtlValue');
    }
    return ledgerListData;
  }

  static Future<List<StockItemEntity>> itemListApi({
    required String itemName,
    required String date,
    required String pricelist,
  }) async {
    List<StockItemEntity> itemDataList = [];
    var itemUrl =
        '${ApiUrl.itemMasterListUrl}pageNumber=1&pageSize=10&type_parameter=$itemName&company_id=${Utility.companyId}'
        '&mobile_no=${Utility.cmpmobileno}&date=$date&pricelist=$pricelist&security_count=0&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(itemUrl);
    }
    final responsedata = await http
        .get(
          Uri.parse(itemUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (responsedata.statusCode == 200) {
      var responseVal = convert.jsonDecode(responsedata.body)['data'];
      if (responseVal.isNotEmpty) {
        for (int i = 0; i < responseVal.length; i++) {
          StockItemEntity stockItemEntity = StockItemEntity.fromMap(
            responseVal[i],
          );
          itemDataList.add(stockItemEntity);
        }
      }
    }
    return itemDataList;
  }

  static Future<List<GodownMasterEntity>> getGodownmasterApi({
    required String godown,
  }) async {
    List<GodownMasterEntity> godownMasterData = [];
    var getgodownReportUrl =
        '${ApiUrl.godownmasterUrl}&company_id=${Utility.companyId}&stock_godown_id=$godown&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print('Url:$getgodownReportUrl');
    }
    final getResponse = await http
        .get(
          Uri.parse(getgodownReportUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (getResponse.statusCode == 200) {
      List godownData = convert.jsonDecode(getResponse.body)['data'];
      if (godownData.isNotEmpty) {
        for (int i = 0; i < godownData.length; i++) {
          GodownMasterEntity groupmasterentity = GodownMasterEntity.formMap(
            godownData[i],
          );
          godownMasterData.add(groupmasterentity);
        }
      }
    }
    return godownMasterData;
  }

  //Rupali 18-12-2024
  static Future<List<FilterTypeCategoryListEntity>>
  getFilterTypeCatListEntityData(String? name, String? filtertype) async {
    List<FilterTypeCategoryListEntity> filterTypeCategorycustList = [];
    var selectedUrl =
        '${ApiUrl.getFilterCustListApiUrl}company_id=${Utility.companyId}&name=$name&filtertype=$filtertype&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(selectedUrl);
    }
    var response = await http
        .get(
          Uri.parse(selectedUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.logintoken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (response.statusCode == 200) {
      var selectedItem = convert.jsonDecode(response.body)['data'];
      if (selectedItem.isNotEmpty) {
        for (int i = 0; i < selectedItem.length; i++) {
          FilterTypeCategoryListEntity filterTypeCategoryListEntity =
              FilterTypeCategoryListEntity.fromMap(selectedItem[i]);
          //   if (Utility.partyDetailsEntity.pricelist != '') {
          filterTypeCategorycustList.add(filterTypeCategoryListEntity);
          // }
        }
      }
    }
    return filterTypeCategorycustList;
  }

  static Future<List<UserEntity>> getSalesPersonAPI({
    required String tlMobNo,
    required String userTypeList,
  }) async {
    List<UserEntity> salesPersonItem = [];
    var salesPersonUrl =
        '${ApiUrl.userlistGetUrl}company_id=${Utility.companyId}&tl_mobile_no=&user_type_list=&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(salesPersonUrl);
    }
    final salesPersonResponse = await http.get(
      Uri.parse(salesPersonUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (salesPersonResponse.statusCode == 200) {
      var salesPersonValue = convert.jsonDecode(
        salesPersonResponse.body,
      )['data'];
      if (salesPersonValue.isNotEmpty) {
        for (int i = 0; i < salesPersonValue.length; i++) {
          UserEntity salesPersonModel = UserEntity.fromMap(salesPersonValue[i]);
          salesPersonItem.add(salesPersonModel);
        }
      }
    }
    return salesPersonItem;
  }

  //////////////////////////////////////////////////////////////////////
  //Rupali 27-11-2024
  static Future<List<GroupMasterEntity>> getgroupmasterapi({
    required String groupid,
  }) async {
    List<GroupMasterEntity> groupEntityVal = [];
    var getgroupUrl =
        '${ApiUrl.groupmasterUrl}&company_id=${Utility.companyId}&group_id=$groupid&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print('getgroupUrl:$getgroupUrl');
    }
    final getResponse = await http
        .get(
          Uri.parse(getgroupUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (getResponse.statusCode == 200) {
      List ledgerdData = convert.jsonDecode(getResponse.body)['data'];
      if (ledgerdData.isNotEmpty) {
        for (int i = 0; i < ledgerdData.length; i++) {
          GroupMasterEntity groupmasterentity = GroupMasterEntity.formMap(
            ledgerdData[i],
          );
          groupEntityVal.add(groupmasterentity);
        }
      }
    }
    return groupEntityVal;
  }

  // static Future<List<VoucherEntity>> getVoucherTypeMasterAPI({String vchTypeCode = ''}) async {
  //   List<VoucherEntity> vchTypeList = [];
  //   var vouchertypeUrl ='${ApiUrl.vchTypeUrl}company_id=${Utility.companyId}&vchtype_code=$vchTypeCode&db_nm=${Utility.sysDbName}';
  //   if (kDebugMode) {
  //     print(vouchertypeUrl);
  //   }
  //   var vouchertypeResponse = await http.get(Uri.parse(vouchertypeUrl),headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken));
  //   if (vouchertypeResponse.statusCode == 200) {
  //     var vouchertypeData =await convert.jsonDecode(vouchertypeResponse.body)['data'];
  //     if (vouchertypeData.isNotEmpty) {
  //       for (int i = 0; i < vouchertypeData.length; i++) {
  //         VoucherEntity voucherentity =VoucherEntity.formMap(vouchertypeData[i]);
  //         vchTypeList.add(voucherentity);
  //       }
  //     }
  //   }
  //   return vchTypeList;
  // }

  static Future<List<VoucherEntity>> getVoucherTypeMasterAPI({
    String vchTypeCode = '',
  }) async {
    List<VoucherEntity> vchTypeList = [];
    var vouchertypeUrl =
        '${ApiUrl.vchTypeUrl}company_id=${Utility.companyId}&vchtype_code=$vchTypeCode&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(vouchertypeUrl);
    }
    var vouchertypeResponse = await http.get(
      Uri.parse(vouchertypeUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (vouchertypeResponse.statusCode == 200) {
      var vouchertypeData = await convert.jsonDecode(
        vouchertypeResponse.body,
      )['data'];
      if (vouchertypeData.isNotEmpty) {
        for (int i = 0; i < vouchertypeData.length; i++) {
          VoucherEntity voucherentity = VoucherEntity.formMap(
            vouchertypeData[i],
          );
          vchTypeList.add(voucherentity);
        }
      }
    }
    return vchTypeList;
  }
   static Future<List<LedgerMasterEntity>> getledgermasterapi({
    required String typedata,
    required String ledgerid,
    String status = '',   // Sakshi 26/03/2026
  }) async {
    List<LedgerMasterEntity> ledgerEntityVal = [];
    var getledgerUrl =
       
       '${ApiUrl.ledgerMstGetUrl}&company_id=${Utility.companyId}&type=$typedata&ledger_id=$ledgerid&status=$status&DB_NM=${Utility.sysDbName}';
    if (kDebugMode) {
      print('getledgerUrl:$getledgerUrl');
    }
    final getResponse = await http
        .get(
          Uri.parse(getledgerUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (getResponse.statusCode == 200) {
      List ledgerdData = convert.jsonDecode(getResponse.body)['data'];
      if (ledgerdData.isNotEmpty) {
        for (int i = 0; i < ledgerdData.length; i++) {
          LedgerMasterEntity ledgermasterentity = LedgerMasterEntity.formMap(
            ledgerdData[i],
          );
          ledgerEntityVal.add(ledgermasterentity);
        }
      }
    }
    return ledgerEntityVal;
  }


  static Future<List<StockItemEntity>> getStockItemDetApi() async {
    List<StockItemEntity> itemEntityList = [];
    var stockitemUrl =
        '${ApiUrl.itemMasterUrl}company_id=${Utility.companyId}&mobile_no=${Utility.cmpmobileno}&db_nm=${Utility.sysDbName}&security_count=0'; // &partner_code=${Utility.partnerCode}
    if (kDebugMode) {
      print(stockitemUrl);
    }
    var stockitemResponse = await http.get(
      Uri.parse(stockitemUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (stockitemResponse.statusCode == 200) {
      var stockitemData = await convert.jsonDecode(
        stockitemResponse.body,
      )['data'];
      if (stockitemData.isNotEmpty) {
        for (int i = 0; i < stockitemData.length; i++) {
          StockItemEntity stockItemEntity = StockItemEntity.fromMap(
            stockitemData[i],
          );
          itemEntityList.add(stockItemEntity);
        }
      }
    }
    return itemEntityList;
  }

  static Future<List<PriceListEntity>> getpricelistApi() async {
    List<PriceListEntity> priceLevelList = [];
    var selectedUrl =
        '${ApiUrl.priceList}company_id=${Utility.companyId}&pricelist=&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(selectedUrl);
    }
    var response = await http
        .get(
          Uri.parse(selectedUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.logintoken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (response.statusCode == 200) {
      var selectedItem = convert.jsonDecode(response.body)['data'];
      if (selectedItem.isNotEmpty) {
        for (int i = 0; i < selectedItem.length; i++) {
          PriceListEntity pricelistentity = PriceListEntity.fromMap(
            selectedItem[i],
          );
          priceLevelList.add(pricelistentity);
        }
      }
    }
    return priceLevelList;
  }

  /////=======================/////lead ///=======================//////

  static Future<List<LeadDetailsEntity>> getLeadListApiData(
    String? fromdate,
    String? todate,
    String usertype,
  ) async {
    List<LeadDetailsEntity> leadList = [];
    var selectedUrl =
        '${ApiUrl.getleadListApiUrl}company_id=${Utility.companyId}&mobile_no=${Utility.cmpmobileno}&user_type=$usertype&from_date=$fromdate&to_date=$fromdate&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(selectedUrl);
    }
    var response = await http
        .get(
          Uri.parse(selectedUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (response.statusCode == 200) {
      var selectedlist = convert.jsonDecode(response.body)['data'];
      if (selectedlist.isNotEmpty) {
        for (int i = 0; i < selectedlist.length; i++) {
          LeadDetailsEntity leadcustlistentity = LeadDetailsEntity.fromJson(
            selectedlist[i],
          );
          leadList.add(leadcustlistentity);
        }
      }
    }
    return leadList;
  }

  /////////////////////////////buddy///////////////////////////////////////

  //pratiksha p 07-10-2024 add this
  // static Future<PaymentFollowupEntity?> getlastPaymentFollowup({
  //   required String partyid,
  // }) async {
  //   PaymentFollowupEntity? purchaseHedEntity;
  //   var followupUrl =
  //       '${ApiUrl.getpaymentfollowuplast}company_id=${Utility.companyId}&party_id=$partyid&db_nm=${Utility.sysDbName}';
  //   if (kDebugMode) {
  //     print(followupUrl);
  //   }
  //   var paymentFollowupStatusResponse = await http
  //       .get(
  //         Uri.parse(followupUrl),
  //         headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
  //       )
  //       .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
  //   if (paymentFollowupStatusResponse.statusCode == 200) {
  //     var issueValue = convert.jsonDecode(
  //       paymentFollowupStatusResponse.body,
  //     )['data'];
  //     if (issueValue.isNotEmpty) {
  //       purchaseHedEntity = PaymentFollowupEntity.fromJson(issueValue[0]);
  //     }
  //   }
  //   return purchaseHedEntity;
  // }

  //komal D added 23-11-2024
  static Future<List<PartyEntity>> getLedgerDetCMPDataApi({
    String ledgerId = '',
    String ledgerType = '',
  }) async {
    List<PartyEntity> ledgerListData = [];
    var ledgerDetailsUrl =
        '${ApiUrl.ledgerMasterUrl}company_id=${Utility.companyId}&type=$ledgerType&ledger_id=$ledgerId&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(ledgerDetailsUrl);
    }
    final ledgerDtlReponse = await http.get(
      Uri.parse(ledgerDetailsUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (ledgerDtlReponse.statusCode == 200) {
      List ledgerDtlValue = convert.jsonDecode(ledgerDtlReponse.body)['data'];
      if (ledgerDtlValue.isNotEmpty) {
        for (int i = 0; i < ledgerDtlValue.length; i++) {
          PartyEntity ledgerEntity = PartyEntity.formPartyMap(
            ledgerDtlValue[i],
          );
          ledgerListData.add(ledgerEntity);
        }
      }
      // print('ledgerListData $ledgerDtlValue');
    }
    return ledgerListData;
  }

  //komal D 09-11-2024 added
  static Future<List<MonthlySalesEntity>> getSalesMonthlyPartyWiseRep({
    required DateTime fromDate,
    required DateTime toDate,
    required String type,
    required String reportbasis,
    required String salesPersonId,
    required String id,
    required String stockItemList,
    required String typeSelected,
  }) async {
    List<MonthlySalesEntity> partyWiseEntityList = [];
    var salesMonthlyPartyWiseRepUrl =
        'https://staff_komal_dhage.dms-systemxs.com/API/PartyWise_Monthly_Sales_Report/GetPartyWiseSalesMonthlyData?company_id=${Utility.companyId}&from_date=$fromDate&to_date=$toDate&type=$type&report_basis=$reportbasis&sales_person=$salesPersonId&id=$id&stock_item_list=$stockItemList&type_selected=$typeSelected&db_nm=SystemXS'; // &partner_code=${Utility.partnerCode}
    if (kDebugMode) {
      print(salesMonthlyPartyWiseRepUrl);
    }
    var salesMonthlyPartyWiseRepResponse = await http.get(
      Uri.parse(salesMonthlyPartyWiseRepUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (salesMonthlyPartyWiseRepResponse.statusCode == 200) {
      var salesMonthlyPartyWiseRepData = await convert.jsonDecode(
        salesMonthlyPartyWiseRepResponse.body,
      )['data'];
      if (salesMonthlyPartyWiseRepData.isNotEmpty) {
        for (int i = 0; i < salesMonthlyPartyWiseRepData.length; i++) {
          MonthlySalesEntity salesMonthlyPartyWiseRepEntity =
              MonthlySalesEntity.fromJson(salesMonthlyPartyWiseRepData[i]);
          partyWiseEntityList.add(salesMonthlyPartyWiseRepEntity);
        }
      }
    }
    return partyWiseEntityList;
  }

  //komal D 09-11-2024 added
  static Future<List<WeeklySalesEntity>> getSalesWeeklyPartyWiseRep({
    required DateTime fromDate,
    required DateTime toDate,
    required String type,
    required String reportbasis,
    required String salesPersonId,
    required String id,
    required String stockItemList,
    required String typeSelected,
  }) async {
    List<WeeklySalesEntity> partyWiseEntityList = [];
    var salesWeeklyPartyWiseRepUrl =
        'https://staff_komal_dhage.dms-systemxs.com/API/PartyWise_Weekly_Sales_Report/GetPartyWiseSalesWeeklyData?company_id=${Utility.companyId}&from_date=$fromDate&to_date=$toDate&type=$type&report_basis=$reportbasis&sales_person=$salesPersonId&id=$id&stock_item_list=$stockItemList&type_selected=$typeSelected&db_nm=SystemXS'; // &partner_code=${Utility.partnerCode}
    if (kDebugMode) {
      print(salesWeeklyPartyWiseRepUrl);
    }
    var salesWeeklyPartyWiseRepResponse = await http.get(
      Uri.parse(salesWeeklyPartyWiseRepUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (salesWeeklyPartyWiseRepResponse.statusCode == 200) {
      var salesWeeklyPartyWiseRepData = await convert.jsonDecode(
        salesWeeklyPartyWiseRepResponse.body,
      )['data'];
      if (salesWeeklyPartyWiseRepData.isNotEmpty) {
        for (int i = 0; i < salesWeeklyPartyWiseRepData.length; i++) {
          WeeklySalesEntity salesWeeklyPartyWiseRepEntity =
              WeeklySalesEntity.fromJson(salesWeeklyPartyWiseRepData[i]);
          partyWiseEntityList.add(salesWeeklyPartyWiseRepEntity);
        }
      }
    }
    return partyWiseEntityList;
  }

  //komal D 10-10-2024 added
  static Future<List<MonthlySalesEntity>> getSalesMonthlyRep({
    required DateTime fromDate,
    required DateTime toDate,
    required String type,
    required String reportbasis,
    required String salesPersonId,
    required String stockItemList,
    required String typeSelected,
  }) async {
    List<MonthlySalesEntity> itemEntityList = [];
    var salesMonthlyRepUrl =
        'https://dms-distributor-get.dms-systemxs.com/Sales/Sales_Monthly_Report/GetSalesMonthlyData?company_id=${Utility.companyId}&from_date=$fromDate&to_date=$toDate&type=$type&report_basis=$reportbasis&sales_person=$salesPersonId&stock_item_list=$stockItemList&type_selected=$typeSelected&db_nm=SystemXS'; // &partner_code=${Utility.partnerCode}
    if (kDebugMode) {
      print(salesMonthlyRepUrl);
    }
    var salesMonthlyRepResponse = await http.get(
      Uri.parse(salesMonthlyRepUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (salesMonthlyRepResponse.statusCode == 200) {
      var salesMonthlyRepData = await convert.jsonDecode(
        salesMonthlyRepResponse.body,
      )['data'];
      if (salesMonthlyRepData.isNotEmpty) {
        for (int i = 0; i < salesMonthlyRepData.length; i++) {
          MonthlySalesEntity salesMonthlyRepEntity =
              MonthlySalesEntity.fromJson(salesMonthlyRepData[i]);
          itemEntityList.add(salesMonthlyRepEntity);
        }
      }
    }
    return itemEntityList;
  }

  //komal D 23-11-2024
  static Future<List<SalesRegisterReportEntity>> getCollectionContraReportAPI({
    required String type,
    String? fromdate,
    String? todate,
  }) async {
    List<SalesRegisterReportEntity> collectionReportList = [];
    var collectionUrl =
        '${ApiUrl.collectionReport}company_id=${Utility.companyId}&from_date=$fromdate&to_date=$todate&type=$type&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(collectionUrl);
    }
    var collectionResponse = await http
        .get(
          Uri.parse(collectionUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (collectionResponse.statusCode == 200) {
      var collectionReportData = convert.jsonDecode(
        collectionResponse.body,
      )['data'];
      if (collectionReportData.isNotEmpty) {
        collectionReportList.clear();
        for (int i = 0; i < collectionReportData.length; i++) {
          collectionReportList.add(
            SalesRegisterReportEntity.fromJson(collectionReportData[i]),
          );
        }
      }
    }
    return collectionReportList;
  }

  ////////////pratiksha p 18-09-2024 add////////////////////////////////

  ////Rupali 30-09-2024
  static Future<List<Inactivecustomerlistentity>> getInactiveCApiData(
    String inactivesince,
  ) async {
    List<Inactivecustomerlistentity> unbillCustDataList = [];
    var selectedUrl =
        '${ApiUrl.getinactiveCustListUrl}company_id=${Utility.companyId}&inactive_since=$inactivesince&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(selectedUrl);
    }
    var response = await http
        .get(
          Uri.parse(selectedUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (response.statusCode == 200) {
      var selectedItem = convert.jsonDecode(response.body)['data'];
      if (selectedItem.isNotEmpty) {
        for (int i = 0; i < selectedItem.length; i++) {
          Inactivecustomerlistentity inactivecustomerlistentity =
              Inactivecustomerlistentity.fromJson(selectedItem[i]);
          unbillCustDataList.add(inactivecustomerlistentity);
        }
      }
    }
    return unbillCustDataList;
  }

  ////Rupali 30-09-2024
  static Future<List<Inactivecustomerlistentity>> getInactiveItmApiData(
    String inactivesince,
  ) async {
    List<Inactivecustomerlistentity> unbillItemDataList = [];
    var selectedUrl =
        '${ApiUrl.getinactiveItmListUrl}company_id=${Utility.companyId}&inactive_since=$inactivesince&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(selectedUrl);
    }
    var response = await http
        .get(
          Uri.parse(selectedUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (response.statusCode == 200) {
      var selectedItem = convert.jsonDecode(response.body)['data'];
      if (selectedItem.isNotEmpty) {
        for (int i = 0; i < selectedItem.length; i++) {
          Inactivecustomerlistentity inactivecustomerlistentity =
              Inactivecustomerlistentity.fromJson(selectedItem[i]);
          unbillItemDataList.add(inactivecustomerlistentity);
        }
      }
    }
    return unbillItemDataList;
  }

  //Rupali 19-10-2024
  static Future<List<PendingClosingStockEntity>>
  getpendingClosingStockDataApi() async {
    List<PendingClosingStockEntity> pendingclosingStockDataList = []; //
    var getpendingClosingStockUrl =
        '${ApiUrl.getpendingClosingStockUrl}company_id=${Utility.companyId}&db_nm=${Utility.sysDbName}&security_count=0&mobile_no=${Utility.cmpmobileno}';
    if (kDebugMode) {
      print(getpendingClosingStockUrl);
    }
    final pendingClosingStockDtlReponse = await http.get(
      Uri.parse(getpendingClosingStockUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (pendingClosingStockDtlReponse.statusCode == 200) {
      List pendingClosingStockDtlValue = convert.jsonDecode(
        pendingClosingStockDtlReponse.body,
      )['Data'];
      if (pendingClosingStockDtlValue.isNotEmpty) {
        for (int i = 0; i < pendingClosingStockDtlValue.length; i++) {
          PendingClosingStockEntity pendingClosingStockEntity =
              PendingClosingStockEntity.fromJson(
                pendingClosingStockDtlValue[i],
              );
          pendingclosingStockDataList.add(pendingClosingStockEntity);
        }
      }
    }
    return pendingclosingStockDataList;
  }

  //==================////////////////sales/////////////=====================================
  static Future<List<SalesDashboardEntity>> getSalesMasterWiseAPI({
    String? voucherType,
    String? idvalue,
    String? type,
    required fromdate,
    required todate,
  }) async {
    List<SalesDashboardEntity> salesMasterValue = [];
    var salesmasterUrl =
        '${ApiUrl.salesMasterWise}from_date=$fromdate&to_date=$todate&mobile_no=${Utility.cmpmobileno}&db_nm=${Utility.sysDbName}&vouchertype=$voucherType&security_count=0&id=$idvalue&type=$type&company_id=${Utility.companyId}';
    if (kDebugMode) {
      print('salesmasterUrl:$salesmasterUrl');
    }
    var salesmasterResponse = await http
        .get(
          Uri.parse(salesmasterUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (salesmasterResponse.statusCode == 200) {
      var salesmasterData = convert.jsonDecode(
        salesmasterResponse.body,
      )['data'];
      if (salesmasterData.isNotEmpty) {
        for (int i = 0; i < salesmasterData.length; i++) {
          SalesDashboardEntity salesDashboardEntity =
              SalesDashboardEntity.fromJson(salesmasterData[i]);
          salesMasterValue.add(salesDashboardEntity);
        }
      }
    }
    return salesMasterValue;
  }

  //pooja 12-10-2024 // add top ten analysis sales dashboard api
  static Future<List<SalesDashboardEntity>> getTopTenDashboardapi({
    required String fromdate,
    required String todate,
    required String typedata,
    required String voucherType,
    required int topRows,
  }) async {
    List<SalesDashboardEntity> salestoptenVal = [];
    var getTopTenUrl =
        '${ApiUrl.getTopTenDashboardurl}from_date=$fromdate&to_date=$todate&company_id=${Utility.companyId}&type=$typedata&mobile_no=${Utility.cmpmobileno}&db_nm=${Utility.sysDbName}&vouchertype=$voucherType&top_rows=$topRows';
    if (kDebugMode) {
      print('getTopTenUrl:$getTopTenUrl');
    }
    final getResponse = await http
        .get(
          Uri.parse(getTopTenUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (getResponse.statusCode == 200) {
      List graphData = convert.jsonDecode(getResponse.body)['data'];
      if (graphData.isNotEmpty) {
        for (int i = 0; i < graphData.length; i++) {
          salestoptenVal.add(SalesDashboardEntity.fromJson(graphData[i]));
        }
      }
    }
    return salestoptenVal;
  }

  //pooja // 08-10-2024 // add sales summary api
  static Future<List<SalesDashboardEntity>> getsalesDashboardapi({
    required String fromdate,
    required String todate,
    required String voucherType,
    required String type,
  }) async {
    List<SalesDashboardEntity> salesdashboardEntityVal = [];
    var getDashboardUrl =
        '${ApiUrl.getSalesdashboard}from_date=$fromdate&to_date=$todate&company_id=${Utility.companyId}&type=$type&mobile_no=${Utility.cmpmobileno}&vouchertype=$voucherType&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print('getDashboardUrl:$getDashboardUrl');
    }
    final getResponse = await http
        .get(
          Uri.parse(getDashboardUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (getResponse.statusCode == 200) {
      List dashboardData = convert.jsonDecode(getResponse.body)['data'];
      if (dashboardData.isNotEmpty) {
        for (int i = 0; i < dashboardData.length; i++) {
          salesdashboardEntityVal.add(
            SalesDashboardEntity.fromJson(dashboardData[i]),
          );
        }
      }
    }
    return salesdashboardEntityVal;
  }

  static Future<List<SalesDashboardEntity>> getSalesBillsWiseAPI({
    required voucherType,
    String? id,
    String? type,
    required String fromdate,
    required String todate,
  }) async {
    List<SalesDashboardEntity> salesbillswiseValue = [];
    var salesbillsUrl =
        '${ApiUrl.salesbillswiseurl}from_date=$fromdate&to_date=$todate&company_id=${Utility.companyId}&type=$type&mobile_no=${Utility.cmpmobileno}&db_nm=${Utility.sysDbName}&vouchertype=$voucherType&id=$id&Security_Count=0';
    if (kDebugMode) {
      print('salesdetailsUrl:$salesbillsUrl');
    }
    var salesbillsResponse = await http
        .get(
          Uri.parse(salesbillsUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (salesbillsResponse.statusCode == 200) {
      var salesbillswiseData = convert.jsonDecode(
        salesbillsResponse.body,
      )['data'];
      if (salesbillswiseData.isNotEmpty) {
        for (int i = 0; i < salesbillswiseData.length; i++) {
          SalesDashboardEntity salesDashboardEntity =
              SalesDashboardEntity.fromJson(salesbillswiseData[i]);
          salesbillswiseValue.add(salesDashboardEntity);
        }
      }
    }
    return salesbillswiseValue;
  }

  //komal D 10-10-2024 added
  static Future<List<WeeklySalesEntity>> getSalesWeeklyRep({
    required String type,
    required String reportbasis,
    required String salesPersonId,
    required String stockItemList,
    required String typeSelected,
  }) async {
    List<WeeklySalesEntity> itemEntityList = [];
    var salesWeeklyRepUrl =
        'http://103.193.75.86:59861/API/Sales_Weekly_Report/GetSalesWeeklyData?company_id=${Utility.companyId}&from_date=${Utility.selectedFromDateOfDateController}&to_date=${Utility.selectedToDateOfDateController}&type=$type&report_basis=$reportbasis&sales_person=$salesPersonId&stock_item_list=$stockItemList&type_selected=$typeSelected&db_nm=SystemXS'; // &partner_code=${Utility.partnerCode}
    if (kDebugMode) {
      print(salesWeeklyRepUrl);
    }
    var salesWeeklyRepResponse = await http.get(
      Uri.parse(salesWeeklyRepUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (salesWeeklyRepResponse.statusCode == 200) {
      var salesWeeklyRepData = await convert.jsonDecode(
        salesWeeklyRepResponse.body,
      )['data'];
      if (salesWeeklyRepData.isNotEmpty) {
        for (int i = 0; i < salesWeeklyRepData.length; i++) {
          WeeklySalesEntity SalesWeeklyRepEntity = WeeklySalesEntity.fromJson(
            salesWeeklyRepData[i],
          );
          itemEntityList.add(SalesWeeklyRepEntity);
        }
      }
    }
    return itemEntityList;
  }

  static Future<List<OutstandingRecPayAgeSumEntity>> getOutstandingRecDataAPI({
    required String type,
    required String ageingBy,
    required String subType,
  }) async {
    List<OutstandingRecPayAgeSumEntity> outstandingSummaryList = [];
    var getOutstandingGraphUrl =
        // 'https://dms-distributor-get.dms-systemxs.com/Sales/Outstanding_Ageing_Summary/GetAllOutstandingData?company_id=M25&type=Receivable&ageing_by=ALL&sub_type=Party&db_nm=SystemXS';
        '${ApiUrl.osreceivableGet}company_id=${Utility.companyId}&type=$type&ageing_by=$ageingBy&sub_type=$subType&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(getOutstandingGraphUrl);
    }
    final getOutstandingGraphResponse = await http.get(
      Uri.parse(getOutstandingGraphUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (getOutstandingGraphResponse.statusCode == 200) {
      var getOutstandingGraphValue = convert.jsonDecode(
        getOutstandingGraphResponse.body,
      )['data'];
      if (getOutstandingGraphValue.isNotEmpty) {
        for (int i = 0; i < getOutstandingGraphValue.length; i++) {
          OutstandingRecPayAgeSumEntity outstandingRecPayEntity =
              OutstandingRecPayAgeSumEntity.fromJson(
                getOutstandingGraphValue[i],
              );
          outstandingSummaryList.add(outstandingRecPayEntity);
        }
      }
    }
    return outstandingSummaryList;
  }

  //pratiksha p 24-02-2025 add
  static Future<DailyPerformanceEntity> getSalesDailyPerformanceAPI({
    String? voucherType,
    String? idvalue,
    String? type,
    required fromdate,
    required todate,
  }) async {
    // List<DailyPerformanceEntity> dailyperformanceValue = [];
    DailyPerformanceEntity? dailyperformanceValue;
    var dailyPerformanceUrl =
        '${ApiUrl.getdailyPerformanceurl}company_id=${Utility.companyId}&mobile_no=${Utility.cmpmobileno}&db_nm=${Utility.sysDbName}&from_date=$fromdate&to_date=$todate';
    if (kDebugMode) {
      print('salesmasterUrl:$dailyPerformanceUrl');
    }
    var dailyResponse = await http
        .get(
          Uri.parse(dailyPerformanceUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (dailyResponse.statusCode == 200) {
      var dailymasterData = convert.jsonDecode(dailyResponse.body)['data'];
      if (dailymasterData.isNotEmpty) {
        for (int i = 0; i < dailymasterData.length; i++) {
          DailyPerformanceEntity dailyEntity = DailyPerformanceEntity.fromJson(
            dailymasterData[i],
          );
          dailyperformanceValue = dailyEntity;
          //  dailyperformanceValue.add(dailyEntity);
        }
      }
    }
    return dailyperformanceValue!;
  }

  static Future<List<PaymentFollowupEntity>> getpayfollowupAllDetailsApi(
    String fromDate,
    String toDate,
  ) async {
    List<PaymentFollowupEntity> paymentFollowupList = [];
    var payfollowupDataUrl =
        //  'https://dms-distributor-get.dms-systemxs.com/Sales/Payment_Followup_All_Details/paymentFollowupObj?company_id=M25&email_id=distributor@systemxs.com&from_date=2024-04-01&to_date=2025-03-31&db_nm=SystemXS';
        '${ApiUrl.paymentfollowupAllDetGet}company_id=${Utility.companyId}&email_id=${Utility.useremailid}&from_date=$fromDate&to_date=$toDate&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(payfollowupDataUrl);
    }
    final payfollowupResponse = await http.get(
      Uri.parse(payfollowupDataUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    // .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (payfollowupResponse.statusCode == 200) {
      List payfollowupValue = convert.jsonDecode(
        payfollowupResponse.body,
      )['data'];
      if (payfollowupValue.isNotEmpty) {
        for (int i = 0; i < payfollowupValue.length; i++) {
          PaymentFollowupEntity paymentFollowupEntity =
              PaymentFollowupEntity.fromJson(payfollowupValue[i]);
          paymentFollowupList.add(paymentFollowupEntity);
        }
      }
    }
    return paymentFollowupList;
  }

  static Future<List<OutstandingRecPayAgeSumEntity>> getossalespersonReportAPI({
    required String type,
    required String groupid,
    required String ageingby,
    required String subtype,
  }) async {
    List<OutstandingRecPayAgeSumEntity> outstandingReportList = [];
    var osvalUrl =
        '${ApiUrl.getosSalesPerson}company_id=${Utility.companyId}&group_id=$groupid&type=$type&ageing_by=$ageingby&sub_type=$subtype&Security_Count=0&mobile_no=${Utility.cmpmobileno}&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(osvalUrl);
    }
    var osResponse = await http
        .get(
          Uri.parse(osvalUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (osResponse.statusCode == 200) {
      var osReportData = convert.jsonDecode(osResponse.body)['data'];
      if (osReportData.isNotEmpty) {
        outstandingReportList.clear();
        for (int i = 0; i < osReportData.length; i++) {
          outstandingReportList.add(
            OutstandingRecPayAgeSumEntity.fromJson(osReportData[i]),
          );
          if (kDebugMode) {
            print('outstandingReportList $outstandingReportList');
          }
        }
      }
    }
    return outstandingReportList;
  }

  static Future<SalesHeaderEntity?> getSalesMasterDataAPI({
    required String uniqueId,
  }) async {
    SalesHeaderEntity? salesHedEntity;
    var issueDataUrl =
        '${ApiUrl.getAllSales}company_id=${Utility.companyId}&unique_id=$uniqueId&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(issueDataUrl);
    }
    final issueResponse = await http.get(
      Uri.parse(issueDataUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (issueResponse.statusCode == 200) {
      var issueValue = convert.jsonDecode(issueResponse.body)['data'];
      if (issueValue.isNotEmpty) {
        salesHedEntity = SalesHeaderEntity.fromALLJson(issueValue[0]);
      }
    }
    return salesHedEntity;
  }

  static Future<List<SalesRegisterReportEntity>> getSalesRegisterReport(
    String? fromdate,
    String? todate,
    String? partyid,
    String? vchtype,
  ) async {
    List<SalesRegisterReportEntity> salesRegisterReportValue = [];
    var salesRegisterRepUrl =
        '${ApiUrl.salesRegisterRpt}company_id=${Utility.companyId}&from_date=$fromdate&to_date=$todate&party_id=$partyid&vch_type=$vchtype&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print('salesRegisterRepUrl:$salesRegisterRepUrl');
    }
    var salesRegisterRepResponse = await http
        .get(
          Uri.parse(salesRegisterRepUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (salesRegisterRepResponse.statusCode == 200) {
      var salesRegisterRepData = convert.jsonDecode(
        salesRegisterRepResponse.body,
      )['data'];
      if (salesRegisterRepData.isNotEmpty) {
        for (int i = 0; i < salesRegisterRepData.length; i++) {
          salesRegisterReportValue.add(
            SalesRegisterReportEntity.fromJson(salesRegisterRepData[i]),
          );
        }
      }
    }
    return salesRegisterReportValue;
  }

  static Future<SalesLedgerEntity> getSalesLedgerAPI({
    required String masterId,
  }) async {
    SalesLedgerEntity salesLedgerEntity = SalesLedgerEntity();
    var ledgerUrl =
        '${ApiUrl.salesLedgerGetUrl}company_id=${Utility.companyId}&master_id=$masterId&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(ledgerUrl);
    }
    final salesLedgerResponse = await http.get(
      Uri.parse(ledgerUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (salesLedgerResponse.statusCode == 200) {
      var ledgerValue = convert.jsonDecode(salesLedgerResponse.body)['data'];
      if (ledgerValue.isNotEmpty) {
        for (int i = 0; i < ledgerValue.length; i++) {
          salesLedgerEntity = SalesLedgerEntity.fromJson(ledgerValue[i]);
        }
      }
    }
    return salesLedgerEntity;
  }

  static Future<SalesInventoryEntity> getSalesInventoryAPI() async {
    SalesInventoryEntity salesInventoryEntity = SalesInventoryEntity();
    var inventoryUrl =
        '${ApiUrl.salesInventoryGetUrl}company_id=${Utility.companyId}&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(inventoryUrl);
    }
    final salesInventoryResponse = await http.get(
      Uri.parse(inventoryUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (salesInventoryResponse.statusCode == 200) {
      var outRecValue = convert.jsonDecode(salesInventoryResponse.body)['data'];
      if (outRecValue.isNotEmpty) {
        for (int i = 0; i < outRecValue.length; i++) {
          salesInventoryEntity = SalesInventoryEntity.fromJson(outRecValue[i]);
        }
      }
    }
    return salesInventoryEntity;
  }

  //pooja // 23-11-2024
  static Future<List<OutstandingRecPayDetailEntity>> getOSBillsDataAPI({
    required String type,
    required String partyId,
  }) async {
    List<OutstandingRecPayDetailEntity> outstandingRecDashboardDataList = [];
    var outrecUrl =
        '${ApiUrl.osBillsGetUrl}company_id=${Utility.companyId}&type=$type&party_id=$partyId&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(outrecUrl);
    }
    final outrecResponse = await http.get(
      Uri.parse(outrecUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (outrecResponse.statusCode == 200) {
      var outRecValue = convert.jsonDecode(outrecResponse.body)['data'];
      if (outRecValue.isNotEmpty) {
        for (int i = 0; i < outRecValue.length; i++) {
          OutstandingRecPayDetailEntity outstandingRecPayDetailEntity =
              OutstandingRecPayDetailEntity.fromJson(outRecValue[i]);
          outstandingRecDashboardDataList.add(outstandingRecPayDetailEntity);
        }
      }
    }
    return outstandingRecDashboardDataList;
  }

  static Future<SalesHeaderEntity> getSalesheaderAPI({
    required String masterId,
  }) async {
    SalesHeaderEntity salesHeaderEntity = SalesHeaderEntity();
    var inventoryUrl =
        '${ApiUrl.salesHeaderGetUrl}company_id=${Utility.companyId}&master_id=$masterId&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(inventoryUrl);
    }
    final salesInventoryResponse = await http.get(
      Uri.parse(inventoryUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (salesInventoryResponse.statusCode == 200) {
      var outRecValue = convert.jsonDecode(salesInventoryResponse.body)['data'];
      if (outRecValue.isNotEmpty) {
        for (int i = 0; i < outRecValue.length; i++) {
          salesHeaderEntity = SalesHeaderEntity.fromJson(outRecValue[i]);
        }
      }
    }
    return salesHeaderEntity;
  }

  //pratiksha p 07-10-2024 add this
  static Future<List<PaymentFollowupEntity>> getPaymentFollowupList(
    String? partyid,
  ) async {
    List<PaymentFollowupEntity> paymentFollowupDataList = [];
    var followupStatusUrl =
        '${ApiUrl.getpaymentfollowup}company_id=${Utility.companyId}&party_id=$partyid&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(followupStatusUrl);
    }
    var paymentFollowupStatusResponse = await http
        .get(
          Uri.parse(followupStatusUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (paymentFollowupStatusResponse.statusCode == 200) {
      var paymentFollowupStatusValue = convert.jsonDecode(
        paymentFollowupStatusResponse.body,
      )['data'];
      if (paymentFollowupStatusValue.isNotEmpty) {
        for (int i = 0; i < paymentFollowupStatusValue.length; i++) {
          paymentFollowupDataList.add(
            PaymentFollowupEntity.fromJson(paymentFollowupStatusValue[i]),
          );
        }
      }
    }
    return paymentFollowupDataList;
  }

  //customer wise
  // static Future<List<BeatCustListGetEntity>> getBeatCustListData(
  //   String? filtertype,
  //   String? id,
  //   String? status,
  // ) async {
  //   List<BeatCustListGetEntity> beatcustList = [];
  //   var selectedUrl =
  //       '${ApiUrl.getBeatCustWiseListApiUrl}company_id=${Utility.companyId}&email_id=${Utility.useremailid}&id=$id&filtertype=$filtertype&status=$status&security_count=0&db_nm=${Utility.sysDbName}';
  //   if (kDebugMode) {
  //     print(selectedUrl);
  //   }
  //   var response = await http
  //       .get(
  //         Uri.parse(selectedUrl),
  //         headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
  //       )
  //       .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
  //   if (response.statusCode == 200) {
  //     var selectedItem = convert.jsonDecode(response.body)['data'];
  //     if (selectedItem.isNotEmpty) {
  //       for (int i = 0; i < selectedItem.length; i++) {
  //         BeatCustListGetEntity beatcustlistentity =
  //             BeatCustListGetEntity.fromJson(selectedItem[i]);
  //         beatcustList.add(beatcustlistentity);
  //       }
  //     }
  //   }
  //   return beatcustList;
  // }

  // static Future<List<CustomerDetailGetEntity>> getCustomerDetails(
  //   String partyid,
  // ) async {
  //   List<CustomerDetailGetEntity> custList = [];
  //   var customerUrl =
  //       '${ApiUrl.getCustListApiUrl}company_id=${Utility.companyId}&mobile_no=${Utility.cmpmobileno}&party_id=$partyid&db_nm=${Utility.sysDbName}';
  //   if (kDebugMode) {
  //     print(customerUrl);
  //   }
  //   var response = await http
  //       .get(
  //         Uri.parse(customerUrl),
  //         headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
  //       )
  //       .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
  //   if (response.statusCode == 200) {
  //     var selectedcustomer = convert.jsonDecode(response.body)['data'];
  //     if (selectedcustomer.isNotEmpty) {
  //       for (int i = 0; i < selectedcustomer.length; i++) {
  //         CustomerDetailGetEntity beatcustlistentity =
  //             CustomerDetailGetEntity.fromJson(selectedcustomer[i]);
  //         custList.add(beatcustlistentity);
  //       }
  //     }
  //   }
  //   return custList;
  // }

  static Future<List<BeatListEntity>> getBeatListApiData(
    String filterType,
  ) async {
    List<BeatListEntity> beatcustList = [];
    var selectedUrl =
        '${ApiUrl.getBeatCustListApiUrl}company_id=${Utility.companyId}&email_id=${Utility.useremailid}&filtertype=$filterType&security_count=0&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(selectedUrl);
    }
    var response = await http
        .get(
          Uri.parse(selectedUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (response.statusCode == 200) {
      var selectedItem = convert.jsonDecode(response.body)['data'];
      if (selectedItem.isNotEmpty) {
        for (int i = 0; i < selectedItem.length; i++) {
          BeatListEntity beatcustlistentity = BeatListEntity.fromJson(
            selectedItem[i],
          );
          beatcustList.add(beatcustlistentity);
        }
      }
    }
    return beatcustList;
  }

  //visit/////////////////

  // static Future<List<VisitAttendanceEntity>> getVisitAttendance(
  //   String partyid,
  // ) async {
  //   List<VisitAttendanceEntity> visitList = [];
  //   var customerUrl =
  //       '${ApiUrl.getvisitListApiUrl}company_id=${Utility.companyId}&from_date=&to_date=&party_id=$partyid&email_id=${Utility.useremailid}&db_nm=${Utility.sysDbName}';
  //   if (kDebugMode) {
  //     print(customerUrl);
  //   }
  //   var response = await http
  //       .get(
  //         Uri.parse(customerUrl),
  //         headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
  //       )
  //       .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
  //   if (response.statusCode == 200) {
  //     var selectedcustomer = convert.jsonDecode(response.body)['data'];
  //     if (selectedcustomer.isNotEmpty) {
  //       for (int i = 0; i < selectedcustomer.length; i++) {
  //         VisitAttendanceEntity beatcustlistentity =
  //             VisitAttendanceEntity.fromJson(selectedcustomer[i]);
  //         visitList.add(beatcustlistentity);
  //       }
  //     }
  //   }
  //   return visitList;
  // }

  //;pratiksha p 21-02-2025 add this
  static Future<List<VisitAttendanceEntity>> getVisitdata(
    String fromDate,
    String toDate,
  ) async {
    List<VisitAttendanceEntity> visitList = [];
    var customerUrl =
        '${ApiUrl.getvisitdetailApiUrl}company_id=${Utility.companyId}&email_id=${Utility.useremailid}&from_date=$fromDate&to_date=$toDate&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(customerUrl);
    }
    var response = await http
        .get(
          Uri.parse(customerUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (response.statusCode == 200) {
      var selectedcustomer = convert.jsonDecode(response.body)['data'];
      if (selectedcustomer.isNotEmpty) {
        for (int i = 0; i < selectedcustomer.length; i++) {
          VisitAttendanceEntity beatcustlistentity =
              VisitAttendanceEntity.fromJson(selectedcustomer[i]);
          visitList.add(beatcustlistentity);
        }
      }
    }
    return visitList;
  }

  //======================================================================================================================
  // collection

  // static Future<List<ReceiptHeaderEntity>> getCollectionReportAPI({
  //   required String type,
  //   String? fromdate,
  //   String? todate,
  //   String? partyid,
  // }) async {
  //   List<ReceiptHeaderEntity> collectionReportList = [];
  //   var collectionUrl =
  //       '${ApiUrl.collectionReport}company_id=${Utility.companyId}&from_date=$fromdate&to_date=$todate&type=$type&db_nm=${Utility.sysDbName}&party_id=$partyid';
  //   if (kDebugMode) {
  //     print(collectionUrl);
  //   }
  //   var collectionResponse = await http
  //       .get(
  //         Uri.parse(collectionUrl),
  //         headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
  //       )
  //       .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
  //   if (collectionResponse.statusCode == 200) {
  //     var collectionReportData = convert.jsonDecode(
  //       collectionResponse.body,
  //     )['data'];
  //     if (collectionReportData.isNotEmpty) {
  //       collectionReportList.clear();
  //       for (int i = 0; i < collectionReportData.length; i++) {
  //         collectionReportList.add(
  //           ReceiptHeaderEntity.fromJson(collectionReportData[i]),
  //         );
  //       }
  //     }
  //   }
  //   return collectionReportList;
  // }

 static Future<List<SalesRegisterReportEntity>> getCollectionReportAPI({
    required String type,
  }) async {
    List<SalesRegisterReportEntity> collectionReportList = [];
    var collectionUrl ='https://sysconnoms-get.sysconn.ai/Collection/Collection_Report/GetCollectionRegisterData?company_id=211225225411003&from_date=2025-04-01 00:00:00.000&to_date=2027-03-31 00:00:00.000&type=Receipt&db_nm=Sysconn_OMS';
        // '${ApiUrl.collectionReport}company_id=${Utility.companyId}&from_date=${Utility.selectedFromDateOfDateController}&to_date=${Utility.selectedToDateOfDateController}&type=$type&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(collectionUrl);
    }
    var collectionResponse = await http
        .get(
          Uri.parse(collectionUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (collectionResponse.statusCode == 200) {
      var collectionReportData = convert.jsonDecode(
        collectionResponse.body,
      )['data'];
      if (collectionReportData.isNotEmpty) {
        collectionReportList.clear();
        for (int i = 0; i < collectionReportData.length; i++) {
          collectionReportList.add(
            SalesRegisterReportEntity.fromJson(collectionReportData[i]),
          );
        }
      }
    }
    return collectionReportList;
  }
  
   static Future<ReceiptHeaderEntity?> geteditCollectionDetAPI({
    required String uniqueId,
  }) async {
    ReceiptHeaderEntity? salesHedEntity;
    var collectionDetUrl =
        '${ApiUrl.collectionMasterUrl}company_id=${Utility.companyId}&unique_id=$uniqueId&type=Receipt&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(collectionDetUrl);
    }
    final issueResponse = await http.get(
      Uri.parse(collectionDetUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (issueResponse.statusCode == 200) {
      var issueValue = convert.jsonDecode(issueResponse.body)['data'];
      if (issueValue.isNotEmpty) {
        salesHedEntity = ReceiptHeaderEntity.fromJson(issueValue[0]);
      }
    }
    return salesHedEntity;
  }

  // static Future<List<ReceiptHeaderEntity>> geteditCollectionDetAPI(
  //   String uniqueid, {
  //   required String type,
  // }) async {
  //   List<ReceiptHeaderEntity> collectionDetVal = [];
  //   var collectionDetUrl =
  //       '${ApiUrl.collectionMasterUrl}company_id=${Utility.companyId}&unique_id=$uniqueid&type=$type&db_nm=${Utility.sysDbName}';
  //   if (kDebugMode) {
  //     print(collectionDetUrl);
  //   }
  //   var collectionDetRes = await http
  //       .get(
  //         Uri.parse(collectionDetUrl),
  //         headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
  //       )
  //       .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
  //   if (collectionDetRes.statusCode == 200) {
  //     var collectionDetData = convert.jsonDecode(collectionDetRes.body)['data'];
  //     if (kDebugMode) {
  //       print('collectionDetData $collectionDetData');
  //     }
  //     if (collectionDetData.isNotEmpty) {
  //       for (int i = 0; i < collectionDetData.length; i++) {
  //         collectionDetVal.add(
  //           ReceiptHeaderEntity.fromJson(collectionDetData[i]),
  //         );
  //       }
  //     }
  //   }
  //   return collectionDetVal;
  // }

  static Future<List<ReceiptheaderEntity>> getReceiptReportAPI({
    required String type,
    String? fromdate,
    String? todate,
  }) async {
    List<ReceiptheaderEntity> collectionReportList = [];
    var collectionUrl =
        '${ApiUrl.collectionReport}company_id=${Utility.companyId}&from_date=$fromdate&to_date=$todate&type=$type&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(collectionUrl);
    }
    var collectionResponse = await http
        .get(
          Uri.parse(collectionUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (collectionResponse.statusCode == 200) {
      var collectionReportData = convert.jsonDecode(
        collectionResponse.body,
      )['data'];
      if (collectionReportData.isNotEmpty) {
        collectionReportList.clear();
        for (int i = 0; i < collectionReportData.length; i++) {
          collectionReportList.add(
            ReceiptheaderEntity.fromJson(collectionReportData[i]),
          );
        }
      }
    }
    return collectionReportList;
  }

  //snehal 22-11-2024 add for receipt
  static Future<List<ReceiptHeaderEntity>> getCollectionDetAPI(
    String uniqueid, {
    required String type,
  }) async {
    List<ReceiptHeaderEntity> collectionDetVal = [];
    var collectionDetUrl =
        '${ApiUrl.collectionMasterUrl}company_id=${Utility.companyId}&unique_id=$uniqueid&type=$type&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(collectionDetUrl);
    }
    var collectionDetRes = await http
        .get(
          Uri.parse(collectionDetUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (collectionDetRes.statusCode == 200) {
      var collectionDetData = convert.jsonDecode(collectionDetRes.body)['data'];
      if (kDebugMode) {
        print('collectionDetData $collectionDetData');
      }
      if (collectionDetData.isNotEmpty) {
        for (int i = 0; i < collectionDetData.length; i++) {
          collectionDetVal.add(
            ReceiptHeaderEntity.fromJson(collectionDetData[i]),
          );
          print('collectionDetData ${collectionDetVal[0].totalAmount}');
        }
      }
    }
    return collectionDetVal;
  }

  //======================================================================================================================

  // sales order

  static Future<List<SOAddToCartEntity>> getSOCartDetailsAPI(
    String hedUniqueId,
  ) async {
    List<SOAddToCartEntity> cartSODetList = [];
    var cartDetailsUrl =
        '${ApiUrl.soCartDataUrl}company_id=${Utility.companyId}&mobile_no=${Utility.cmpmobileno}&hed_unique_id=$hedUniqueId&db_nm=${Utility.sysDbName}'; //Rupali 17-11-2025// &partner_code=${Utility.partnerCode}
    if (kDebugMode) {
      print(cartDetailsUrl);
    }
    final cartDetailsResponse = await http.get(
      Uri.parse(cartDetailsUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (cartDetailsResponse.statusCode == 200) {
      var cartDetailsValue = convert.jsonDecode(
        cartDetailsResponse.body,
      )['data'];
      if (cartDetailsValue.isNotEmpty) {
        for (int i = 0; i < cartDetailsValue.length; i++) {
          SOAddToCartEntity cartEntity = SOAddToCartEntity.fromMap(
            cartDetailsValue[i],
          );
          cartSODetList.add(cartEntity);
        }
      }
    }
    return cartSODetList;
  }

  static Future<SalesOrderHeaderEntity> getSalesOrderPDFApi(
    String salesOrderID,
  ) async {
    SalesOrderHeaderEntity salesOrderHeaderEntity = SalesOrderHeaderEntity();
    var delivaryNoteUrl =
        '${ApiUrl.soPrintUrl}company_id=${Utility.companyId}&unique_id=$salesOrderID&db_nm=${Utility.sysDbName}'; //Rupali 17-11-2025// &partner_code=${Utility.partnerCode}
    if (kDebugMode) {
      print(delivaryNoteUrl);
    }
    final delivaryNoteResponse = await http.get(
      Uri.parse(delivaryNoteUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (delivaryNoteResponse.statusCode == 200) {
      var delivaryNoteData = convert.jsonDecode(
        delivaryNoteResponse.body,
      )['data'];
      if (kDebugMode) {
        print(delivaryNoteData);
      }
      salesOrderHeaderEntity = SalesOrderHeaderEntity.fromAllMap(
        delivaryNoteData[0],
      );
    }
    return salesOrderHeaderEntity;
  }

  static Future<List<SOReportEntity>> getSORegisterPartywiseAPI(
    String fromDate,
    String toDate,
    String parent,
  ) async {
    List<SOReportEntity> salesOrderWiseValue = [];
    var soRegisterUrl =
        '${ApiUrl.soPartyRegisterUrl}company_id=${Utility.companyId}&party_id=${Utility.partyId}&from_date=$fromDate&to_date=$toDate&parent=$parent&db_nm=${Utility.sysDbName}'; //Rupali 17-11-2025// &partner_code=${Utility.partnerCode}
    if (kDebugMode) {
      print(soRegisterUrl);
    }
    var soRegisterResponse = await http.get(
      Uri.parse(soRegisterUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (soRegisterResponse.statusCode == 200) {
      var soRegisterData = convert.jsonDecode(soRegisterResponse.body)['data'];
      if (soRegisterData.isNotEmpty) {
        for (int i = 0; i < soRegisterData.length; i++) {
          salesOrderWiseValue.add(SOReportEntity.fromMap(soRegisterData[i]));
        }
      }
    }
    return salesOrderWiseValue;
  }

  static Future<List<StockItemEntity>> getBrandDataAPI() async {
    List<StockItemEntity> brandList = [];
    var divisionUrl =
        '${ApiUrl.stkBrandUrl}company_id=${Utility.companyId}&db_nm=${Utility.sysDbName}'; // &partner_code=${Utility.partnerCode}
    if (kDebugMode) {
      print(divisionUrl);
    }
    final divisionResponse = await http.get(
      Uri.parse(divisionUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (divisionResponse.statusCode == 200) {
      brandList.clear();
      var divisionValue = convert.jsonDecode(divisionResponse.body)['data'];
      //print(divisionResponse.body.toString());
      if (divisionValue.isNotEmpty) {
        for (int i = 0; i < divisionValue.length; i++) {
          StockItemEntity brandListEntity = StockItemEntity.brandMap(
            divisionValue[i],
          );
          brandList.add(brandListEntity);
        }
      }
    }
    return brandList;
  }

  static Future<List<StockItemEntity>> getItemDataAPI(
    String? partyId,
    String itemName,
    String divisionIdSelected,
  ) async {
    List<StockItemEntity> soGetItemList = [];
    var soItemUrl =
        '${ApiUrl.soItemListUrl}company_id=${Utility.companyId}&brand=$divisionIdSelected&party_id=$partyId&issue_slip_no=&item_name=$itemName&db_nm=${Utility.sysDbName}'; // &partner_code=${Utility.partnerCode}
    if (kDebugMode) {
      print(soItemUrl);
    }
    final soItemResponse = await http.get(
      Uri.parse(soItemUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (soItemResponse.statusCode == 200) {
      soGetItemList.clear();
      var soItemValue = convert.jsonDecode(soItemResponse.body)['data'];
      if (soItemValue.isNotEmpty) {
        for (int i = 0; i < soItemValue.length; i++) {
          StockItemEntity soGetItemEntity = StockItemEntity.fromMap(
            soItemValue[i],
          );
          soGetItemList.add(soGetItemEntity);
        }
      }
    }
    return soGetItemList;
  }

  //

  // static Future<List<SOReportEntity>> getSalesOrderDetailsRegisterAPI(
  //   String fromdate,
  //   String todate,
  // ) async {
  //   List<SOReportEntity> salesOrderDetailsValue = [];
  //   String soDetRegisterUrl =
  //       '${ApiUrl.soDetailsReportUrl}company_id=${Utility.companyId}&mobile_no=${Utility.cmpmobileno}&from_date=$fromdate&to_date=$todate&db_nm=${Utility.sysDbName}';
  //   if (kDebugMode) {
  //     print(soDetRegisterUrl);
  //   }
  //   var salesOrderDetResponse = await http.get(
  //     Uri.parse(soDetRegisterUrl),
  //     headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
  //   );
  //   if (salesOrderDetResponse.statusCode == 200) {
  //     var soRegisterData = convert.jsonDecode(
  //       salesOrderDetResponse.body,
  //     )['data'];
  //     if (soRegisterData.isNotEmpty) {
  //       for (int i = 0; i < soRegisterData.length; i++) {
  //         salesOrderDetailsValue.add(SOReportEntity.fromMap(soRegisterData[i]));
  //       }
  //     }
  //   }
  //   return salesOrderDetailsValue;
  // }

  ////////////////////Sales///////////2026 add////////////
  static Future<PartyEntity?> getPartyDetailsApi({
    required String partyid,
  }) async {
    PartyEntity? partentity;
    String partyDetailsUrl =
        '${ApiUrl.partyMasterDetUrl}company_id=${Utility.companyId}&party_id=$partyid&party_type=Customer&db_nm=${Utility.sysDbName}';
    print("partyDetailsUrl: $partyDetailsUrl");

    try {
      final response = await http.get(
        Uri.parse(partyDetailsUrl),
        headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final partyData = convert.jsonDecode(response.body)['data'];
        partentity = PartyEntity.formPartyMap(partyData[0]);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception in partydetails: $e");
      }
    }
    return partentity!;
  }

  static Future<List<BeatListEntity>> getBeatListData(
    String status,
    String filterType,
  ) async {
    List<BeatListEntity> beatDataList = [];

    var beatUrl =
        '${ApiUrl.getBeatListApiUrl}company_id=${Utility.companyId}&&status=$status&filtertype=$filterType&db_nm=${Utility.sysDbName}';
    print(beatUrl);
    var response = await http
        .get(
          Uri.parse(beatUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    print(response.body);
    if (response.statusCode == 200) {
      var beatItem = convert.jsonDecode(response.body)['data'];
      if (beatItem.isNotEmpty) {
        for (int i = 0; i < beatItem.length; i++) {
          BeatListEntity beatentity = BeatListEntity.fromJson(beatItem[i]);
          beatDataList.add(beatentity);
        }
      }
    }
    return beatDataList;
  }

  static Future<List<BeatCustListGetEntity>> getBeatCustListData(
    String? filtertype,
    String? id,
    String? status,
  ) async {
    List<BeatCustListGetEntity> beatcustList = [];
    var customerlistUrl =
        '${ApiUrl.getBeatCustWiseListApiUrl}company_id=${Utility.companyId}&id=$id&filtertype=$filtertype&status=$status&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(customerlistUrl);
    }
    var response = await http
        .get(
          Uri.parse(customerlistUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (response.statusCode == 200) {
      var customerlistItem = convert.jsonDecode(response.body)['data'];
      if (customerlistItem.isNotEmpty) {
        for (int i = 0; i < customerlistItem.length; i++) {
          BeatCustListGetEntity beatcustlistentity =
              BeatCustListGetEntity.fromJson(customerlistItem[i]);
          beatcustList.add(beatcustlistentity);
        }
      }
    }
    return beatcustList;
  }

  static Future<List<CustomerDetailGetEntity>> getCustomerDetails(
    String partyid,
  ) async {
    List<CustomerDetailGetEntity> customerdetailsList = [];
    var customerUrl =
        '${ApiUrl.getCustomerDetailsApiUrl}company_id=${Utility.companyId}&party_id=$partyid&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(customerUrl);
    }
    var response = await http
        .get(
          Uri.parse(customerUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (response.statusCode == 200) {
      var selectedcustomer = convert.jsonDecode(response.body)['data'];
      if (selectedcustomer.isNotEmpty) {
        for (int i = 0; i < selectedcustomer.length; i++) {
          CustomerDetailGetEntity beatcustlistentity =
              CustomerDetailGetEntity.fromJson(selectedcustomer[i]);
          customerdetailsList.add(beatcustlistentity);
        }
      }
    }
    return customerdetailsList;
  }



  static Future<List<dynamic>> getosrecPayGraphAPI({
    required String ageby,
  }) async {
    List graphDataList = [];
    var outrecpaygraphUrl =
        '${ApiUrl.osDashUrl}company_id=${Utility.companyId}&sub_type=ALL&ageing_by=$ageby&db_nm=${Utility.sysDbName}';
    
    if (kDebugMode) {
      print('outrecpaygraphUrl:$outrecpaygraphUrl');
    }

    final osgraphData = await http.get(
      Uri.parse(outrecpaygraphUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    print(osgraphData.body);
    if (osgraphData.statusCode == 200) {
      List<dynamic> osDataListValue = convert.jsonDecode(
        osgraphData.body,
      )['data'];
      graphDataList = osDataListValue;
    }
    return graphDataList;
  }

  static Future<List<dynamic>> getOSRecPayDashDataAPI({
    required String ageby,

    required String subtype,
  }) async {
    try {
      final outrecpayUrl =
          '${ApiUrl.osDashUrl}company_id=${Utility.companyId}&sub_type=$subtype&ageing_by=$ageby&db_nm=${Utility.sysDbName}';
      // 'https://outstanding_ageing_summary_report.max2tally.com/API/OUTSTANDING_AGEING_SUMMARY_REPORT/GetAllOutstandingData?PARTNER_CODE=725073894&COMPANY_ID=b50a2eca-dea7-4b94-ad58-b0947e19a59a-10003&TYPE=Receivable&AGEING_BY=Due Date&SUB_TYPE=ALL&DB_NM=Max_001&Security_Count=0&MOBILE_NO=9820588577';

      if (kDebugMode) print(outrecpayUrl);

      final response = await http.get(
        Uri.parse(outrecpayUrl),
        headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded != null && decoded['data'] != null) {
          return List<dynamic>.from(decoded['data']);
        } else {
          return [];
        }
      } else {
        print("Unexpected Status: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("API Error: $e");
      return [];
    }
  }

  static Future<List<OutstandingRecPayAgeSumEntity>> getOsRecPayLedgerDataAPI({
    required String ageby,
    required String subtype,
  }) async {
    List<OutstandingRecPayAgeSumEntity> osDashboardDataList = [];
    var outrecpaygroupledgerUrl =
        '${ApiUrl.osRecPayLedgerUrl}company_id=${Utility.companyId}&sub_type=$subtype&ageing_by=$ageby&db_nm=${Utility.sysDbName}';

    if (kDebugMode) {
      print(outrecpaygroupledgerUrl);
    }

    final outrecpaygroupledgerResponse = await http.get(
      Uri.parse(outrecpaygroupledgerUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );

    if (outrecpaygroupledgerResponse.statusCode == 200) {
      var salesValue = convert.jsonDecode(
        outrecpaygroupledgerResponse.body,
      )['data'];
      if (salesValue.isNotEmpty) {
        for (int i = 0; i < salesValue.length; i++) {
          OutstandingRecPayAgeSumEntity outstandingRecPayDashboard =
              OutstandingRecPayAgeSumEntity.fromJson(salesValue[i]);
          osDashboardDataList.add(outstandingRecPayDashboard);
        }
      }
    }
    return osDashboardDataList;
  }

  static Future<PaymentFollowupEntity> getTodyfollowupapi(
    String fromdate,
  ) async {
    PaymentFollowupEntity paymentFollowupEntity = PaymentFollowupEntity();
    var todaysfollowupDataUrl =
        '${ApiUrl.gettodaysfollowupUrl}company_id=${Utility.companyId}&mobile_no=9876543210&date=$fromdate&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(todaysfollowupDataUrl);
    }
    final todaysfollowupResponse = await http.get(
      Uri.parse(todaysfollowupDataUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );

    if (todaysfollowupResponse.statusCode == 200) {
      List todaysfollowupValue = convert.jsonDecode(
        todaysfollowupResponse.body,
      )['data'];
      if (todaysfollowupValue.isNotEmpty) {
        paymentFollowupEntity = PaymentFollowupEntity.fromJson(
          todaysfollowupValue[0],
        );
      }
    }
    return paymentFollowupEntity;
  }

  static Future<List<dynamic>> getOsRecBillwiseDataAPI({
    required String partyId,
  }) async {
    List osrecbillDataList = [];
    var outrecpaybillUrl =
        '${ApiUrl.osRecPayBillUrl}company_id=${Utility.companyId}&party_code=$partyId&DB_NM=${Utility.sysDbName}';

    if (kDebugMode) {
      print('outrecpaybillUrl:$outrecpaybillUrl');
    }

    final osrecBillData = await http.get(
      Uri.parse(outrecpaybillUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    print(osrecBillData.body);
    if (osrecBillData.statusCode == 200) {
      List<dynamic> osbillDataListValue = convert.jsonDecode(
        osrecBillData.body,
      )['data'];
      osrecbillDataList = osbillDataListValue;
    }
    return osrecbillDataList;
  }

  static Future<List<PaymentFollowupEntity>> getPaymentFollowupStatusAPI({
    required String partyid,
  }) async {
    List<PaymentFollowupEntity> paymentFollowupDataList = [];
    var followupStatusUrl =
        // 'https://tfa_followup_entry_get.max2tally.com/API/PAYMENT_FOLLOWUP_LIST/GetAllData?PARTNER_CODE=725073894&COMPANY_ID=7dac077e-b23c-41c0-8699-ab8cd6ae5643-10200&PARTY_ID=7dac077e-b23c-41c0-8699-ab8cd6ae5643-0000387a&DB_NM=Max_001';
        '${ApiUrl.getpaymentfollowup}company_id=${Utility.companyId}&party_id=$partyid&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(followupStatusUrl);
    }

    final paymentResponse = await http.get(
      Uri.parse(followupStatusUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );

    if (paymentResponse.statusCode == 200) {
      var paymentValue = convert.jsonDecode(paymentResponse.body)['data'];
      if (paymentValue.isNotEmpty) {
        for (int i = 0; i < paymentValue.length; i++) {
          PaymentFollowupEntity followupentity = PaymentFollowupEntity.fromJson(
            paymentValue[i],
          );
          paymentFollowupDataList.add(followupentity);
        }
      }
    }
    return paymentFollowupDataList;
  }

  static Future<List<PaymentFollowupEntity>> getPaymentFollowupDataAPI({
    required String mobileno,
    required String fromdate,
    required String todate,
  }) async {
    List<PaymentFollowupEntity> paymentFollowupDataList = [];
    var paymentFollowupAllUrl =
        '${ApiUrl.getPaymentFollowupUrl}company_id=${Utility.companyId}&mobile_no=$mobileno&from_date=$fromdate&to_date=$todate&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(paymentFollowupAllUrl);
    }

    final paymentResponse = await http.get(
      Uri.parse(paymentFollowupAllUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );

    if (paymentResponse.statusCode == 200) {
      var paymentValue = convert.jsonDecode(paymentResponse.body)['data'];
      if (paymentValue.isNotEmpty) {
        for (int i = 0; i < paymentValue.length; i++) {
          PaymentFollowupEntity followupentity = PaymentFollowupEntity.fromJson(
            paymentValue[i],
          );
          paymentFollowupDataList.add(followupentity);
        }
      }
    }
    return paymentFollowupDataList;
  }

  static Future<List<dynamic>> getlastfollowupAPI({
    required String partyid,
  }) async {
    List lastfollowupSyncValue = [];
    var lastfollowupUrl =
        '${ApiUrl.lastfollowupUrl}company_id=${Utility.companyId}&party_id=$partyid&db_nm=${Utility.sysDbName}';

    if (kDebugMode) {
      print('lastfollowupUrl:$lastfollowupUrl');
    }
    final followupData = await http.get(
      Uri.parse(lastfollowupUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    print(followupData.body);
    if (followupData.statusCode == 200) {
      List<dynamic> paymentfollowupValue = convert.jsonDecode(
        followupData.body,
      )['data'];
      lastfollowupSyncValue = paymentfollowupValue;
    }
    return lastfollowupSyncValue;
  }

  static Future<List<VisitAttendanceEntity>> getCustomerSearchDataAPI({
    required String searchvalue,
  }) async {
    List<VisitAttendanceEntity> searchDetailsList = [];
    var searchDataUrl =
        '${ApiUrl.customersearchUrl}company_id=${Utility.companyId}&search_value=$searchvalue&db_nm=${Utility.sysDbName}';

    if (kDebugMode) {
      print(searchDataUrl);
    }

    final searchResponse = await http.get(
      Uri.parse(searchDataUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );

    if (searchResponse.statusCode == 200) {
      var visitResponseUserValue = convert.jsonDecode(
        searchResponse.body,
      )['data'];
      if (visitResponseUserValue.isNotEmpty) {
        for (int i = 0; i < visitResponseUserValue.length; i++) {
          VisitAttendanceEntity visitAttendanceEntity =
              VisitAttendanceEntity.fromJson(visitResponseUserValue[i]);
          searchDetailsList.add(visitAttendanceEntity);
        }
      }
    }
    return searchDetailsList;
  }

  // static Future<List<VisitAttendanceEntity>> getVisitDetailsDataAPI({
  //   required String fromdate,
  //   required String todate,
  // }) async {
  //   List<VisitAttendanceEntity> visitDetailsList = [];
  //   var visitDataUrl =
  //   '${ApiUrl.visitDetailsUrl}company_id=${Utility.companyId}&from_date=$fromdate&to_date=$todate&db_nm=${Utility.sysDbName}';
  //   if (kDebugMode) {
  //     print(visitDataUrl);
  //   }

  //   final visitResponse = await http.get(
  //     Uri.parse(visitDataUrl),
  //     headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
  //   );

  //   if (visitResponse.statusCode == 200) {
  //     var visitResponseUserValue = convert.jsonDecode(
  //       visitResponse.body,
  //     )['data'];
  //     if (visitResponseUserValue.isNotEmpty) {
  //       for (int i = 0; i < visitResponseUserValue.length; i++) {
  //         VisitAttendanceEntity visitAttendanceEntity =
  //             VisitAttendanceEntity.fromJson(visitResponseUserValue[i]);
  //         visitDetailsList.add(visitAttendanceEntity);
  //       }
  //     }
  //   }
  //   return visitDetailsList;
  // }

  static Future<List<VisitAttendanceEntity>> getVisitDetailsDataAPI({
    required String fromdate,
    required String todate,
    String filterType = 'ALL',
  }) async {
    List<VisitAttendanceEntity> visitDetailsList = [];
    var visitDataUrl =
        '${ApiUrl.visitDetailsUrl}company_id=${Utility.companyId}&from_date=$fromdate&to_date=$todate&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(visitDataUrl);
    }

    final visitResponse = await http.get(
      Uri.parse(visitDataUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );

    if (visitResponse.statusCode == 200) {
      var visitResponseUserValue = convert.jsonDecode(
        visitResponse.body,
      )['data'];
      if (visitResponseUserValue.isNotEmpty) {
        for (int i = 0; i < visitResponseUserValue.length; i++) {
          VisitAttendanceEntity visitAttendanceEntity =
              VisitAttendanceEntity.fromDetailsRptJson(
                visitResponseUserValue[i],
              );
          // visitDetailsList.add(visitAttendanceEntity);
          // Apply filter
          if (filterType == 'ALL') {
            visitDetailsList.add(visitAttendanceEntity);
          } else if (filterType == 'Existing' &&
              visitAttendanceEntity.customertype == 'Existing') {
            visitDetailsList.add(visitAttendanceEntity);
          } else if (filterType == 'Cold Visit' &&
              visitAttendanceEntity.customertype == 'Cold Visit') {
            visitDetailsList.add(visitAttendanceEntity);
          }
        }
      }
    }
    return visitDetailsList;
  }

  static Future<List<dynamic>> getVisitAttendanceSumApiData({
    required String fromdate,
    required String todate,
    required String mobileno,
  }) async {
    List visitList = [];
    var visitUrl =
        '${ApiUrl.getvisitsummaryApiUrl}company_id=${Utility.companyId}&from_date=$fromdate&to_date=$todate&db_nm=${Utility.sysDbName}&mobile_no=$mobileno&tl_mobile_no=';
    if (kDebugMode) {
      print(visitUrl);
    }
    var response = await http
        .get(
          Uri.parse(visitUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    List<dynamic> selectedvisitUrl = convert.jsonDecode(response.body)['data'];

    visitList = selectedvisitUrl;

    return visitList;
  }

  static Future<List<dynamic>> getVisitAttendance({
    required String partyid,
  }) async {
    List visitList = [];
    var visitUrl =
        '${ApiUrl.getvisitListApiUrl}company_id=${Utility.companyId}&from_date=&to_date=&party_id=$partyid&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(visitUrl);
    }
    var response = await http
        .get(
          Uri.parse(visitUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    List<dynamic> selectedvisitUrl = convert.jsonDecode(response.body)['data'];

    visitList = selectedvisitUrl;

    return visitList;
  }

  static Future<List<UnbilledItemEntity>> getInactiveCustomerDataAPI({
    required String type,
    required String inactivesince,
  }) async {
    List<UnbilledItemEntity> inactiveItemDataList = [];
    var inactiveItemDataUrl =
        '${ApiUrl.getInactiveCustomerUrl}company_id=${Utility.companyId}&type=$type&inactive_since=$inactivesince&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print('inactiveItemDataUrl $inactiveItemDataUrl');
    }
    final inactiveItemResponse = await http.get(
      Uri.parse(inactiveItemDataUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );

    if (inactiveItemResponse.statusCode == 200) {
      var inactiveItemValue = convert.jsonDecode(
        inactiveItemResponse.body,
      )['data'];
      print(inactiveItemValue);
      if (inactiveItemValue.isNotEmpty) {
        for (int i = 0; i < inactiveItemValue.length; i++) {
          UnbilledItemEntity unbilleditementity = UnbilledItemEntity.fromJson(
            inactiveItemValue[i],
          );
          inactiveItemDataList.add(unbilleditementity);
          print(inactiveItemDataList.length);
        }
      }
    }
    return inactiveItemDataList;
  }

  // static Future<List<dynamic>> getdailyperformanceAPIData(
  //   // {
  //   // required String partyId,
  // // }
  // ) async {
  //   List dailyperformanceDataList = [];
  //   var dailyperformanceUrl ='https://tfa_daily_performance_report.max2tally.com/API/Daily_Performance_Report/Get_Detail?COMPANY_ID=7dac077e-b23c-41c0-8699-ab8cd6ae5643-10200&PARTNER_CODE=725073894&MOBILE_NO=7021099673&FROM_DATE=2026-03-18 00:00:00.000&TO_DATE=2026-03-18 00:00:00.000&DB_NM=Max_001';
  //       // '${ApiUrl.osRecPayBillUrl}company_id=${Utility.companyId}&party_code=$partyId&DB_NM=${Utility.sysDbName}';

  //   if (kDebugMode) {
  //     print('dailyperformanceUrl:$dailyperformanceUrl');
  //   }

  //   final dailyPerformanceResponse = await http.get(
  //     Uri.parse(dailyperformanceUrl),
  //     headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
  //   );
  //   print(dailyPerformanceResponse.body);
  //   if (dailyPerformanceResponse.statusCode == 200) {
  //     List<dynamic> responseValue = convert.jsonDecode(
  //       dailyPerformanceResponse.body,
  //     )['data'];
  //     dailyperformanceDataList = responseValue;
  //   }
  //   return dailyperformanceDataList;
  // }

  static Future<Map<String, dynamic>?> getdailyperformanceAPIData({
    required String mobileNo,
    required String fromDate,
    required String toDate,
  }) async {
    var dailyperformanceUrl =
        '${ApiUrl.getDailyPerformanceUrl}company_id=${Utility.companyId}&from_date=$fromDate&to_date=$toDate&db_nm=${Utility.sysDbName}';
    // 'https://tfa_daily_performance_report.max2tally.com/API/Daily_Performance_Report/Get_Detail?COMPANY_ID=7dac077e-b23c-41c0-8699-ab8cd6ae5643-10200&PARTNER_CODE=725073894&MOBILE_NO=7021099673&FROM_DATE=2026-03-18 00:00:00.000&TO_DATE=2026-03-18 00:00:00.000&DB_NM=Max_001';
    if (kDebugMode) {
      print('dailyperformanceUrl: $dailyperformanceUrl');
    }

    final response = await http.get(
      Uri.parse(dailyperformanceUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );

    if (kDebugMode) {
      print(response.body);
    }

    if (response.statusCode == 200) {
      final decoded = convert.jsonDecode(response.body);

      if (decoded['data'] != null && decoded['data'].isNotEmpty) {
        return decoded['data'][0];
      }
    }

    return null;
  }


  static Future<List<SOReportEntity>> getSalesOrderRegisterAPI({
    String approvalStatus = '',
    String? fromdate,
    String? todate,
  }) async {
    List<SOReportEntity> salesOrderRegisterValue = [];
    String salesOrderRegisterUrl =
        '${ApiUrl.soReportUrl}company_id=${Utility.companyId}&user_type=&from_date=$fromdate&to_date=$todate&approval_status=$approvalStatus&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(salesOrderRegisterUrl);
    }
    var salesOrderRegisterResponse = await http.get(
      Uri.parse(salesOrderRegisterUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (salesOrderRegisterResponse.statusCode == 200) {
      var salesOrderRegisterData = convert.jsonDecode(
        salesOrderRegisterResponse.body,
      )['data'];
      if (salesOrderRegisterData.isNotEmpty) {
        for (int i = 0; i < salesOrderRegisterData.length; i++) {
          salesOrderRegisterValue.add(
            SOReportEntity.fromMap(salesOrderRegisterData[i]),
          );
        }
      }
    }
    return salesOrderRegisterValue;
  }

  static Future<List<SOReportEntity>> getSalesOrderDetailsRegisterAPI({
    String? fromdate,
    String? todate,
    String? status,
  }) async {
    List<SOReportEntity> salesOrderDetailsValue = [];
    String soDetRegisterUrl =
        '${ApiUrl.soDetailsReportUrl}company_id=${Utility.companyId}&mobile_no=${Utility.cmpmobileno}&from_date=$fromdate&to_date=$todate&db_nm=${Utility.sysDbName}&status=$status';
    if (kDebugMode) {
      print(soDetRegisterUrl);
    }
    var salesOrderDetResponse = await http.get(
      Uri.parse(soDetRegisterUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (salesOrderDetResponse.statusCode == 200) {
      var soRegisterData = convert.jsonDecode(
        salesOrderDetResponse.body,
      )['data'];
      if (soRegisterData.isNotEmpty) {
        for (int i = 0; i < soRegisterData.length; i++) {
          salesOrderDetailsValue.add(SOReportEntity.fromMap(soRegisterData[i]));
        }
      }
    }
    return salesOrderDetailsValue;
  }
  ////////////////////////Expense ////////////////////////

  ///
  // snehal 6-01-2025 add for approver list
  static Future<List<UserEntity>> getcompanyuserlistAPI() async {
    List<UserEntity> userlistItem = [];
    var userlistUrl =
        '${ApiUrl.companyuserlistGetUrl}company_id=${Utility.companyId}&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(userlistUrl);
    }
    final userResponse = await http.get(
      Uri.parse(userlistUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (userResponse.statusCode == 200) {
      var userValue = convert.jsonDecode(userResponse.body)['data'];
      if (userValue.isNotEmpty) {
        for (int i = 0; i < userValue.length; i++) {
          UserEntity userModel = UserEntity.fromMap(userValue[i]);
          userlistItem.add(userModel);
        }
      }
    }
    return userlistItem;
  }

  static Future<List<AdvExpensesEntity>> getAdvanceExpenseApiData(
    String status,
  ) async {
    List<AdvExpensesEntity> advExpenseDataList = [];
    var selectedUrl =
        '${ApiUrl.advreportUrl}company_id=${Utility.companyId}&email_id=${Utility.useremailid}&from_date=${DateListView.selectedFromDateOfDateController}&to_date=${DateListView.selectedToDateOfDateController}&db_nm=${Utility.sysDbName}&status=$status';
    print(selectedUrl);
    var response = await http
        .get(
          Uri.parse(selectedUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    print(response.body);
    if (response.statusCode == 200) {
      var advExpenseItem = convert.jsonDecode(response.body)['data'];
      if (advExpenseItem.isNotEmpty) {
        for (int i = 0; i < advExpenseItem.length; i++) {
          AdvExpensesEntity advexpenseentity = AdvExpensesEntity.fromJson(
            advExpenseItem[i],
          );
          advExpenseDataList.add(advexpenseentity);
        }
      }
    }
    return advExpenseDataList;
  }

  static Future<List<AdvExpensesEntity>> getAdvExpenseAprovalApi(
    String status,
  ) async {
    String approvedById = Utility
        .useremailid; //Utility.cmpusertype == 'Team Leader'?Utility.employeeId:'';
    List<AdvExpensesEntity> expenseDataList = [];
    var selectedUrl =
        '${ApiUrl.advapprovalUrl}company_id=${Utility.companyId}&approved_by_id=$approvedById&from_date=${DateListView.selectedFromDateOfDateController}&to_date=${DateListView.selectedToDateOfDateController}&status=$status&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(selectedUrl);
    }
    var response = await http
        .get(
          Uri.parse(selectedUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    print(response.body);
    if (response.statusCode == 200) {
      var expenseRegisterItem = convert.jsonDecode(response.body)['data'];
      if (expenseRegisterItem.isNotEmpty) {
        for (int i = 0; i < expenseRegisterItem.length; i++) {
          AdvExpensesEntity expenseentity = AdvExpensesEntity.fromJson(
            expenseRegisterItem[i],
          );
          expenseDataList.add(expenseentity);
        }
      }
    }
    return expenseDataList;
  }

  static Future<ExpensesReportEntity?> getexpensesapprovalApi({
    required String status,
  }) async {
    // String approverId = Utility.cmpusertype == 'Team Leader'?Utility.employeeId:'';
    String approverId = " ";
    // Utility.cmpusertype == 'Team Leader'?
    // Utility.useremailid;
    ExpensesReportEntity? expenseModel;
    var expenseUrl =
        '${ApiUrl.expenseApprovalRptUrl}company_id=${Utility.companyId}&approver=$approverId&from_date=${DateListView.selectedFromDateOfDateController}&to_date=${DateListView.selectedToDateOfDateController}&status=$status&db_nm=${Utility.sysDbName}';
    // if (kDebugMode) {
    print(expenseUrl);
    // }
    final expenseResponse = await http
        .get(
          Uri.parse(expenseUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    print(expenseResponse.body);
    if (expenseResponse.statusCode == 200) {
      var expenseMasterValue = await convert.jsonDecode(
        expenseResponse.body,
      )['data'];
      if (expenseMasterValue.isNotEmpty) {
        expenseModel = ExpensesReportEntity.fromALLJson(expenseMasterValue[0]);
      }
    }
    return expenseModel;
  }

  ///////////////////
  // static Future<List<ExpensesHeaderEntity>> getExpenseApiData(String fromdate, String todate) async {
  //   List<ExpensesHeaderEntity> expenseDataList = [];
  //   var selectedUrl =
  //       '${ApiUrl.expenseRegisterUrl}company_id=${Utility.companyId}&mobile_no=${Utility.cmpmobileno}&from_date=$fromdate&to_date=$todate&db_nm=${Utility.sysDbName}';
  //   if (kDebugMode) {
  //     print(selectedUrl);
  //   }
  //   var response = await http.get(Uri.parse(selectedUrl),headers:Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken)).timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
  //   if (response.statusCode == 200) {
  //     var expenseRegisterItem = convert.jsonDecode(response.body)['data'];
  //     if (expenseRegisterItem.isNotEmpty) {
  //       for (int i = 0; i < expenseRegisterItem.length; i++) {
  //         ExpensesHeaderEntity expenseentity =ExpensesHeaderEntity.fromALLJson(expenseRegisterItem[i]);
  //         expenseDataList.add(expenseentity);
  //       }
  //     }
  //   }
  //   return expenseDataList;
  // }

  static Future<ExpensesReportEntity?> getExpenseApiData(String status) async {
    ExpensesReportEntity? expenseModel;
    var expenseUrl =
        '${ApiUrl.expenseRegisterUrl}company_id=${Utility.companyId}&email_id=${Utility.useremailid}&from_date=${DateListView.selectedFromDateOfDateController}&to_date=${DateListView.selectedToDateOfDateController}&status=$status&db_nm=${Utility.sysDbName}';

    if (kDebugMode) {
      print(expenseUrl);
    }
    var response = await http
        .get(
          Uri.parse(expenseUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    print(response.body);
    if (response.statusCode == 200) {
      expenseModel = null;
      var expenseMasterValue = await convert.jsonDecode(response.body)['data'];
      if (expenseMasterValue.isNotEmpty) {
        for (int i = 0; i < expenseMasterValue.length; i++) {
          expenseModel = ExpensesReportEntity.fromALLJson(
            expenseMasterValue[i],
          );
          print('expenseModel $expenseModel');
        }
      }
    }
    return expenseModel;
  }

  // //Snehal 24-10-2024 add for advance expenses report
  // static Future<List<AdvExpensesEntity>> getAdvanceExpenseApiData(
  //     String fromDate, String toDate) async {
  //   List<AdvExpensesEntity> advExpenseDataList = [];
  //   var selectedUrl =
  //       '${ApiUrl.advreportUrl}company_id=${Utility.companyId}&email_id=${Utility.useremailid}&from_date=$fromDate&to_date=$toDate&db_nm=${Utility.sysDbName}';

  //   if (kDebugMode) {
  //     print(selectedUrl);
  //   }
  //   var response = await http
  //       .get(Uri.parse(selectedUrl),
  //           headers:
  //               Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken))
  //       .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
  //   if (response.statusCode == 200) {
  //     var advExpenseItem = convert.jsonDecode(response.body)['Data'];
  //     if (advExpenseItem.isNotEmpty) {
  //       for (int i = 0; i < advExpenseItem.length; i++) {
  //         AdvExpensesEntity advexpenseentity =
  //             AdvExpensesEntity.fromJson(advExpenseItem[i]);
  //         advExpenseDataList.add(advexpenseentity);
  //       }
  //     }
  //   }
  //   return advExpenseDataList;
  // }

  //  static Future<AdvExpensesEntity> getAdvExpenseAprovalApi(
  //     String status, String fromdate, String todate) async {
  //   AdvExpensesEntity advexpensesEntity = AdvExpensesEntity();
  //   var advexpenseApprovalUrl =
  //       '${ApiUrl.advapprovalUrl}company_id=${Utility.companyId}&email_id=${Utility.useremailid}&user_type=${Utility.cmpusertype}&from_date=$fromdate&to_date=$todate&status=$status&db_nm=${Utility.sysDbName}';

  //   if (kDebugMode) {
  //     print(advexpenseApprovalUrl);
  //   }
  //   final advexpenseApprovaResponse = await http.get(
  //       Uri.parse(advexpenseApprovalUrl),
  //       headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken));
  //   if (advexpenseApprovaResponse.statusCode == 200) {
  //     var advexpenseApprovalData =
  //         convert.jsonDecode(advexpenseApprovaResponse.body)['data'];
  //     if (kDebugMode) {
  //       print(advexpenseApprovalData);
  //     }
  //     // advexpensesEntity =
  //     //     AdvExpensesEntity.fromJson(advexpenseApprovalData[0]);
  //     if (advexpenseApprovalData.isNotEmpty) {
  //       advexpensesEntity =
  //           AdvExpensesEntity.fromJson(advexpenseApprovalData[0]);
  //     }
  //   }
  //   return advexpensesEntity;
  // }

  static Future<List<ExpensesLedgerEntity>> getLedMasterApi({
    required String typedata,
    required String ledgerid,
  }) async {
    List<ExpensesLedgerEntity> ledgerEntityVal = [];
    var getledgerUrl =
        '${ApiUrl.ledgerMasterUrl}&company_id=${Utility.companyId}&type=$typedata&ledger_id=$ledgerid&DB_NM=${Utility.sysDbName}';
    if (kDebugMode) {
      print('getledgerUrl:$getledgerUrl');
    }
    final getResponse = await http
        .get(
          Uri.parse(getledgerUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (getResponse.statusCode == 200) {
      List ledgerdData = convert.jsonDecode(getResponse.body)['data'];
      if (ledgerdData.isNotEmpty) {
        for (int i = 0; i < ledgerdData.length; i++) {
          ExpensesLedgerEntity ledgermasterentity =
              ExpensesLedgerEntity.fromALLJson(ledgerdData[i]);
          ledgerEntityVal.add(ledgermasterentity);
        }
      }
    }
    return ledgerEntityVal;
  }

  static Future<ExpensesHeaderEntity?> getExpenseAllApiData({
    required String uniqueId,
  }) async {
    ExpensesHeaderEntity? expenseHedEntity;
    var expenseDataUrl =
        '${ApiUrl.expenseAllDetUrl}company_id=${Utility.companyId}&unique_id=$uniqueId&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(expenseDataUrl);
    }
    final issueResponse = await http.get(
      Uri.parse(expenseDataUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (issueResponse.statusCode == 200) {
      var issueValue = convert.jsonDecode(issueResponse.body)['data'];
      print('expensesalldet $issueValue');
      if (issueValue.isNotEmpty) {
        expenseHedEntity = ExpensesHeaderEntity.fromALLJson(issueValue[0]);
      }
    }
    return expenseHedEntity;
  }

  //======================================================================================================================
  //Snehal 24-12-2025 add
  static Future<List<LedgerMasterEntity>> ledgerMasterRptAPi({
    String ledgerId = '',
    String ledgerGroup = '',
    String active = '',
  }) async {
    List<LedgerMasterEntity> ledgerMstDataVal = [];
    var ledgerMstRepUrl =
        '${ApiUrl.ledgerMstGetUrl}company_id=${Utility.companyId}&ledger_id=$ledgerId&ledger_group=$ledgerGroup&active=$active&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print('ledgerMstRepUrl:$ledgerMstRepUrl');
    }
    var responsedata = await http.get(
      Uri.parse(ledgerMstRepUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    print('responseRepData:${responsedata.body}');
    if (responsedata.statusCode == 200) {
      var responseRepData = convert.jsonDecode(responsedata.body)['data'];
      if (responseRepData.isNotEmpty) {
        for (int i = 0; i < responseRepData.length; i++) {
          ledgerMstDataVal.add(LedgerMasterEntity.formMap(responseRepData[i]));
        }
      }
    }
    return ledgerMstDataVal;
  }

  ////post//////////////////////
  ///
  ///
  static Future<List> postLoginAPIDet(LoginEntity loginEntity) async {
    List loginData = [];
    if (kDebugMode) {
      print(ApiUrl.postLoginUrl);
      print(
        convert.jsonEncode({
          "data": [loginEntity],
        }),
      );
    }
    String jsontext = convert.jsonEncode({
      "data": [loginEntity],
    });
    String encryptedJson = await Utility.encryptJson(jsonText: jsontext);
    String jsonData = convert.jsonEncode({"data": encryptedJson});
    if (kDebugMode) {
      print('jsontext1 $jsonData');
    }
    final response = await http.post(
      Uri.parse(ApiUrl.postLoginUrl),
      headers: Utility.getSystemxsDmsHeaders(token: ''),
      body: jsonData,
    );
    print('response${response.body}');
    if (response.statusCode == 200) {
      var encryptedLoginData = await convert.jsonDecode(response.body)['data'];
      final decrypted = await Utility.decryptedJson(
        encryptedJson: encryptedLoginData,
      ); //encrypter.decrypt64(encryptedLoginData,iv: iv);
      print('decrypted $decrypted');
      loginData = await convert.jsonDecode(decrypted)['data'];
      if (kDebugMode) {
        print('loginData $loginData');
      }
    }
    return loginData;
  }

  ///========================================party============================================//
  ///
  //Rupali 17-10-2024
  static Future<String> postPartyMasterApi(
    List<Map<String, dynamic>> partyMasterListMap,
  ) async {
    var postpartyMasterUrl =
        '${ApiUrl.partyMasterPostUrl}db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(postpartyMasterUrl);
      print(convert.jsonEncode({'data': partyMasterListMap}));
    }
    final response = await http.post(
      Uri.parse(postpartyMasterUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode({'data': partyMasterListMap}),
    );
    print('object:${convert.jsonDecode(response.body)['message']}');
    // if (response.statusCode == 200 &&
    //     convert.jsonDecode(response.body)['message'] ==
    //         'Data Inserted Successfully') {
    //   return 'Data Inserted Successfully';
    // } else {
    //   return 'Oops there is an error!';
    // }
    //pooja // 13-12-2024 // add
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an Error!';
    }
  }

  //pratiksha p add
  static Future<String> ledgerDetPostApi(
    List<Map<String, dynamic>> ledgerListMap,
  ) async {
    var ledgerPostUrl = '${ApiUrl.ledgerExpPost}db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(ledgerPostUrl);
      print(convert.jsonEncode({'data': ledgerListMap}));
    }
    final response = await http
        .post(
          Uri.parse(ledgerPostUrl),
          body: convert.jsonEncode({'data': ledgerListMap}),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (kDebugMode) {
      print('ledger response ${response.body}');
    }
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an Error!';
    }
  }

  ///

  ////visit /////////////////////////////////////
  ///pratiksha p add 25-09-2024 add
  static Future postvisitInAPI(
    VisitAttendanceEntity visitattendanceEntity,
  ) async {
    List<Map<String, dynamic>> visitEntityListMap = [];
    visitEntityListMap.add(visitattendanceEntity.toJson());
    String soHeaderUrl =
        '${ApiUrl.checkinApiUrl}company_id=${Utility.companyId}&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(soHeaderUrl);
      print(convert.jsonEncode({'data': visitEntityListMap}));
    }
    final response = await http.post(
      Uri.parse(soHeaderUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode({'data': visitEntityListMap}),
    );
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(convert.jsonDecode(response.body)['message']);
      }
      return convert.jsonDecode(response.body);
      // return response; //convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an Error!';
    }
  }

  ///pratiksha p add 25-09-2024 add
  static Future postvisitOutPI(
    VisitAttendanceEntity visitattendanceEntity,
    String visitid,
  ) async {
    List<Map<String, dynamic>> visitEntityListMap = [];
    visitEntityListMap.add(visitattendanceEntity.toJson());
    String soHeaderUrl =
        '${ApiUrl.checkoutApiUrl}company_id=${Utility.companyId}&visit_id=$visitid&db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(soHeaderUrl);
      print(convert.jsonEncode({'data': visitEntityListMap}));
    }
    final response = await http.post(
      Uri.parse(soHeaderUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode({'data': visitEntityListMap}),
    );
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(convert.jsonDecode(response.body));
      }
      return convert.jsonDecode(response.body);
      // return response; //convert.jsonDecode(response.body);
    } else {
      return 'Oops there is an Error!';
    }
  }

  // static Future<String> retailerNoOrderPostCall(
  //   RetailerComplaintData retailerNoOrderRequestEntity,
  //     String partyid,
  //   // List<Map<String, dynamic>> noorderListMap,
  // ) async {
  //      List<Map<String, dynamic>> noorderListMap = [];
  //   noorderListMap.add(retailerNoOrderRequestEntity.toJson());
  //   var noOrderPostUrl = '${ApiUrl.reasonNoOrderurl}company_id=${Utility.companyId}&party_id=$partyid&db_nm=${Utility.sysDbName}';
  //   if (kDebugMode) {
  //     print(noOrderPostUrl);
  //     print(convert.jsonEncode({'data': noorderListMap}));
  //     // print(convert.jsonEncode({retailerNoOrderRequestEntity}));
  //   }
  //   final response = await http
  //       .post(
  //         Uri.parse(noOrderPostUrl),
  //         body:convert.jsonEncode({'data': noorderListMap}),
  //         headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
  //       )
  //       .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
  //   if (kDebugMode) {
  //     print('noorder response ${response.body}');
  //   }
  //   if (response.statusCode == 200) {
  //     return convert.jsonDecode(response.body)['message'];
  //   } else {
  //     return 'Oops there is an Error!';
  //   }
  // }
  static Future<String> retailerNoOrderPostCall(
    RetailerComplaintRequestEntity request,
    String partyid,
  ) async {
    var noOrderPostUrl =
        '${ApiUrl.reasonNoOrderurl}company_id=${Utility.companyId}&party_id=$partyid&db_nm=${Utility.sysDbName}';

    if (kDebugMode) {
      print(noOrderPostUrl);
      print(convert.jsonEncode(request.toJson()));
    }

    final response = await http
        .post(
          Uri.parse(noOrderPostUrl),
          body: convert.jsonEncode(request.toJson()),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));

    if (kDebugMode) {
      print('noorder response ${response.body}');
    }

    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an Error!';
    }
  }
  //======================================================================================================================
  // sales order

  static Future<String> postreasonfornoorderAPI(
    RetailerComplaintEntity reasonEntity,
  ) async {
    List<Map<String, dynamic>> reasonListMap = [];
    reasonListMap.add(reasonEntity.toJson());
    var reasonUrl =
        '${ApiUrl.noorderreasonrl}db_nm=${Utility.sysDbName}'; //Rupali 17-11-2025
    if (kDebugMode) {
      print(reasonUrl);
      print(convert.jsonEncode({'data': reasonListMap}));
    }
    final response = await http.post(
      Uri.parse(reasonUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode({'data': reasonListMap}),
    );
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an error';
    }
  }

  static Future postSalesOrderHeaderAPI(
    SalesOrderHeaderEntity salesOrderEntity,
  ) async {
    List<Map<String, dynamic>> soEntityListMap = [];
    soEntityListMap.add(salesOrderEntity.toMap());
    String soHeaderUrl =
        '${ApiUrl.soHeaderInsertUrl}db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(soHeaderUrl);
      print(convert.jsonEncode({'data': soEntityListMap}));
    }
    final response = await http.post(
      Uri.parse(soHeaderUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode({'data': soEntityListMap}),
    );
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(convert.jsonDecode(response.body));
      }
      return convert.jsonDecode(response.body);
    } else {
      return 'Oops there is an Error!';
    }
  }

  static Future<String> postAddtoCardDetAPI(
    SOAddToCartEntity soCartEntity,
  ) async {
    List<Map<String, dynamic>> soCartListMap = [];
    soCartListMap.add(soCartEntity.toMap());
    var soAddCartUrl = '${ApiUrl.cartAddUrl}db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(soAddCartUrl);
      print(convert.jsonEncode({'data': soCartListMap}));
    }
    final response = await http.post(
      Uri.parse(soAddCartUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode({'data': soCartListMap}),
    );
    if (response.statusCode == 200) {
      return convert.jsonDecode(
        response.body,
      )['message']; //'Data Inserted Successfully';
    } else {
      return 'Oops there is an error!';
    }
  }

  static Future<String> postSOInventoryDetAPI(
    List<Map<String, dynamic>> soInventiryListMap,
  ) async {
    var soInvUrl = '${ApiUrl.inventoryAddUrl}db_nm=${Utility.sysDbName}';
    final response = await http.post(
      Uri.parse(soInvUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: (convert.jsonEncode({'data': soInventiryListMap})),
    );
    if (response.statusCode == 200) {
      print('test ${convert.jsonDecode(response.body)['message']}');
      return convert.jsonDecode(
        response.body,
      )['message']; //'Data Inserted Successfully';
    } else {
      return 'Oops there is an error!';
    }
  }

  // static Future postSOPayDetailsApi(List<Map<String, dynamic>> soPaymentDetailsListMap) async {
  //   var paymentDetailsUrl = '${ApiUrl.paymentAddUrl}db_nm=${Utility.sysDbName}';
  //   if (kDebugMode) {
  //     print(paymentDetailsUrl);
  //     print(convert.jsonEncode({'data': soPaymentDetailsListMap}));
  //   }
  //   return await http.post(Uri.parse(paymentDetailsUrl),
  //   headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
  //   body: convert.jsonEncode({'data': soPaymentDetailsListMap}));
  // }

  static Future<String> deleteCartItemPostAPI(
    SOAddToCartEntity cartEntity,
  ) async {
    List<Map<String, dynamic>> cartEntityList = [];
    cartEntityList.add(cartEntity.toMap());
    var deleteCartItemUrl = '${ApiUrl.cartDeleteUrl}db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(deleteCartItemUrl);
      print(convert.jsonEncode({"data": cartEntityList}));
    }
    final response = await http.post(
      Uri.parse(deleteCartItemUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode({"data": cartEntityList}),
    );
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an error';
    }
  }

  static Future<String> postSOHeaderBilledToAPI(
    SalesOrderHeaderEntity soHeaderEntity,
    String uniqueId,
  ) async {
    List<Map<String, dynamic>> soBiiledToEntityListMap = [];
    soBiiledToEntityListMap.add(soHeaderEntity.toBilledToMap());
    String soHeaderBilledToUrl =
        '${ApiUrl.billedToUpdateUrl}Company_Id=${Utility.companyId}&Mobile_No=${Utility.cmpmobileno}&Unique_Id=$uniqueId&db_nm=${Utility.sysDbName}'; //Rupali 17-11-2025// &Partner_Code=${Utility.partnerCode}
    if (kDebugMode) {
      print(soHeaderBilledToUrl);
      print(convert.jsonEncode({'data': soBiiledToEntityListMap}));
    }
    final reponse = await http.post(
      Uri.parse(soHeaderBilledToUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode({'data': soBiiledToEntityListMap}),
    );
    if (reponse.statusCode == 200) {
      return convert.jsonDecode(reponse.body)['message'];
    } else {
      return 'Oops there is an error!';
    }
  }

  static Future<String> deleteSODetAPI(
    SalesOrderHeaderEntity soHeaderEntity,
  ) async {
    List<Map<String, dynamic>> soMapList = [];
    soMapList.add(soHeaderEntity.toMap());
    var soDeleteUrl =
        '${ApiUrl.soDeleteUrl}db_nm=${Utility.sysDbName}'; // &partner_code=${Utility.partnerCode}
    final response = await http.post(
      Uri.parse(soDeleteUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: (convert.jsonEncode({'data': soMapList})),
    );
    if (response.statusCode == 200) {
      return convert.jsonDecode(
        response.body,
      )['message']; //'Data Deleted Successfully';
    } else {
      return 'Oops there is an error!';
    }
  }

  static Future<String> soStatusUpdation(SalesOrderHeaderEntity sopost) async {
    List<Map<String, dynamic>> soUpdateDetListMap = [];
    soUpdateDetListMap.add(sopost.toMapApprovalStatus());
    var additionalDetUrl =
        '${ApiUrl.soStatusUpdateUrl}db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(additionalDetUrl);
    }
    final response = await http
        .post(
          Uri.parse(additionalDetUrl),
          body: convert.jsonEncode({'data': soUpdateDetListMap}),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (response.statusCode == 200) {
      // print('response.body ${response.body}');
      return response.body;
    } else {
      return 'Oops there is an Error!';
    }
  }

  //======================================================================================================================
  // collection

  // static Future<String> deleteCollectionApi({
  //   required List<Map<String, dynamic>> collectionEntityListMap,
  // }) async {
  //   var deletecollectionUrl =
  //       '${ApiUrl.collectionDeleteUrl}db_nm=${Utility.sysDbName}';
  //   if (kDebugMode) {
  //     print(deletecollectionUrl);
  //     print(convert.jsonEncode({"data": collectionEntityListMap}));
  //   }
  //   final response = await http.post(
  //     Uri.parse(deletecollectionUrl),
  //     headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
  //     body: convert.jsonEncode({"data": collectionEntityListMap}),
  //   );
  //   if (response.statusCode == 200) {
  //     // print(response.body);
  //     return response.body.toString();
  //   } else {
  //     return 'Oops there is an Error!';
  //   }
  // }

  // static Future<String> collectionBillsPostApi({
  //   required List<Map<String, dynamic>> purchaseTransDetListMap,
  // }) async {
  //   var purTransDetUrl =
  //       '${ApiUrl.collectionBillPostUrl}db_nm=${Utility.sysDbName}';
  //   if (kDebugMode) {
  //     print(purTransDetUrl);
  //     print(convert.jsonEncode({"data": purchaseTransDetListMap}));
  //   }
  //   final response = await http.post(
  //     Uri.parse(purTransDetUrl),
  //     headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
  //     body: convert.jsonEncode({"data": purchaseTransDetListMap}),
  //   );
  //   if (response.statusCode == 200) {
  //     // print('response.body ${response.body}');
  //     return convert.jsonDecode(response.body)['message'];
  //   } else {
  //     return 'Oops there is an Error!';
  //   }
  // }

  // //snehal 23-11-2024 add for delete bill
  // static Future<String> deleteCollBillApi({
  //   required List<Map<String, dynamic>> recBillDataEntity,
  // }) async {
  //   var deletebillUrl =
  //       '${ApiUrl.collectionBillDelPostUrl}db_nm=${Utility.sysDbName}';
  //   if (kDebugMode) {
  //     print(deletebillUrl);
  //     print(convert.jsonEncode({"data": recBillDataEntity}));
  //   }
  //   final response = await http.post(
  //     Uri.parse(deletebillUrl),
  //     headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
  //     body: convert.jsonEncode({"data": recBillDataEntity}),
  //   );
  //   if (response.statusCode == 200) {
  //     return convert.jsonDecode(response.body)['message'];
  //   } else {
  //     return 'Oops there is an Error!';
  //   }
  // }

  // //buddy//////////

  // //komal D 21-10-2024 added
  // static Future<List<TargetVsActualEntity>> targetVsActualRepApi(
  //   String fromDate,
  //   String toDate,
  // ) async {
  //   List<TargetVsActualEntity> closingstockDataVal = [];
  //   var closingstockRepUrl =
  //       'http://103.193.75.86:59861/API/Target_Vs_Actual_Report/GetTargetVsActualData?company_id=${Utility.companyId}&from_date=$fromDate&to_date=$toDate&db_nm=${Utility.sysDbName}'; //Rupali 17-11-2025
  //   if (kDebugMode) {
  //     print(closingstockRepUrl);
  //   }
  //   var responsedata = await http
  //       .get(
  //         Uri.parse(closingstockRepUrl),
  //         headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
  //       )
  //       .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
  //   print('response:${responsedata.body}');
  //   if (responsedata.statusCode == 200) {
  //     var responseRepData = convert.jsonDecode(responsedata.body)['data'];
  //     if (responseRepData.isNotEmpty) {
  //       for (int i = 0; i < responseRepData.length; i++) {
  //         closingstockDataVal.add(
  //           TargetVsActualEntity.fromJson(responseRepData[i]),
  //         );
  //       }
  //     }
  //   }
  //   return closingstockDataVal;
  // }

  //pratiksha p 07-10-2024 add

  static Future paymentfollowupCreateApi(
    PaymentFollowupEntity paymentEntity,
  ) async {
    List<Map<String, dynamic>> paymentListMap = [];
    paymentListMap.add(paymentEntity.toJson());
    var followupUrl = '${ApiUrl.followupcreatePost}db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(followupUrl);
      print(convert.jsonEncode({'data': paymentListMap}));
    }
    var response = await http
        .post(
          Uri.parse(followupUrl),
          body: convert.jsonEncode({'data': paymentListMap}),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('avbv ${convert.jsonDecode(response.body)}');
      }
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an Error!';
    }
  }

  static Future<String> editcompanylocationApi(PartyEntity loactionpost) async {
    List<Map<String, dynamic>> loactionDetListMap = [];
    loactionDetListMap.add(loactionpost.tolocationMap());
    var editloactionDetUrl =
        '${ApiUrl.editlocationUrl}db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(editloactionDetUrl);
    }
    final response = await http
        .post(
          Uri.parse(editloactionDetUrl),
          body: convert.jsonEncode({'data': loactionDetListMap}),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (response.statusCode == 200) {
      // print('response.body ${response.body}');
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an Error!';
    }
  }

  ///==========================================sales============================================//
  ///
  static Future<String> deleteLedgerSalesApi({
    required List<Map<String, dynamic>> salesLedgerEntityListMap,
  }) async {
    var deletesalesLedgerUrl =
        '${ApiUrl.deletLedger}db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(deletesalesLedgerUrl);
      print(convert.jsonEncode({"data": salesLedgerEntityListMap}));
    }
    final response = await http.post(
      Uri.parse(deletesalesLedgerUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode({"data": salesLedgerEntityListMap}),
    );
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an Error!';
    }
  }

  //pratiksha p add
  static Future<String> additiondDetPostApi(
    SalesHeaderEntity additiondetpost,
  ) async {
    List<Map<String, dynamic>> additionDetListMap = [];
    additionDetListMap.add(additiondetpost.toMap());
    var additionalDetUrl =
        '${ApiUrl.salesAdditiondetPost}db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(additionalDetUrl);
    }
    final response = await http
        .post(
          Uri.parse(additionalDetUrl),
          body: convert.jsonEncode({'data': additionDetListMap}),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (response.statusCode == 200) {
      // print('response.body ${response.body}');
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an Error!';
    }
  }

  //pratiksha p add
  static Future salesHedPostApi(SalesHeaderEntity salesHedEntity) async {
    List<Map<String, dynamic>> salesHedListMap = [];
    salesHedListMap.add(salesHedEntity.toMap());
    var salesHedUrl = '${ApiUrl.salesHedPost}db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(salesHedUrl);
      print(convert.jsonEncode({'data': salesHedListMap}));
    }
    var response = await http
        .post(
          Uri.parse(salesHedUrl),
          body: convert.jsonEncode({'data': salesHedListMap}),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (response.statusCode == 200) {
      // print(convert.jsonDecode(response.body));
      return convert.jsonDecode(response.body);
    } else {
      return 'Oops there is an Error!';
    }
  }

  //pratiksha p add
  static Future<String> deleteSalesApi({
    required List<Map<String, dynamic>> salesEntityListMap,
  }) async {
    var deletesalesUrl = '${ApiUrl.deleteallSales}DB_NM=${Utility.sysDbName}';
    if (kDebugMode) {
      print(deletesalesUrl);
      print(convert.jsonEncode({"data": salesEntityListMap}));
    }
    final response = await http.post(
      Uri.parse(deletesalesUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode({"data": salesEntityListMap}),
    );
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an Error!';
    }
  }

  //pratiksha p add
  static Future<String> salesSavePostApi(
    List<Map<String, dynamic>> paymentListMap,
  ) async {
    var paymentPostUrl = '${ApiUrl.salesSaveUrl}db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(paymentPostUrl);
      print(convert.jsonEncode({'data': paymentListMap}));
    }
    final response = await http
        .post(
          Uri.parse(paymentPostUrl),
          body: convert.jsonEncode({'data': paymentListMap}),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (response.statusCode == 200) {
      // print('response.body ${response.body}');
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an Error!';
    }
  }

  static Future<String> taxLedgerDetPostApi(
    List<Map<String, dynamic>> ledgerListMap,
  ) async {
    var ledgerPostUrl = '${ApiUrl.taxLedPostUrl}db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(ledgerPostUrl);
      print(convert.jsonEncode({'data': ledgerListMap}));
    }
    final response = await http
        .post(
          Uri.parse(ledgerPostUrl),
          body: convert.jsonEncode({'data': ledgerListMap}),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    // print('ledger response ${response.body}');
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an Error!';
    }
  }

  //pratiksha p add
  static Future<String> deleteItemSalesApi({
    required List<Map<String, dynamic>> salesInvEntityListMap,
  }) async {
    var deletesalesItemUrl = '${ApiUrl.deleteItem}DB_NM=${Utility.sysDbName}';
    if (kDebugMode) {
      print(deletesalesItemUrl);
      print(convert.jsonEncode({"data": salesInvEntityListMap}));
    }
    final response = await http.post(
      Uri.parse(deletesalesItemUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode({"data": salesInvEntityListMap}),
    );
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an Error!';
    }
  }

  //pratiksha p add
  static Future<String> salesInvDetPostApi(
    List<Map<String, dynamic>> itemdetpost,
  ) async {
    var itemPostUrl = '${ApiUrl.salesInvPost}db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(itemPostUrl);
      print(convert.jsonEncode({'data': itemdetpost}));
    }
    final response = await http
        .post(
          Uri.parse(itemPostUrl),
          body: convert.jsonEncode({'data': itemdetpost}),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    // print('response.body ${response.body}');
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an Error!';
    }
  }

  /////////////////////////////  expenses ///////////////////////////////////////////

  static Future<String> postAdvExpensesUpdateStatusAPI(
    AdvExpensesEntity expenseAdvEntity,
  ) async {
    List<Map<String, dynamic>> advExpenseEntityListMap = [];
    advExpenseEntityListMap.add(expenseAdvEntity.toJson());
    String expenseupdtStatusUrl =
        '${ApiUrl.advapprovalstatusUrl}db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(expenseupdtStatusUrl);
      print(convert.jsonEncode({'data': advExpenseEntityListMap}));
    }
    final reponse = await http.post(
      Uri.parse(expenseupdtStatusUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode({'data': advExpenseEntityListMap}),
    );
    if (reponse.statusCode == 200) {
      return convert.jsonDecode(reponse.body)['message'];
    } else {
      return 'Oops there is an error!';
    }
  }

  //   static Future<String> postExpensesUpdateStatusAPI(
  //     SalesHeaderEntity expenseAdvEntity) async {
  //   List<Map<String, dynamic>> advExpenseEntityListMap = [];
  //   advExpenseEntityListMap.add(expenseAdvEntity.toMap());
  //   String expenseupdtStatusUrl =
  //       '${ApiUrl.expenseUpdtStatusUrl}db_nm=${Utility.sysDbName}';
  //   if (kDebugMode) {
  //     print(expenseupdtStatusUrl);
  //     print(convert.jsonEncode({'data': advExpenseEntityListMap}));
  //   }
  //   final reponse = await http.post(Uri.parse(expenseupdtStatusUrl),
  //       headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
  //       body: convert.jsonEncode({'data': advExpenseEntityListMap}));
  //   if (reponse.statusCode == 200) {
  //     return convert.jsonDecode(reponse.body)['message'];
  //   } else {
  //     return 'Oops there is an error!';
  //   }
  // }

  static Future<String> postExpensesUpdateStatusAPI(
    ExpensesHeaderEntity expenseAdvEntity,
  ) async {
    List<Map<String, dynamic>> advExpenseEntityListMap = [];
    advExpenseEntityListMap.add(expenseAdvEntity.toALLJson());
    String expenseupdtStatusUrl =
        '${ApiUrl.expenseUpdtStatusUrl}db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(expenseupdtStatusUrl);
      print(convert.jsonEncode({'data': advExpenseEntityListMap}));
    }
    final reponse = await http.post(
      Uri.parse(expenseupdtStatusUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode({'data': advExpenseEntityListMap}),
    );
    if (reponse.statusCode == 200) {
      return convert.jsonDecode(reponse.body)['message'];
    } else {
      return 'Oops there is an error!';
    }
  }

  //Snehal 24-10-2024 add for advance expenses report
  static Future<String> deleteAdvanceExpensePostAPI(
    AdvExpensesEntity expensesadventity,
  ) async {
    List<Map<String, dynamic>> advExpenseEntityList = [];
    advExpenseEntityList.add(expensesadventity.toJson());
    var deleteExpenseUrl =
        '${ApiUrl.advexpenseDeleteUrl}db_nm=${Utility.sysDbName}';

    if (kDebugMode) {
      print(deleteExpenseUrl);
      print(convert.jsonEncode({"data": advExpenseEntityList}));
    }
    final response = await http.post(
      Uri.parse(deleteExpenseUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode({"data": advExpenseEntityList}),
    );
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an error';
    }
  }

  //snehal 23-10-2024 add for advance expenses
  static Future<String> postAdvanceExpensesAPI(
    AdvExpensesEntity expenseAdvEntity,
  ) async {
    List<Map<String, dynamic>> advExpenseEntityListMap = [];
    advExpenseEntityListMap.add(expenseAdvEntity.toJson());
    String expenseEntryUrl =
        '${ApiUrl.advExpenseUrl}db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(expenseEntryUrl);
      print(convert.jsonEncode({'data': advExpenseEntityListMap}));
    }
    final reponse = await http.post(
      Uri.parse(expenseEntryUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode({'data': advExpenseEntityListMap}),
    );
    if (reponse.statusCode == 200) {
      return convert.jsonDecode(reponse.body)['message'];
    } else {
      return 'Oops there is an error!';
    }
  }

  static Future expenseHedPostApi(ExpensesHeaderEntity expHedEntity) async {
    List<Map<String, dynamic>> ledgerHedListMap = [];
    ledgerHedListMap.add(expHedEntity.toALLJson());
    var expHedUrl = '${ApiUrl.exphedPost}db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(expHedUrl);
      print(convert.jsonEncode({'data': ledgerHedListMap}));
    }
    var response = await http
        .post(
          Uri.parse(expHedUrl),
          body: convert.jsonEncode({'data': ledgerHedListMap}),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    print('response.body ${response.body}');
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body);
    } else {
      return 'Oops there is an Error!';
    }
  }

  //Snehal 8-01-2025 add
  static Future<String> expDocImageUpload({
    required ExpensesDocumentEntity expensesDocumentEntity,
  }) async {
    var imageUrl = '${ApiUrl.uploadDocumentUrl}db_nm=${Utility.sysDbName}';
    print('imageUrl $imageUrl');
    var request = http.MultipartRequest("POST", Uri.parse(imageUrl));
    request.headers.addAll({
      "Authorization": "Bearer ${Utility.loginDmsToken}",
    });

    request.fields['group_id'] = Utility.groupCode;
    request.fields['company_id'] = Utility.companyId;
    request.fields['hed_unique_id'] = expensesDocumentEntity.headerUniqueId!;
    request.fields['document_id'] = expensesDocumentEntity.documentId!;
    request.fields['max_no'] = expensesDocumentEntity.maxNo!;
    request.fields['remark'] = expensesDocumentEntity.remark!;
    request.fields['image_event'] = expensesDocumentEntity.imageEvent!;
    request.fields['email_id'] = Utility.useremailid;

    // request.fields['company_domain'] = Utility.domainHost == Utility.liveDomain ? 'ipresent.in' : 'dmsbusinessconnect.com'; //'ipresent.in';

    if (expensesDocumentEntity.imageEvent == 'Add') {
      // if (pdfvalue == true) {
      //   var pic = http.MultipartFile.fromBytes(
      //     "DOCUMENT_PATH",
      //     convertFileToCast(selectedFile!),
      //     filename: '$fileExtension',
      //   );
      //   request.files.add(pic);
      // } else {
      var pic = await http.MultipartFile.fromPath(
        "image_selected_file_path",
        expensesDocumentEntity.imageSelectedFilepath!,
      );
      request.files.add(pic);
      // }
    }
    if (kDebugMode) {
      print('Request Fields: ${request.fields}');
      print('Request Files: ${request.files}');
    }

    var response = await request.send();
    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    // print(responseString);
    // if (kDebugMode) {
    //     print(responseString);
    //     print(convert.jsonDecode(responseString)['message']);
    //     var jsonResponse = convert.jsonDecode(responseString);
    //     print(convert.jsonEncode(jsonResponse));
    //     print(jsonResponse['message']);
    //   }
    return convert.jsonDecode(responseString)['message'];
  }

  static Future<String> ledgerExpenseDetPostApi(
    List<Map<String, dynamic>> ledgerListMap,
  ) async {
    var ledgerPostUrl = '${ApiUrl.ledgerExpPost}db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(ledgerPostUrl);
      print(convert.jsonEncode({'data': ledgerListMap}));
    }
    final response = await http
        .post(
          Uri.parse(ledgerPostUrl),
          body: convert.jsonEncode({'data': ledgerListMap}),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    print('ledger response ${response.body}');
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an Error!';
    }
  }

  static Future<String> deleteLedgerApi({
    required List<Map<String, dynamic>> salesLedgerEntityListMap,
  }) async {
    var deletesalesLedgerUrl =
        '${ApiUrl.deletLedger}db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(deletesalesLedgerUrl);
      print(convert.jsonEncode({"data": salesLedgerEntityListMap}));
    }
    final response = await http.post(
      Uri.parse(deletesalesLedgerUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode({"data": salesLedgerEntityListMap}),
    );
    print('ledger delete response ${response.body}');
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an Error!';
    }
  }

  static Future sendNotificationApi(var json) async {
    return await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      body: convert.jsonEncode(json),
      headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Authorization':
            'key=AAAA-G3axyg:APA91bE-9Rjbhb07w3sTeBqGkKOHdKtQGkdWcDCYlV1u77QA1OVOOoPANS5K0hX0Ms3otINdMreZ1uTemuFa8aWF5FvzKHs0sLTgcGusFJnV3TgqXABbfYjPAZpFSblVAQovWkTgCBpy',
      },
    );
  }

  static Future<String> postNotificationHistoryApi(
    NotificationEntity notificationentity,
  ) async {
    List<Map<String, dynamic>> notificationListMap = [];
    notificationListMap.add(notificationentity.toJson());
    String notificationUrl =
        '${ApiUrl.notificationHistoryUrl}db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(notificationUrl);
      print(convert.jsonEncode({'data': notificationListMap}));
    }
    final reponse = await http.post(
      Uri.parse(notificationUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode({'data': notificationListMap}),
    );
    if (reponse.statusCode == 200) {
      return convert.jsonDecode(reponse.body)['message'];
    } else {
      return 'Oops there is an error!';
    }
  }

  static Future<String> deleteExpenseApi({
    required List<Map<String, dynamic>> salesEntityListMap,
  }) async {
    var deletesalesUrl = '${ApiUrl.deleteAllExpense}DB_NM=${Utility.sysDbName}';
    if (kDebugMode) {
      print(deletesalesUrl);
      print(convert.jsonEncode({"data": salesEntityListMap}));
    }
    final response = await http.post(
      Uri.parse(deletesalesUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode({"data": salesEntityListMap}),
    );
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an Error!';
    }
  }

  static Future<List<ExpensesHeaderEntity>> getExpenseAprrovalData(
    String fromdate,
    String todate,
    String status,
  ) async {
    List<ExpensesHeaderEntity> expenseApprovalDataList = [];
    var selectedUrl =
        '${ApiUrl.expenseApprovalRptUrl}company_id=${Utility.companyId}&approver=${Utility.cmpmobileno}&user_type=${Utility.cmpusertype}&from_date=$fromdate&to_date=$todate&db_nm=${Utility.sysDbName}&status=$status';
    if (kDebugMode) {
      print(selectedUrl);
    }
    var response = await http
        .get(
          Uri.parse(selectedUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (response.statusCode == 200) {
      var expenseaprovalItem = convert.jsonDecode(response.body)['data'];
      if (expenseaprovalItem.isNotEmpty) {
        for (int i = 0; i < expenseaprovalItem.length; i++) {
          ExpensesHeaderEntity expenseentity = ExpensesHeaderEntity.fromALLJson(
            expenseaprovalItem[i],
          );
          expenseApprovalDataList.add(expenseentity);
        }
      }
    }
    return expenseApprovalDataList;
  }

  ////////////////////////////////////////buddy //////////////////////////////

  static Future postPaymentFollowupDataApi(
    String partyid,
    List<Map<String, dynamic>> paymentfollowupListMap,
  ) async {
    var paymentFollowupcreateUrl =
        '${ApiUrl.postpaymentFollowuprUrl}company_id=${Utility.companyId}&mobile_no=${Utility.cmpmobileno}&party_id=$partyid&db_nm=${Utility.sysDbName}';
    var response = await http.post(
      Uri.parse(paymentFollowupcreateUrl),
      body: convert.jsonEncode({'data': paymentfollowupListMap}),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (kDebugMode) {
      print('paymentFollowupcreateUrl $paymentFollowupcreateUrl');
      print(convert.jsonEncode({"data": paymentfollowupListMap}));
      print(response.body);
    }
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an Error!';
    }
  }

  static Future editCustomerLocationPostApiCall(
    String partyid,
    List<Map<String, dynamic>> editCustomerRequestEntityList,
  ) async {
    var customerlocationUrl =
        '${ApiUrl.postCustLocationEditUrl}company_id=${Utility.companyId}&party_id=$partyid&db_nm=${Utility.sysDbName}';
    var response = await http.post(
      Uri.parse(customerlocationUrl),
      body: convert.jsonEncode({'data': editCustomerRequestEntityList}),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (kDebugMode) {
      print('customerlocationUrl $customerlocationUrl');
      print(convert.jsonEncode({"data": editCustomerRequestEntityList}));
      print(response.body);
    }
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an Error!';
    }
  }

  static Future visitDeletePostData({required String visitid}) async {
    var deleteDetUrl =
        '${ApiUrl.visitdeleteUrl}company_id=${Utility.companyId}&visit_id=$visitid&db_nm=${Utility.sysDbName}';
    var response = await http.post(
      Uri.parse(deleteDetUrl),
      body: convert.jsonEncode({
        "data": [{}],
      }),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );
    if (kDebugMode) {
      print('deleteDetUrl $deleteDetUrl');
      print(
        convert.jsonEncode({
          "data": [{}],
        }),
      );
      print(response.body);
    }
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an Error!';
    }
  }

 static Future<String> updateCompanyProfileAPI({
  required Map<String, dynamic> body,
}) async {
  var url =
      '${ApiUrl.updateCompanyProfileUrl}db_nm=${Utility.sysDbName}';

  if (kDebugMode) {
    print(url);
    print(convert.jsonEncode(body));
  }

  final response = await http.post(
    Uri.parse(url),
    headers: Utility.getSystemxsDmsHeaders(
      token: Utility.loginDmsToken,
    ),
    body: convert.jsonEncode(body),
  );

  if (response.statusCode == 200) {
    return convert.jsonDecode(response.body)['message'];
  } else {
    return 'Oops there is an error!';
  }
}

static Future<bool> saveCustomerPersonaAPI({
    required Map<String, dynamic> body,
  }) async {
    var url = '${ApiUrl.personasaveurl}db_nm=${Utility.sysDbName}';

    if (kDebugMode) {
      print(url);
      print(body);
    }

    var response = await http.post(
      Uri.parse(url),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      return false;
    }
  }

static Future<String> postCustomerContactApi(
    List<Map<String, dynamic>> contactEditListMap,
  ) async {
    var customerContactUrl =
        '${ApiUrl.customerContactsPostUrl}db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(customerContactUrl);
      print(convert.jsonEncode({'data': contactEditListMap}));
    }
    final response = await http.post(
      Uri.parse(customerContactUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode({'data': contactEditListMap}),
    );

    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an Error!';
    }
  }
  static Future<String> deleteCustomerContactAPI(
    List<Map<String, dynamic>> customerContactListMap,
  ) async {
    var customerContactsUrl =
        '${ApiUrl.customerContactsDeleteUrl}db_nm=${Utility.sysDbName}';

    final response = await http.post(
      Uri.parse(customerContactsUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode({'data': customerContactListMap}),
    );

    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an error!';
    }
  }

   static Future<String> postCustomerAddressApi(
    List<Map<String, dynamic>> addressEditListMap,
  ) async {
    var customerAddressUrl =
        '${ApiUrl.customerAddressesPostUrl}db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(customerAddressUrl);
      print(convert.jsonEncode({'data': addressEditListMap}));
    }
    final response = await http.post(
      Uri.parse(customerAddressUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode({'data': addressEditListMap}),
    );

    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an Error!';
    }
  }
 static Future<String> deleteCustomerAddressAPI(
    List<Map<String, dynamic>> customerContactListMap,
  ) async {
    var customerAddressDelUrl =
        '${ApiUrl.customerAddressesDeleteUrl}db_nm=${Utility.sysDbName}';

    final response = await http.post(
      Uri.parse(customerAddressDelUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode({'data': customerContactListMap}),
    );

    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an error!';
    }
  }

//collection

 /////====================collection============================================//

  static Future collectionHedPostApi(
    ReceiptHeaderEntity collectionHedEntity,
  ) async {
    List<Map<String, dynamic>> collHedListMap = [];
    collHedListMap.add(collectionHedEntity.toJson());
    var collHedUrl = '${ApiUrl.collHedPost}db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(collHedUrl);
      print(convert.jsonEncode({'data': collHedListMap}));
    }
    var response = await http
        .post(
          Uri.parse(collHedUrl),
          body: convert.jsonEncode({'data': collHedListMap}),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (response.statusCode == 200) {
      // print(convert.jsonDecode(response.body));
      return convert.jsonDecode(response.body);
    } else {
      return 'Oops there is an Error!';
    }
  }

  //pratiksha p 17-02-2026 add
  static Future<String> collectionSavePostApi(
    List<Map<String, dynamic>> collListMap,
  ) async {
    var collPostUrl = '${ApiUrl.collSaveUrl}db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(collPostUrl);
      print(convert.jsonEncode({'data': collListMap}));
    }
    final response = await http
        .post(
          Uri.parse(collPostUrl),
          body: convert.jsonEncode({'data': collListMap}),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));
    if (response.statusCode == 200) {
      // print('response.body ${response.body}');
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an Error!';
    }
  }

  static Future<String> collectionLedPostApi({
    required List<Map<String, dynamic>> purchaseTransDetListMap,
  }) async {
    var purTransDetUrl =
        '${ApiUrl.collectionInsertPostUrl}db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(purTransDetUrl);

      print(convert.jsonEncode({"data": purchaseTransDetListMap}));
    }
    final response = await http.post(
      Uri.parse(purTransDetUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode({"data": purchaseTransDetListMap}),
    );
    if (response.statusCode == 200) {
      // print('response.body ${response.body}');
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an Error!';
    }
  }

 //========================Akshay Taskboard==========================

 static Future<List<TaskBoardEntity>> getSupportTaskDetApi({bool showAll = false,
    String? fromdate,
    String? todate,}) async {
    List<TaskBoardEntity> taskEntityList = [];

    String tasListkUrl;
     if (showAll) {
     tasListkUrl =
        '${ApiUrl.supportTaskUrl}company_id=${Utility.companyId}&from_date=$fromdate&to_date=$todate&retailer_code=${Utility.customerPersonaId}&db_nm=${Utility.sysDbName}'; // &partner_code=${Utility.partnerCode}
     }else{ tasListkUrl =
        '${ApiUrl.supportTaskUrl}company_id=${Utility.companyId}&from_date=$fromdate&to_date=$todate&db_nm=${Utility.sysDbName}'; // &partner_code=${Utility.partnerCode}
     }
    if (kDebugMode) {
      print(tasListkUrl);
    }
    var supportTaskResponse = await http.get(
      Uri.parse(tasListkUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );

     if (kDebugMode) {
    print('Support Task Response: ${supportTaskResponse.body}');
  }
    if (supportTaskResponse.statusCode == 200) {
      var supportTaskData = await convert.jsonDecode(
        supportTaskResponse.body,
      )['data'];
      if (supportTaskData.isNotEmpty) {
        for (int i = 0; i < supportTaskData.length; i++) {
          TaskBoardEntity taskListEntity = TaskBoardEntity.fromMap(
            supportTaskData[i],
          );
          taskEntityList.add(taskListEntity);
        }
      }
    }
    return taskEntityList;
  }

  static Future<List<TaskBoardEntity>> getSalesTaskDetApi({bool showAll = false,
    String? fromdate,
    String? todate,}) async {
    List<TaskBoardEntity> taskEntityList = [];
    String salesTaskListkUrl;
     if (showAll) {
     salesTaskListkUrl =
        '${ApiUrl.salesTaskUrl}company_id=${Utility.companyId}&from_date=$fromdate&to_date=$todate&retailer_code=${Utility.customerPersonaId}&db_nm=${Utility.sysDbName}'; // &partner_code=${Utility.partnerCode}
     }else{salesTaskListkUrl =
        '${ApiUrl.salesTaskUrl}company_id=${Utility.companyId}&from_date=$fromdate&to_date=$todate&db_nm=${Utility.sysDbName}'; // &partner_code=${Utility.partnerCode}
    }
    if (kDebugMode) {
      print(salesTaskListkUrl);
    }
    var salesTaskResponse = await http.get(
      Uri.parse(salesTaskListkUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
    );

     if (kDebugMode) {
    print('Support Task Response: ${salesTaskResponse.body}');
  }
    if (salesTaskResponse.statusCode == 200) {
      var salesTaskData = await convert.jsonDecode(
        salesTaskResponse.body,
      )['data'];
      if (salesTaskData.isNotEmpty) {
        for (int i = 0; i < salesTaskData.length; i++) {
          TaskBoardEntity taskListEntity = TaskBoardEntity.fromMap(
            salesTaskData[i],
          );
          taskEntityList.add(taskListEntity);
        }
      }
    }
    return taskEntityList;
  }

  static Future<SalesTaskDropdownModel> getSalesDropdownData() async {
    try {
      var dropdownDataUrl =
          '${ApiUrl.salesDropGetUrl}company_id=${Utility.companyId}&db_nm=${Utility.sysDbName}';

      print("MASTER DATA URL: $dropdownDataUrl");

      final response = await http
          .get(
            Uri.parse(dropdownDataUrl),
            headers: Utility.getSystemxsDmsHeaders(
              token: Utility.loginDmsToken,
            ),
          )
          .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = convert.jsonDecode(response.body);
        return SalesTaskDropdownModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load master data');
      }
    } catch (e) {
      print("API ERROR: $e");
      rethrow;
    }
  }

  static Future<SupportTaskDropdownModel> getSupportDropdownData() async {
    try {
      var dropdownDataUrl =
          '${ApiUrl.supportDropGetUrl}company_id=${Utility.companyId}&db_nm=${Utility.sysDbName}';

      print("MASTER DATA URL: $dropdownDataUrl");

      final response = await http
          .get(
            Uri.parse(dropdownDataUrl),
            headers: Utility.getSystemxsDmsHeaders(
              token: Utility.loginDmsToken,
            ),
          )
          .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = convert.jsonDecode(response.body);
        return SupportTaskDropdownModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load master data');
      }
    } catch (e) {
      print("API ERROR: $e");
      rethrow;
    }
  }

  static Future<List<Log>> getAuditLogs({
  required String model,
  required String modelId,
}) async {
  try {
    var url =
        '${ApiUrl.getAuditlog}company_id=${Utility.companyId}&model=$model&modelid=$modelId&db_nm=${Utility.sysDbName}';

    final response = await http
        .get(Uri.parse(url), headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken))
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));

    if (response.statusCode == 200) {
      final jsonData = convert.jsonDecode(response.body);
      List logsList = jsonData['data'];
      return logsList.map<Log>((e) => Log.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load audit logs');
    }
  } catch (e) {
    print("AUDIT LOG API ERROR: $e");
    rethrow;
  }
}


//==============================================================

  static Future<String> getBizOpportunityList() async {
    try {
      var url =
          '${ApiUrl.tskviewbizopportunity}company_id=${Utility.companyId}&db_nm=${Utility.sysDbName}';

      final response = await http.get(
        Uri.parse(url),
        headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception(
          "Failed to load Biz Opportunities | Status: ${response.statusCode}",
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<String> postSalesTaskApi(
    List<Map<String, dynamic>> salesTaskListMap,
  ) async {
    var salesTaskUrl = '${ApiUrl.salesTaskPostUrl}db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(salesTaskUrl);
      print(convert.jsonEncode({'data': salesTaskListMap}));
    }
    final response = await http.post(
      Uri.parse(salesTaskUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode({'data': salesTaskListMap}),
    );
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an Error!';
    }
  }

  static Future<String> postSupportTaskApi(
    List<Map<String, dynamic>> supportTaskListMap,
  ) async {
    var supportTaskUrl =
        '${ApiUrl.supportTaskPostUrl}db_nm=${Utility.sysDbName}';
    if (kDebugMode) {
      print(supportTaskUrl);
      print(convert.jsonEncode({'data': supportTaskListMap}));
    }
    final response = await http.post(
      Uri.parse(supportTaskUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode({'data': supportTaskListMap}),
    );
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an Error!';
    }
  }

  static Future<String> addOpportunitiesApi(
    List<Map<String, dynamic>> opportunitiesMap,
  ) async {
    var addOpportunitiesUrl =
        '${ApiUrl.addOpportunitiesUrl}db_nm=${Utility.sysDbName}';

    if (kDebugMode) {
      print(addOpportunitiesUrl);
      print(convert.jsonEncode({'data': opportunitiesMap}));
    }
    final response = await http.post(
      Uri.parse(addOpportunitiesUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode({"data": opportunitiesMap}),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an error!';
    }
  }
  
  static Future<TaskBizOpportunityDropdownEntity>
  getTaskBizOpportunityDropdown() async {
    try {
      var opportunitiesDropdownUrl =
          '${ApiUrl.dropdownOpportunities}company_id=${Utility.companyId}&db_nm=${Utility.sysDbName}';


      final response = await http
          .get(
            Uri.parse(opportunitiesDropdownUrl),
            headers: Utility.getSystemxsDmsHeaders(
              token: Utility.loginDmsToken,
            ),
          )
          .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));

      if (response.statusCode == 200) {
        final jsonData = convert.jsonDecode(response.body);
        print("JSON DECODE SUCCESS");
        return TaskBizOpportunityDropdownEntity.fromJson(jsonData);
      } else {
        throw Exception('Failed to load master data');
      }
    } catch (e) {
      print("API ERROR: $e");
      rethrow;
    }
  }
  static Future<String> deleteSalesTaskApiCall(
    List<Map<String, dynamic>> salesTaskListMap,
  ) async {
    var deletesalesTaskUrl =
        '${ApiUrl.salesTaskDeleteUrl}db_nm=${Utility.sysDbName}';

    if (kDebugMode) {
      print(deletesalesTaskUrl);
      print(convert.jsonEncode({'data': salesTaskListMap}));
    }

    final response = await http.post(
      Uri.parse(deletesalesTaskUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode({'data': salesTaskListMap}),
    );

    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an error!';
    }
  }

  static Future<String> deleteSupportTaskApiCall(
    List<Map<String, dynamic>> supportTaskListMap,
  ) async {
    var deletesupportTaskUrl =
        '${ApiUrl.supportTaskDeleteUrl}db_nm=${Utility.sysDbName}';

    if (kDebugMode) {
      print(deletesupportTaskUrl);
      print(convert.jsonEncode({'data': supportTaskListMap}));
    }

    final response = await http.post(
      Uri.parse(deletesupportTaskUrl),
      headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
      body: convert.jsonEncode({'data': supportTaskListMap}),
    );

    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body)['message'];
    } else {
      return 'Oops there is an error!';
    }
  }


}
