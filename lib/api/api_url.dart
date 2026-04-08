import 'package:sysconn_sfa/Utility/utility.dart';

class ApiUrl {
  //get

  /////company //////////////////////////////////////////////////////
  //  static String cmpMasterUrl ='https://${Utility.getApiHostUrlDms}/Company/User_Company_Master/Get_Cmp_Master?';
  static String companyuserlistGetUrl =
      'https://${Utility.getApiHostUrlDms}/Company/User_List_Company_Wise/GetCMPUserList?';

  static String cmpMasterUrl =
      'https://${Utility.getApiHostUrlDms}/Company/Company_Master/companyMasterData?'; //Pooja // 09-12-2024
  static String partyMasterUrl =
      'https://${Utility.getApiHostUrlDms}/Company/Party_Master/GetPartyData?';
  static String partyMasterGetUrl =
      'https://${Utility.getApiHostUrlDms}/Customer/Customer_Dropdown_Address/GetCustomerData?';
  static String cmpListUrl =
      'https://${Utility.getApiHostUrlDms}/Company/Company_List/GetAllCompData?';
  static String vchTypeUrl =
      'https://${Utility.getApiHostUrlDms}/Company/VchType_Master/GetVchMstData?';
  static String itemMasterUrl =
      'https://${Utility.getApiHostUrlDms}/Company/Item_Master/GetItemData?';
  static String priceList =
      'https://${Utility.getApiHostUrlDms}/Company/Pricelist_Details/GetPricelist?';
  static String getFilterCustListApiUrl =
      'http://103.193.75.86:54314/API/FilterTypeCustList/GetCustCategorytData?'; //Rupali 18-12-2024
  static String groupmasterUrl =
      'https://${Utility.getApiHostUrlDms}/Company/Group_Master/GetGroupData?'; //Rupali 27-11-2024// add group master api
  static String ledgerMasterUrl =
      'https://${Utility.getApiHostUrlDms}/Company/Ledger_Master/GetLegderData?';
  static String itemMasterListUrl =
      'https://${Utility.getApiHostUrlDms}/Company/Item_Master_List/GetItemData?';
  static String godownmasterUrl =
      'https://${Utility.getApiHostUrlDms}/Company/Stock_Godown_Master/GetGodownData?'; //Snehal 25-11-2024 add godownlist
  // static String ledgermasterUrl = 'https://${Utility.getApiHostUrlDms}/Company/Ledger_Master/GetLegderData?';//Snehal  26-11-2024 add leder master api
  static String userlistGetUrl =
      'https://dms-distributor-get.dms-systemxs.com/Company/User_Company_Mst_Dtl/GetCMPUserList?';
  static String ledgerMstGetUrl =
      'https://${Utility.getApiHostUrlDms}/Company/Ledger_Master/GetLegderData?'; //Snehal 24-12-2025 add
  //lead
  static String getleadListApiUrl =
      'https://${Utility.getApiHostUrlDms}/Buddy/Lead_Report/GetLeadData?';

  //pratiksha p /////////////////
  //===================================Snehal add buddy url ================================
  static String allcategorytypeUrl1 =
      'https://${Utility.getApiHostUrlDms}/Customer/Get_Customer_Persona/GetCustomerPersona?';
  static String allcategorytypeUrl2 =
      'https://${Utility.getApiHostUrlDms}/Customer/Customer_catewise_subcategory/GetCustCategoriesHierarchy?';

  static String companyProfileUrl =
      'https://${Utility.getApiHostUrlDms}/Customer/Company_Profile/Customer_Profile_Data?';
  static String partyAddressessUrl =
      'https://${Utility.getApiHostUrlDms}/Company/Customer_Addresses_List/GetCustomerAddresses?'; // Manoj 11-03-2025
  static String partyContactsMasterUrl =
      'https://${Utility.getApiHostUrlDms}/Company/Customer_Contact_List/GetCustomerContact?';
  static String partyMasterDetUrl =
      'https://${Utility.getApiHostUrlDms}/Company/Party_Master/GetPartyData?';
  static String getBeatListApiUrl =
      'https://${Utility.getApiHostUrlDms}/Customer/Beatwise_List/Get_Detail?';
  static String getBeatCustWiseListApiUrl =
      'https://${Utility.getApiHostUrlDms}/Customer/BeatWise_Customer_List/Get_Detail?';
  static String getCustomerDetailsApiUrl =
      'https://${Utility.getApiHostUrlDms}/Customer/Oms_Retailer_Details/GetAllCompanyData?';
  static String getvisitListApiUrl =
      'https://${Utility.getApiHostUrlDms}/Customer/On_Site_Party_Attendance/GetAllCompanyData?';
  static String getvisitsummaryApiUrl =
      'https://${Utility.getApiHostUrlDms}/Customer/On_Site_Attendance_Summary/GetAllCompanyData?';
  static String osDashUrl =
      'https://${Utility.getApiHostUrlDms}/reports/outstanding_receivable/GetOutstandingRecievableData?';
  static String osRecPayLedgerUrl =
      'https://${Utility.getApiHostUrlDms}/Reports/PARTYGROUPWISE_PARTY_DET/GetPartyDetailsData?';
  static String gettodaysfollowupUrl =
      'https://${Utility.getApiHostUrlDms}/Reports/Outstanding_Todays_Followup/GetOSTodayFollowupData?';

  static String osRecPayBillUrl =
      'https://${Utility.getApiHostUrlDms}/reports/Billwise_Outstanding/GetBillWiseOutstandingData?';

  static String getpaymentfollowup =
      'https://${Utility.getApiHostUrlDms}/Reports/PAYMENT_FOLLOWUP_LIST/GetPaymentFollowupDetailsData?'; //pratiksha p 07-10-2024 add
  static String getPaymentFollowupUrl =
      'https://${Utility.getApiHostUrlDms}/Reports/PAYMENT_FOLLOWUP_ALLDET/GetPaymentFollowupAllData?';
  static String lastfollowupUrl =
      'https://${Utility.getApiHostUrlDms}/Reports/LAST_FOLLOWUP_DETAILS/GetLastFollowupDet?';
  static String getInactiveCustomerUrl =
      'https://${Utility.getApiHostUrlDms}/Reports/InactiveCustomer/GetInactiveCustomerData?';

  static String getDailyPerformanceUrl =
      'https://${Utility.getApiHostUrlDms}/Customer/Daily_Performance_Report/Get_Detail?';
  ///////////buddy///////////////////
  static String getBeatCustListApiUrl =
      'https://${Utility.getApiHostUrlDms}/Buddy/BeatWiseList/GetBeatData?';
  // static String getBeatCustWiseListApiUrl =
  //     'https://${Utility.getApiHostUrlDms}/Buddy/BeatWise_Customer_List/GetBeatCustData?';
  // static String getCustListApiUrl =
  //     'https://${Utility.getApiHostUrlDms}/Buddy/Customer_Details/GetCustomerData?';
  static String closingStockRepUrl =
      'https://${Utility.getApiHostUrlDms}/Stock/Closing_Stock/GetClosingStockData?'; //pooja // 27-09-2024 // add
  // static String getvisitListApiUrl =
  //     'https://${Utility.getApiHostUrlDms}/Visit/OnSite_Party_Attendance/GetVisitData?';
  static String getvisitdetailApiUrl =
      'https://${Utility.getApiHostUrlDms}/Cold_Visit/On_Site_Attendance_Report/GetAllCompanyData?'; //pratiksha p 21-02-2025 add
  static String salesHeaderGetUrl =
      'https://${Utility.getApiHostUrlDms}/Sales/Voucher_Header_API/GetAllLedgerOpeningData?';
  static String osBillsGetUrl =
      'https://${Utility.getApiHostUrlDms}/Sales/Billwise_Outstanding/GetAllOutstandingData?';
  //Rupali 21-10-2024
  static String getpendingClosingStockUrl =
      'http://103.193.75.86:58442/API/Closing_Stock_OrderQty/GetAllCompanyData?';
  static String getinactiveCustListUrl =
      'https://${Utility.getApiHostUrlDms}/Buddy/Inactive_Customer_List/GetCustomerData?';
  static String getinactiveItmListUrl =
      'https://${Utility.getApiHostUrlDms}/Buddy/Inactive_Item_List/GetAllItemData?';

  static String customersearchUrl =
      'https://${Utility.getApiHostUrlDms}/Customer/On_Site_Party_Search/GetAllCustData?';
  static String visitDetailsUrl =
      'https://${Utility.getApiHostUrlDms}/Customer/Oms_On_Site_Attendance_Details/GetAllCompanyData?';

  //===================================================================
  // collection
  static String collectionReport =
      'https://${Utility.getApiHostUrlDms}/Collection/Collection_Report/GetCollectionRegisterData?';
  static String collectionMasterUrl =
      'https://${Utility.getApiHostUrlDms}/Collection/Collection_Master/GetCollectionData?';
  static String collBillsGetUrl =
      'https://${Utility.getApiHostUrlDms}/Collection/Coll_Bills_List/GetDetailsData?';
  //===================================================================

  //  // sales
  static String salesLedgerGetUrl =
      'https://${Utility.getApiHostUrlDms}/Sales/Voucher_LedgerEntry_API/GetAllLedEntryData?';
  static String salesRegisterRpt =
      'https://${Utility.getApiHostUrlDms}/Sales/Sales_Register/GetSalesData?';
  static String soItemGet =
      'https://${Utility.getApiHostUrlDms}/Sales_Order/SO_Partywise_Inventory/GetPartyWiseInv?';
  static String getAllSales =
      'https://${Utility.getApiHostUrlDms}/Sales/Sales_Master/GetSalesDetails?';
  // static String getpaymentfollowup =
  //     'https://${Utility.getApiHostUrlDms}/Reports/PAYMENT_FOLLOWUP_LIST/GetPaymentFollowupDetailsData?'; //pratiksha p 07-10-2024 add
  static String getpaymentfollowuplast =
      'https://${Utility.getApiHostUrlDms}/Sales/Last_Followup_Details/GetAllData?'; //pratiksha p 07-10-2024 add
  static String salesInventoryGetUrl =
      'https://${Utility.getApiHostUrlDms}/Sales/Voucher_InventoryEntry_API/GetAllInvEntryData?';
  static String paymentfollowupAllDetGet =
      'https://${Utility.getApiHostUrlDms}/Sales/Payment_Followup_All_Details/paymentFollowupObj?';
  static String getosSalesPerson =
      'https://${Utility.getApiHostUrlDms}/Sales/PartyGroupWiseReport/Party_MasterData?'; //snehal  2-10-2024 add
  static String salesbillswiseurl =
      'https://${Utility.getApiHostUrlRept86}/API/Sales_Detail_API/GetAllData?'; //pooja // 16-10-2024 // add urlfor sales dashborad and purchase
  static String salesMasterWise =
      'https://${Utility.getApiHostUrlRept86}/API/Sales_Detail_Group_API/GetAllData?'; //pooja // 16-10-2024 // add urlfor sales dashborad and purchase
  static String getSalesdashboard =
      'https://${Utility.getApiHostUrlRept86}/API/DashBrd_Summary/GetAllData?'; //pooja // 16-10-2024 // add urlfor sales dashborad and purchase
  static String getTopTenDashboardurl =
      'https://${Utility.getApiHostUrlRept86}/API/Top_Sales_Analysis/GetAllSalesAnalysisData?'; //pooja // 16-10-2024 // add urlfor sales dashborad and purchase
  static String getdailyPerformanceurl =
      'https://${Utility.getApiHostUrlRept86}/API/Daily_Performance_Report/Get_Detail?'; //pratiksha p 24-02-2025

  ////////////////////////  expenses ///////////////////////////////////////////
  ///Snehal 6-01-2025 add
  static String advreportUrl =
      'https://${Utility.getApiHostUrlDms}/Expenses/Adv_Expenses_Report/getAdvData?';
  static String advapprovalUrl =
      'https://${Utility.getApiHostUrlDms}/Expenses/Adv_Exp_Approval_Report/getAdvExpData?';

  ///

  static String expenseAllDetUrl =
      'https://${Utility.getApiHostUrlDms}/Expenses/Expenses_Entry_Data/getAllData?';
  static String expenseApprovalRptUrl =
      'https://${Utility.getApiHostUrlDms}/Expenses/Expenses_Approval_Report/getExpApprovalData?';
  // static String advapprovalUrl =
  //     'https://${Utility.getApiHostUrlRept86}/API/Adv_Expense_All_Report/GetAdv_ExpenseData?';
  // static String advreportUrl =
  //     'http://103.193.75.86:49934/API/DMS_ADV_EXPENSES_REPORT/GetAllCompanyData?';
  static String expenseRegisterUrl =
      'https://${Utility.getApiHostUrlDms}/Expenses/Expenses_Emp_Register/getExpData?';

  //===================================================================
  // sales order
  // static String issueslipRegisterUrl = 'https://${Utility.apiUrl}/Issue_Slip/Issue_Slip_Register/GetIssueSlipFun?';
  static String stkBrandUrl =
      'https://${Utility.getApiHostUrlDms}/Company/Stock_Brand_List/Get_ItemDiv_Data?';
  static String soCartDataUrl =
      'https://${Utility.getApiHostUrlDms}/Sales_Order/Cart_Data/Get_Cart_Data?';
  static String soItemListUrl =
      'https://${Utility.getApiHostUrlDms}/Sales_Order/SO_Item_List/GetAllData?';
  static String soPrintUrl =
      'https://${Utility.getApiHostUrlDms}/Sales_Order/SO_Print/Get_SO_Print_Details?';
  static String soReportUrl =
      'https://${Utility.getApiHostUrlDms}/Sales_Order/SO_Report/SalesOrderFunc?';
  static String soDetailsReportUrl =
      'https://${Utility.getApiHostUrlDms}/Sales_Order/SO_Inv_Report/GetSOInvData?';
  static String soApprovalUrl =
      'https://${Utility.getApiHostUrlDms}/Sales_Order/SO_Approval_Status_Report/GetSOApprovalData?';
  static String soPartyRegisterUrl =
      'https://${Utility.getApiHostUrlDms}/Sales_Order/SO_Partywise_Report/party_details_func?';
  //===================================================================

  //////////////////////////////////visit//////////////////////////////////
  static String osreceivableGet =
      'https://${Utility.getApiHostUrlDms}/Sales/Outstanding_Ageing_Summary/GetAllOutstandingData?'; //snehal 28-09-2024 add for os rec report

  //////////////////////////        post             /////////////////////////////////////////////////////////
  ///
  //pratiksha p /////////////////
  ///buddy
  ///
  static String postLoginUrl =
      'https://${Utility.postApiHostUrlDms}/Login/Login_Details/LoginFun';
  static String editlocationUrl =
      'https://${Utility.postApiHostUrlDms}/Company/CustomerLocation_Details/location_EditPost?'; //pratiksha p 10-10-2024 add

  //company
  //Rupali 17-10-2024
  static String partyMasterPostUrl =
      'https://${Utility.postApiHostUrlDms}/Company/Party_Master/PartyAdd?';

  //visit//
  static String checkinApiUrl =
      'https://${Utility.postApiHostUrlDms}/Company/On_Site_Attendance_CheckInTime/CheckInTime?';
  static String checkoutApiUrl =
      'https://${Utility.postApiHostUrlDms}/Company/On_Site_Attendance_Check_Out/On_Site_Attendance_Check_Out_Func?';
  static String visitdeleteUrl =
      'https://${Utility.postApiHostUrlDms}/Customer/Oms_Header_Delete/SyncHeaderDel?';

  //payment followup

  static String postpaymentFollowuprUrl =
      'https://${Utility.postApiHostUrlDms}/Followup_Entry/FOLLOWUP_ENTRY/FOLLOWUP_ENTRY_FUNC?';
  static String postCustLocationEditUrl =
      'https://${Utility.postApiHostUrlDms}/Customer/Customer_Location_Details/CustomerLocationAdd?';
  static String reasonNoOrderurl =
      'https://${Utility.postApiHostUrlDms}/Customer/Reason_No_Order/ReasonNoOrder?';
  static String updateCompanyProfileUrl =
      'https://${Utility.postApiHostUrlDms}/Customer/Customer_Profile_Edit/Cust_Profile_EditFun?';
  static String personasaveurl =
      'https://${Utility.postApiHostUrlDms}/Customer/Add_Update_CustomerPersona/SaveCustomerPersona?';
  static String customerContactsPostUrl =
      'https://${Utility.postApiHostUrlDms}/Customer/Customer_Contact_Add/Contactadd?';
  static String customerContactsDeleteUrl =
      'https://${Utility.postApiHostUrlDms}/Customer/Customer_Contact_Del/Contactdelete?';
  static String customerAddressesPostUrl =
      'https://${Utility.postApiHostUrlDms}/Customer/Customer_Addresses_Add/AddressesAdd?';
  static String customerAddressesDeleteUrl =
      'https://${Utility.postApiHostUrlDms}/Customer/Customer_Addresses_Del/AddressesDelete?';

  // ===============================================

  ///
  // sales order
  static String soHeaderInsertUrl =
      'https://${Utility.postApiHostUrlDms}/Sales_Order/Header_Insert/HeaderInsertFun?';
  static String cartAddUrl =
      'https://${Utility.postApiHostUrlDms}/Sales_Order/AddToCart/PostDataFun?';
  static String cartDeleteUrl =
      'https://${Utility.postApiHostUrlDms}/Sales_Order/DeleteCart/CartDeleteFun?';
  static String billedToUpdateUrl =
      'https://${Utility.postApiHostUrlDms}/Sales_Order/BilledToUpdate/BilledToAdd?';
  static String inventoryAddUrl =
      'https://${Utility.postApiHostUrlDms}/Sales_Order/Inventory_Insert/InventoryAddFun?';
  static String soDeleteUrl =
      'https://${Utility.postApiHostUrlDms}/Sales_Order/SO_Delete/DeleteSOFun?';
  static String soStatusUpdateUrl =
      'https://${Utility.postApiHostUrlDms}/Sales_Order/SO_Approval_Status_Update/SoApprovalUpdateFunc?';
  static String noorderreasonrl =
      'https://${Utility.postApiHostUrlDms}/Sales_Order/Reason_For_No_Order/ReasonAdd?';

  ////collection

  static String collHedPost =
      'https://${Utility.postApiHostUrlDms}/Collection/Collection_Header/Coll_Create_Func?';

  static String collSaveUrl =
      'https://${Utility.postApiHostUrlDms}/Collection/Collection_Save/Coll_Func?';
  static String collectionInsertPostUrl =
      'https://${Utility.postApiHostUrlDms}/Collection/Collection_Detail_Insert/Collection_Ledger_Func?';

  // static String collectionBillDelPostUrl =
  //     'https://${Utility.postApiHostUrlDms}/Collection/Coll_Bills_Delete/CollBillDelFunc?'; //snehal 23-11-2024 add for delete bill
  // static String collectionInsertPostUrl =
  //     'https://${Utility.postApiHostUrlDms}/Collection/Collection_Insert/CollAddFun?';
  // static String collectionSavePostUrl =
  //     'https://${Utility.postApiHostUrlDms}/Collection/Collection_Save/CollSaveFun?';
  // static String collectionBillPostUrl =
  //     'https://${Utility.postApiHostUrlDms}/Collection/Collection_Bills_Add/CollBillFunc?';
  // static String collectionDeleteUrl =
  //     'https://${Utility.postApiHostUrlDms}/Collection/Collection_Delete/CollDel?';

  ///////sales///////////////////////////////////
  static String salesHedPost =
      'https://${Utility.postApiHostUrlDms}/Sales/Sales_Header/Sales_Create_Func?';
  static String salesInvPost =
      'https://${Utility.postApiHostUrlDms}/Sales/Sales_Inventory_Insert/Sales_Inv_Fun?';
  static String salesAdditiondetPost =
      'https://${Utility.postApiHostUrlDms}/Sales/Additional_Det_Update/AdditionDetFunc?';
  static String ledgerPost =
      'https://${Utility.postApiHostUrlDms}/Sales/Sales_Ledger_Insert/Sales_Ledger_Func?';
  static String deleteallSales =
      'https://${Utility.postApiHostUrlDms}/Sales/Sales_Delete/DeleteSalesFun?';
  static String deleteItem =
      'https://${Utility.postApiHostUrlDms}/Sales/Sales_Inventory_Delete/InvDeleteCall?';
  // static String deletLedger ='https://${Utility.apiPostUrl}/Sales/Sales_Ledger_Delete/salesLedgerDeleteFun?';
  static String salesSaveUrl =
      'https://${Utility.postApiHostUrlDms}/Sales/Sales_Save/Sales_Insert_Func?';
  static String followupcreatePost =
      'https://${Utility.postApiHostUrlDms}/Sales/FollowUp_Entry/followup_Fun?'; //pratiksha p 07-10-2024 add
  static String taxLedPostUrl =
      'https://${Utility.postApiHostUrlDms}/Sales/Sales_Tax_Ledger_Add/Sales_TaxLedFunc?';

  //===================================================================

  ///////////////////////////////// expenses  ////////////////////////////////////////

  static String uploadDocumentUrl =
      'https://${Utility.postApiHostUrlDms}/Expenses/Expenses_Document_Upload/Doc_Upload_Func?'; //snehal add
  //post notificaion
  static String notificationHistoryUrl =
      'http://103.193.75.86:59286/API/Notification_Insert/Notification_Insert_Func?';
  static String deleteAllExpense =
      'https://${Utility.postApiHostUrlDms}/Expenses/Expenses_Delete/deleteExpFunc?';
  static String expenseUpdtStatusUrl =
      'https://${Utility.postApiHostUrlDms}/Expenses/Expenses_Approval/expApprovedFunc?';
  static String advExpenseUrl =
      'https://${Utility.postApiHostUrlDms}/Expenses/Advance_Expenses_Entry/Adv_Expenses_Fun?'; //snehal add
  static String exphedPost =
      'https://${Utility.postApiHostUrlDms}/Expenses/Expenses_Header_Add/header_Insert_Func?'; //Snehaladd
  static String ledgerExpPost =
      'https://${Utility.postApiHostUrlDms}/Expenses/Expenses_Ledger_Insert/ledInsertFunc?'; //snehal add
  static String advapprovalstatusUrl =
      'https://${Utility.postApiHostUrlDms}/Expenses/Adv_Exp_Approval/advExpApprovedFunc?'; //snehal add

  static String advexpenseDeleteUrl =
      'https://${Utility.postApiHostUrlDms}/Expenses/Adv_Expense_Delete/advExpDelFunc?'; //Snehal add
  static String deletLedger =
      'https://${Utility.postApiHostUrlDms}/Expenses/Expenses_Ledger_Delete/ledDelFunc?';

  // static String advexpenseDeleteUrl =
  //     'https://${Utility.postApiHostUrlDms}/Expenses/Advance_Expense_Delete/Advance_Expense_Delete_Func?';
}
