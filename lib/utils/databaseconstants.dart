class DbConstants{

  static const String databaseName = "Apex.db";
  // static final String loginTableName = "Login";    // komal // commented bcze its removed
  // static final String ledgerTableName = "Ledger";    // komal // ledger table is removed and added data in party table
  static const String partyTableName = "Party";
  static const String localpartyTableName = "LocalParty";   // komal // new party table to insert new party and update new or existing party
  static const String groupTableName = 'GroupTable';    // komal // group table to save party and ledger group
  static const String stockItemTableName = "StockItem";
  // static final String localStockItemTableName = "LocalStockItem";    // komal // new stock item table name to insert and update new or existing stock item
  static const String stockGroupTableName = "StockGroup";
  static const String unitTableName = "Unit";
  static const String stockGodownTableName = 'StockGodown';   // komal // stock godown table
  static const String priceListTableName = 'PriceListTable';   // komal // price list table
  static const String salesTableName = "Sales";
  static const String salesItemTableName = "SalesItem";
  static const String salesLedgerTableName = "SalesLedger";
  static const String salesBilledToTableName = "SalesBilledTo";
  static const String salesShippedToTableName = "SalesShippedTo";
  static const String salesTaxLedgerTableName = 'SalesTaxLedger';   // komal // sales tax ledger table
  static const String salesPaymentTableName = "SalesPayment";
  static const String voucherTableName = 'Voucher';
  static const String receiptTableName = 'Receipt';

  //Leena--14-12-2020 -- add Journal entry screen
  static const String journalTableName = 'Journal';
  static const String journalledgerTableName = 'JournalLedger';  
  ///-----------------------------------------------------------------//


  static const String outstandingReceivableTableName = 'OutstandingReceivable';   // komal // outstanding receivable table
  static const String outstandingPayableTableName = 'OutstandingPayable';   // komal // outstanding payable table
  static const String receiptledgerTableName = 'ReceiptLedger';   // komal // receipt ledger table
  static const String companyBankTableName = 'CompanyBank';   // komal // 18-02-2022 // new table for storing bank details of company

  
  // komal // commented bcze map name are capital in API // name must be in caps to map with api
  // static final String id = "_Id";
  // static final String firstName = "First_Name";
  // static final String lastName = "Last_Name";
  // static final String eMail = "E_Mail";
  // static final String mobileNo = "Mobile_No";
  // static final String city = "City";
  // static final String state = "State";
  // static final String stateCode = "State_Code";
  // static final String country = "Country";
  // static final String pinCode = "Pin_Code";
  // static final String companyName = "Company_Name";
  // static final String gstIn = "GSTIN";
  // static final String partnerCode = "Partner_Code";
  // static final String password = "Password";
  // static final String confirmPassword = "Confirm_Password";
  // static final String businessType = "Business_Type";
  // static final String noOfUsers = "No_Of_Users";
  // static final String role = "Role";

  // static final String status = "Status";
  // static final String createdOn = "Created_On";
  // static final String createdBy = "Created_By";
  // static final String modifiedOn = "Modified_On";
  // static final String modifiedBy = "Modified_By";
  // static final String col1 = "Col1";
  // static final String col2 = "Col2";
  // static final String col3 = "Col3";
  // static final String col4 = "Col4";
  // static final String col5 = "Col5";

  static const String id = "_Id";
  static const String firstName = "First_Name";
  static const String lastName = "Last_Name";
  static const String eMail = "E_Mail_ID";
  static const String mobileNo = "MOBILE_No";
  static const String city = "CITY";
  static const String state = "STATE";
  static const String stateCode = "State_Code";
  static const String country = "COUNTRY";
  static const String pinCode = "PIN_CODE";
  static const String companyName = "COMPANY_NAME";
  static const String gstIn = "GSTIN";
  static const String partnerCode = "PARTNER_CODE";
  static const String password = "Password";
  static const String confirmPassword = "Confirm_Password";
  static const String businessType = "Business_Type";
  static const String noOfUsers = "No_Of_Users";
  static const String role = "Role";

  static const String status = "Status";
  static const String createdOn = "Created_On";
  static const String createdBy = "Created_By";
  static const String modifiedOn = "Modified_On";
  static const String modifiedBy = "Modified_By";
  // static final String col1 = "Col1";
  static const String col1 = "ALTER_ID";    // komal // change col1 as alter id
  static const String col2 = "PARTNER_CODE";
  static const String col3 = "Col3";
  static const String col4 = "Col4";
  static const String col5 = "Col5";

  // static final String createLoginTable = "Create table if not EXISTS "   // komal // commented bcze its removed
  //     "$loginTableName($id INTEGER PRIMARY KEY autoincrement, $firstName TEXT, "
  //     "$lastName TEXT, $eMail TEXT, $mobileNo INTEGER, $city TEXT, "
  //     "$state TEXT, $country TEXT, $pinCode INTEGER, $companyName TEXT, "
  //     "$gstIn TEXT, $partnerCode INTEGER, "
  //     "$password TEXT, $confirmPassword TEXT, "
  //     "$businessType TEXT, $noOfUsers INTEGER, $role INTEGER)";

// Ajay: For Company Table.
  static const String companytablename = "Company";

  
  // komal // company details name should be in caps to map JSON in API
  // static final String companyid = "Company_ID";
  // static final String companyname = "Company_Name";
  // static final String add1 = "Add_1";
  // static final String add2 = "Add_2";
  // static final String add3 = "Add_3";
  // static final String companywebsite = "Website";
  // static final String companybookbeginfrom = "Book_Begin_From";
  // static final String isActive = "isActive";

  static const String companyid = "COMPANY_ID";
  static const String companyname = "COMPANY_NAME";
  static const String add1 = "ADD_1";
  static const String add2 = "ADD_2";
  static const String add3 = "ADD_3";
  static const String companywebsite = "WEBSITE";
  static const String companybookbeginfrom = "BOOK_BEGIN_FROM";
  static const String companyusertype = 'USER_TYPE';    // komal // user type in company
  static const String isActive = "isActive";

  // komal // new fields added for dashboard pdf
  static const String panno = 'PAN_NO';

  // komal // batch no of price list and outstanding
  static const String pricelistbatch = 'PRICELIST_BATCH_NO';
  static const String osrecbatch = 'OS_RECEIVABLE_BATCH_NO';
  static const String ospaybatch = 'OS_PAYABLE_BATCH_NO';

  static const String cmpMobNo = 'COMPANY_MOB_NO';    // komal // mobile no to be save in company table to get company data on mobile no logged in
  static const String mailingname = 'MAILING_NAME';   // komal // mailing name
  static const String companyLogo = 'COMPANY_LOGO'; // Manoj // 17-08-2022 // company logo

  // komal // company table id must be unique and manually entered

  // static final String createcompanytable = "Create table if not EXISTS "
  //     "$companytablename($id INTEGER PRIMARY KEY autoincrement, "
  //     "$companyid TEXT, $companyname TEXT, $add1 TEXT, $add2 TEXT, "
  //     "$add3 TEXT, $country TEXT, $state TEXT, $stateCode TEXT, $pinCode INTEGER, "
  //     "$gstIn TEXT, $mobileNo INTEGER, $eMail TEXT, $companywebsite TEXT, "
  //     "$companybookbeginfrom TEXT,$isActive INTEGER, $status TEXT, $createdOn DATETIME, "
  //     "$createdBy TEXT, $modifiedOn DATETIME, $modifiedBy TEXT, "
  //     "$col1 TEXT, $col2 TEXT, $col3 TEXT, $col4 INTEGER, $col5 INTEGER)";

  static const String createcompanytable = "Create table if not EXISTS "
      "$companytablename($id TEXT Not Null, "
      "$companyid TEXT, $companyname TEXT, $add1 TEXT, $add2 TEXT, "
      "$add3 TEXT, $country TEXT, $state TEXT, $stateCode TEXT, $pinCode TEXT, "
      "$gstIn TEXT, $mobileNo TEXT, $eMail TEXT, $companywebsite TEXT, "
      "$mailingname TEXT, "   // komal // mailing name
      "$companyusertype TEXT, "   // komal // user type in company
      "$pricelistbatch INTEGER, $osrecbatch INTEGER, $ospaybatch INTEGER, "   // komal // batch no of price list and outstanding
      "$companybookbeginfrom TEXT, $cmpMobNo INTEGER Not Null, "   // komal // mobile no to be save in cmp master t get cmp data
      "$isActive INTEGER, $status TEXT, $createdOn DATETIME, "
      "$createdBy TEXT, $modifiedOn DATETIME, $modifiedBy TEXT, "
      "$col1 INTEGER, $col2 TEXT Not Null, $col3 TEXT, $col4 INTEGER, $col5 INTEGER, $companyLogo TEXT, " // Manoj // 17-08-2022 // company logo
      "PRIMARY KEY($id,$col2,$cmpMobNo))";    // komal // add primary key on id , partner code and mobile no 
      
        
  // komal // ledger details name should be in caps to map JSON in API
  // static final String ledgerId = 'Ledger_ID';
  // static final String ledgerName = 'Ledger_Name';
  // static final String ledgerGroupName = 'Ledger_Group_Name';
  // static final String gstApplicable = 'GST_Applicable';
  // static final String isUsed = 'Is_Used';

  static const String ledgerId = 'LEDGER_ID';
  static const String ledgerName = 'LEDGER_NAME';
  static const String ledgerGroupName = 'LEDGER_GROUP_NAME';
  static const String gstApplicable = 'GST_APPLICABLE';
  static const String isUsed = 'Is_Used';

  // komal // id should be manually entered in ledger table

  // static final String createLedgerTable = "Create table if not EXISTS "
  //     "$ledgerTableName($id INTEGER PRIMARY KEY autoincrement, "
  //     "$ledgerId TEXT, $companyid INTEGER, $ledgerName TEXT,"
  //     "$ledgerGroupName TEXT, $gstApplicable INTEGER, "
  //     "$isUsed INTEGER, "
  //     "$status TEXT, $createdOn DATETIME, $createdBy TEXT, "
  //     "$modifiedOn DATETIME, $modifiedBy TEXT, "
  //     "$col1 TEXT, $col2 TEXT, $col3 TEXT, $col4 INTEGER, $col5 INTEGER,"
  //     "FOREIGN KEY($companyid) REFERENCES $companytablename($id))";

  // komal // commented bcze its removed and ledger and party is now one table
  // komal // id should be manually entered
  // static final String createLedgerTable = "Create table if not EXISTS "
  //     "$ledgerTableName($id TEXT PRIMARY KEY , "
  //     "$ledgerId TEXT, $companyid TEXT, $ledgerName TEXT,"
  //     "$ledgerGroupName TEXT, $gstApplicable INTEGER, "
  //     "$isUsed INTEGER, "
  //     "$status TEXT, $createdOn DATETIME, $createdBy TEXT, "
  //     "$modifiedOn DATETIME, $modifiedBy TEXT, "
  //     "$col1 TEXT, $col2 TEXT, $col3 TEXT, $col4 INTEGER, $col5 INTEGER,"
  //     "FOREIGN KEY($companyid) REFERENCES $companytablename($id))";
  
  // komal  // party name should be in caps to map JSON in API
  // static final String partyId = 'Party_ID';
  // static final String partyName = 'Party_Name';
  // static final String partyGroupName = 'Party_Group_Name';
  // static final String contactPer = 'Contact_Person';
  // static final String contactNum = 'Contact_Number';

  static const String partyId = 'PARTY_ID';
  static const String partyName = 'PARTY_NAME';
  static const String partyGroupName = 'PARTY_GROUP_NAME';
  static const String contactPer = 'CONTACT_PERSON';
  static const String contactNum = 'CONTACT_NUMBER';
  static const String partymobid = 'PARTY_MOB_ID';    // komal // party mob id to get max id to insert in party id
  static const String tallysyncflag = 'TALLY_SYNC_FLAG';  // komal // tally sync flag set yes when it is imported from tally else no
  static const String mobilesyncflag = 'MOBILE_SYNC_FLAG';  // komal // mobile sync flag set no when new party added or updated else when it is synced then yes

  static const String ledType = 'Led_Type';   // komal // type for ledger or party
  static const String pricelist = 'PRICELIST';   // komal // price list in ledger tabel
  static const String creditDays = 'CREDIT_DAYS';   // komal // credit days in ledger table
  static const String creditLimit = 'CREDIT_LIMIT';   // komal // credit limit in table

  // komal // id should be manually entered in party table  // mobile id and sync flag column added to sync new party of table

  // static final String createPartyTable = "Create table if not EXISTS "
  //     "$partyTableName($id INTEGER PRIMARY KEY autoincrement, "
  //     "$partyId TEXT, $companyid INTEGER, $partyName TEXT, "
  //     "$partyGroupName TEXT, $add1 TEXT, $add2 TEXT, "
  //     "$add3 TEXT, $state TEXT, $country TEXT, $pinCode INTEGER, "
  //     "$contactPer TEXT, $contactNum INTEGER, $gstIn TEXT, "
  //     "$isUsed INTEGER, "
  //     "$status TEXT, $createdOn DATETIME, "
  //     "$createdBy TEXT, $modifiedOn DATETIME, $modifiedBy TEXT, "
  //     "$col1 TEXT, $col2 TEXT, $col3 TEXT, $col4 INTEGER, $col5 INTEGER,"
  //     "FOREIGN KEY($companyid) REFERENCES $companytablename($id))";

  // komal // commented bcze it is removed and party and ledger table are same
  // komal // id should be manually entered in party table
  // static final String createPartyTable = "Create table if not EXISTS "
  //     "$partyTableName($id TEXT PRIMARY KEY , "
  //     "$partyId TEXT, $companyid TEXT, $partyName TEXT, "
  //     "$partyGroupName TEXT, $add1 TEXT, $add2 TEXT, "
  //     "$add3 TEXT, $state TEXT, $country TEXT, $pinCode INTEGER, "
  //     "$contactPer TEXT, $contactNum INTEGER, $gstIn TEXT, "
  //     "$partymobid INTEGER, $tallysyncflag TEXT,"
  //     "$isUsed INTEGER, "
  //     "$status TEXT, $createdOn DATETIME, "
  //     "$mobilesyncflag TEXT,"
  //     "$createdBy TEXT, $modifiedOn DATETIME, $modifiedBy TEXT, "
  //     "$col1 TEXT, $eMail TEXT , "
  //     "$col2 TEXT, $col3 TEXT, $col4 INTEGER, $col5 INTEGER,"
  //     "FOREIGN KEY($companyid) REFERENCES $companytablename($id))";

  // komal // ledger and party is now one table
  static const String createPartyTable = "Create table if not EXISTS "
      "$partyTableName($id TEXT Not Null , "
      "$partyId TEXT, $companyid TEXT Not Null, $partyName TEXT,"
      "$partyGroupName TEXT, $add1 TEXT, $add2 TEXT, "
      "$add3 TEXT, $state TEXT, $country TEXT, $pinCode TEXT, "
      "$contactPer TEXT, $contactNum TEXT, $gstIn TEXT, "
      "$partymobid INTEGER, $tallysyncflag TEXT,"
      "$gstApplicable INTEGER, "
      "$eMail TEXT , $mailingname TEXT, "   // komal // mailing name
      "$pricelist TEXT, $creditDays INTEGER, $creditLimit INTEGER, $ledType TEXT, "    // komal // new fields are added
      "$isUsed INTEGER, "
      "$status TEXT, $createdOn DATETIME, $createdBy TEXT, "
      "$mobilesyncflag TEXT,"
      "$modifiedOn DATETIME, $modifiedBy TEXT, "
      "$col1 INTEGER, $col2 TEXT Not Null , $col3 TEXT, $col4 INTEGER, $col5 INTEGER,"
      "FOREIGN KEY($companyid) REFERENCES $companytablename($id), "
      "PRIMARY KEY($id,$companyid,$col2))";    // komal // primary key on id , companyid and partner code


  // // komal // new party table to add new party and update new or existing party
  // static final String createLocalPartyTable = "Create table if not EXISTS "
  //     "$localpartyTableName($id TEXT PRIMARY KEY , "
  //     "$partyId TEXT, $companyid TEXT, $partyName TEXT, "
  //     "$partyGroupName TEXT, $add1 TEXT, $add2 TEXT, "
  //     "$add3 TEXT, $state TEXT, $country TEXT, $pinCode INTEGER, "
  //     "$contactPer TEXT, $contactNum INTEGER, $gstIn TEXT, "
  //     "$isUsed INTEGER, "
  //     "$status TEXT, $createdOn DATETIME, "
  //     "$createdBy TEXT, $modifiedOn DATETIME, $modifiedBy TEXT, "
  //     "$col1 TEXT, $eMail TEXT , "
  //     "$col2 TEXT, $col3 TEXT, $col4 INTEGER, $col5 INTEGER,"
  //     "FOREIGN KEY($companyid) REFERENCES $companytablename($id))";

  // komal // group mastr table of party and ledger
  static const String groupId = 'GROUP_ID';
  static const String groupName = 'GROUP_NAME';
  static const String parentId = 'PARENT_ID';
  static const String natureOfGroup = 'NATURE_OF_GROUP';
  static const String isPrimaryGroup = 'ISPRIMARYGROUP';
  static const String groupParentName = 'PARENT_NAME';    // komal // parent name in list to display name by parent id

  static const String createGroupTable = "Create table if not EXISTS "
  "$groupTableName($groupId TEXT Not Null , "
  "$companyid TEXT Not Null, $groupName TEXT,"
  "$parentId TEXT, $natureOfGroup TEXT, $isPrimaryGroup TEXT, "
  "$isUsed INTEGER, $status TEXT, $createdOn DATETIME, $createdBy TEXT, "
  "$modifiedOn DATETIME, $modifiedBy TEXT, "
  "$col1 INTEGER, $col2 TEXT Not Null, $col3 TEXT, $col4 INTEGER, $col5 INTEGER,"
  "FOREIGN KEY($companyid) REFERENCES $companytablename($id),"
  "PRIMARY KEY($groupId,$companyid,$col2))";    // komal // primary key on id , companyid and partner code)";

  // komal // price list table
  static const String priceListID = 'ID';
  static const String priceListDate = 'PRICELISTDATE';
  static const String priceListRate = 'PRICELISTRATE';

  static const String createPriceListTable = "Create table if not EXISTS "
  "$priceListTableName($priceListID INTEGER PRIMARY KEY , "
  "$companyid TEXT, $pricelist TEXT,$itemidfk TEXT, "
  "$priceListDate TEXT, $priceListRate DOUBLE, $discount DOUBLE, "
  "$isUsed INTEGER, $createdOn DATETIME,"
  "$col1 INTEGER, $col2 TEXT, $col3 TEXT, $col4 INTEGER, $col5 INTEGER,"
  "FOREIGN KEY($companyid) REFERENCES $companytablename($id))";

  
  // komal  // item details should be in caps to map JSON in API
  // static final String itemCode = 'Item_Code';
  // static final String itemName = 'Item_Name';
  // static final String itemDesc = 'Item_Description';
  // static final String stockGroupId = 'Stock_Group_ID';
  // static final String stockGroupName = 'Stock_Group_Name';
  // static final String unitId = 'Unit_ID';
  // static final String unitName = 'Unit_Name';
  // static final String taxRate = 'TAXRATE';
  // static final String cess = 'CESS';
  // static final String hsnCode = 'HSN_Code';
  // static final String mrpValue = 'MRP_Value';
  // static final String noOfDecimal = 'No_of_Decimal';
  // static final String formalName = 'Formal_Name';

  static const String itemCode = 'ITEM_ID';
  static const String itemName = 'ITEM_NAME';
  static const String itemDesc = 'ITEM_DESCRIPTION';
  static const String stockGroupId = 'STOCK_GROUP_ID';
  static const String stockGroupName = 'STOCK_GROUP_NAME';
  static const String unitId = 'UNIT_ID';
  static const String unitName = 'UNIT_NAME';
  static const String taxRate = 'TAX_RATE';
  static const String cess = 'CESS';
  static const String hsnCode = 'HSN_CODE';
  static const String mrpValue = 'MRP_VALUE';
  static const String noOfDecimal = 'NO_OF_DECIMAL';
  static const String formalName = 'FORMAL_NAME';
  static const String stockitemmobid = 'STOCK_ITEM_MOB_ID';   // komal // stock item mob id is use to get max id of new item in insert
  static const String additionalunits = 'ADDITIONAL_UNITS';   // komal // additional unit is alternate unit of item
  static const String conversion = 'CONVERSION';    // komal // conversion is no. of alternate unit ex. 12box = 1nos then 12
  static const String denominator = 'DENOMINATOR';    // komal // denominator is no. of unit ex. 12 box = 1nos then 1
  static const String additionalunitappl = 'ADDITIONAL_UNITS_APPLICABLE';    // komal // additional unit applicable is alternate unit applicable

  // komal // id must be manually entered in stock item table // stockitem table changes for new stock item insert and update

  // static final String createStockItemTable = "Create table if not EXISTS "
  //     "$stockItemTableName($id INTEGER PRIMARY KEY autoincrement, "
  //     "$itemCode TEXT, $companyid INTEGER, $stockGroupId INTEGER, $unitId INTEGER,"
  //     "$itemName TEXT, $itemDesc TEXT, $gstApplicable INTEGER, "
  //     "$taxRate INTEGER, $cess INTEGER, $hsnCode TEXT, $mrpValue INTEGER, "
  //     "$isUsed INTEGER, "
  //     "$status TEXT, $createdOn DATETIME, "
  //     "$createdBy TEXT, $modifiedOn DATETIME, $modifiedBy TEXT, "
  //     "$col1 TEXT, $col2 TEXT, $col3 TEXT, $col4 INTEGER, $col5 INTEGER,"
  //     "FOREIGN KEY($companyid) REFERENCES $companytablename($id), "
  //     "FOREIGN KEY($stockGroupId) REFERENCES $stockGroupTableName($id),"
  //     "FOREIGN KEY($unitId) REFERENCES Unit($id))";

  static const String createStockItemTable = "Create table if not EXISTS "
      "$stockItemTableName($id TEXT Not Null , "
      "$itemCode TEXT, $companyid TEXT Not Null, $stockGroupId TEXT, $unitId TEXT,"
      "$itemName TEXT, $itemDesc TEXT, $gstApplicable INTEGER, "
      "$taxRate INTEGER, $cess INTEGER, $hsnCode TEXT, $mrpValue INTEGER, "
      "$isUsed INTEGER, "
      "$unitName TEXT,"   // komal // unit name in table
      "$additionalunits TEXT, $conversion DOUBLE, $denominator DOUBLE, $additionalunitappl TEXT, "    // komal // new fields of alternate unit are added
      "$stockitemmobid INTEGER, $tallysyncflag TEXT, $mobilesyncflag TEXT, "
      "$status TEXT, $createdOn DATETIME, "
      "$createdBy TEXT, $modifiedOn DATETIME, $modifiedBy TEXT, "
      "$col1 INTEGER, $col2 TEXT Not Null, $col3 TEXT, $col4 INTEGER, $col5 INTEGER,"
      "FOREIGN KEY($companyid) REFERENCES $companytablename($id), "
      "FOREIGN KEY($stockGroupId) REFERENCES $stockGroupTableName($id),"
      "FOREIGN KEY($unitId) REFERENCES Unit($id),"
      "PRIMARY KEY($id,$companyid,$col2))";    // komal // primary key on id , companyid and partner code

  // // komal // new stock item table  to insert and update new or existing stock item
  // static final String createLocalStockItemTable = "Create table if not EXISTS "
  //     "$localStockItemTableName($id TEXT PRIMARY KEY , "
  //     "$itemCode TEXT, $companyid TEXT, $stockGroupId TEXT, $unitId TEXT,"
  //     "$itemName TEXT, $itemDesc TEXT, $gstApplicable INTEGER, "
  //     "$taxRate INTEGER, $cess INTEGER, $hsnCode TEXT, $mrpValue INTEGER, "
  //     "$isUsed INTEGER, "
  //     "$unitName TEXT,"
  //     "$status TEXT, $createdOn DATETIME, "
  //     "$createdBy TEXT, $modifiedOn DATETIME, $modifiedBy TEXT, "
  //     "$col1 TEXT, $col2 TEXT, $col3 TEXT, $col4 INTEGER, $col5 INTEGER,"
  //     "FOREIGN KEY($companyid) REFERENCES $companytablename($id), "
  //     "FOREIGN KEY($stockGroupId) REFERENCES $stockGroupTableName($id),"
  //     "FOREIGN KEY($unitId) REFERENCES Unit($id))";

  // komal // id must be manually entered in stock group table

  // static final String createStockGroupTable = "Create table if not EXISTS "
  //     "$stockGroupTableName($id INTEGER PRIMARY KEY autoincrement, "
  //     "$companyid INTEGER, $stockGroupId TEXT, $stockGroupName TEXT, "
  //     "$isUsed INTEGER, "
  //     "$status TEXT, $createdOn DATETIME, "
  //     "$createdBy TEXT, $modifiedOn DATETIME, $modifiedBy TEXT, "
  //     "$col1 TEXT, $col2 TEXT, $col3 TEXT, $col4 INTEGER, $col5 INTEGER, "
  //     "FOREIGN KEY($companyid) REFERENCES $companytablename($id))";

  static const String createStockGroupTable = "Create table if not EXISTS "
      "$stockGroupTableName($id TEXT Not Null , "
      "$companyid TEXT Not Null, $stockGroupId TEXT, $stockGroupName TEXT, "
      "$isUsed INTEGER, "
      "$status TEXT, $createdOn DATETIME, "
      "$createdBy TEXT, $modifiedOn DATETIME, $modifiedBy TEXT, "
      "$col1 INTEGER, $col2 TEXT Not Null, $col3 TEXT, $col4 INTEGER, $col5 INTEGER, "
      "FOREIGN KEY($companyid) REFERENCES $companytablename($id),"
      "PRIMARY KEY($id,$companyid,$col2))";    // komal // primary key on id , companyid and partner code

  // komal // id must be manually entered in unit table

  // static final String createUnitTable = "Create table if not EXISTS "
  //     "$unitTableName($id INTEGER PRIMARY KEY autoincrement, "
  //     "$companyid INTEGER, $unitId TEXT, $unitName TEXT, $noOfDecimal INTEGER, "
  //     "$formalName TEXT, $isUsed INTEGER, "
  //     "$status TEXT, $createdOn DATETIME, "
  //     "$createdBy TEXT, $modifiedOn DATETIME, $modifiedBy TEXT, "
  //     "$col1 TEXT, $col2 TEXT, $col3 TEXT, $col4 INTEGER, $col5 INTEGER,"
  //     "FOREIGN KEY($companyid) REFERENCES $companytablename($id))";

  static const String createUnitTable = "Create table if not EXISTS "
      "$unitTableName($id TEXT Not Null , "
      "$companyid TEXT Not Null, $unitId TEXT, $unitName TEXT, $noOfDecimal INTEGER, "
      "$formalName TEXT, $isUsed INTEGER, "
      "$status TEXT, $createdOn DATETIME, "
      "$createdBy TEXT, $modifiedOn DATETIME, $modifiedBy TEXT, "
      "$col1 INTEGER, $col2 TEXT Not Null, $col3 TEXT, $col4 INTEGER, $col5 INTEGER,"
      "FOREIGN KEY($companyid) REFERENCES $companytablename($id),"
      "PRIMARY KEY($id,$companyid,$col2))";    // komal // primary key on id , companyid and partner code

  // komal // stock godown table
  static const String godownname = 'GODOWN_NAME';

  static const String createStockGodownTable = "Create table if not EXISTS "
      "$stockGodownTableName($id TEXT Not Null , "
      "$companyid TEXT Not Null, $godownname TEXT, "
      "$createdOn DATETIME, "
      "$col1 INTEGER, $col2 TEXT Not Null, $col3 TEXT, $col4 INTEGER, $col5 INTEGER,"
      "FOREIGN KEY($companyid) REFERENCES $companytablename($id),"
      "PRIMARY KEY($id,$companyid,$col2))";    // komal // primary key on id , companyid and partner code

  // For Sales Table
  static const String salesid = "ID";
  //static final String companyid = "Company_ID";
  //static final String partyId = 'Party_ID';
  static const String voucherid = "VoucherId";
  static const String date = "Date";
  static const String duedate = "Due_Date";
  static const String invoicenumber = "Invoice_Number";
  static const String narration = "Narration";
  static const String totalinvoiceamount = "Total_Invoice_Amount";
  static const String isactive = "IsActive";
  static const String gstvalue = "GST_VALUE";   // komal // gst value in sales table
  static const String cessvalue = "CESS_VALUE";   // komal // cess value in sales table
  static const String serviceinvoice = "SERVICE_INVOICE";   // komal // service invoice in sales table
  static const String maxcount = "MaxCount";    // komal // receipt entry added
  static const String partysyncflag = 'Party_Sync_Flag';    // komal // party sync flag set as yes or no as per tallysyncflag in party
  static const String stkitemsyncflag = 'Stock_Item_Sync_Flag';   // komal // stock item sync flag as yes or no as per tallysyncflag in item table
  static const String vchinvprefixname = 'Inv_Prefix';    // komal // voucher type prefix in voucher
  static const String vchinvlastno = 'Inv_Last_No';   // komal // last invoice last no 

  // komal // new fields are added
  static const String orginvno = 'ORIGINAL_INV_NO';
  static const String orginvdate = 'ORIGINAL_INV_DATE';
  static const String dncnreason = 'DN_CN_REASON';
  static const String dncnreasonno = 'DN_CN_REASON_NO';

  static const String costcentre = 'COST_CENTRE';   // cose centre in sales header table

  // komal // id must be manually entered in sales table

  // static final String createSalesTable = "Create table if not EXISTS "
  //     "$salesTableName($salesid INTEGER PRIMARY KEY autoincrement, "
  //     "$companyid INTEGER, $partyId INTEGER,$voucherid INTEGER, "
  //     "$date DATETIME, $duedate DATETIME, "
  //     "$invoicenumber TEXT, $narration TEXT, $totalinvoiceamount DOUBLE, "
  //     "$isactive INTEGER, $status TEXT, "
  //     "$createdOn DATETIME,$createdBy TEXT, "
  //     "$modifiedOn DATETIME, $modifiedBy TEXT, "
  //     "$col1 TEXT, $col2 TEXT, $col3 TEXT, $col4 INTEGER, $col5 INTEGER)";

  static const String createSalesTable = "Create table if not EXISTS "
      "$salesTableName($salesid INTEGER PRIMARY KEY , "
      "$companyid TEXT, $partyId TEXT,$voucherid TEXT, "
      "$date DATETIME, $duedate DATETIME, "
      "$invoicenumber TEXT, "
      "$vchinvprefixname TEXT, $vchinvlastno INTEGER, "   // komal // to get last invoice no 
      "$narration TEXT, $totalinvoiceamount DOUBLE, "
      "$vchParent Text,$calculatedamount DOUBLE, "    // komal // receipt entry added
      "$isactive INTEGER, "
      "$partysyncflag TEXT, "    // komal // partysyncflag as per tallysyncflag in party
      "$mobilesyncflag TEXT, "   // komal // mobsyncflag use to set yes if its synced
      "$col1 INTEGER, $gstvalue DOUBLE , $cessvalue DOUBLE , "     // komal // gst value cess value in table
      "$serviceinvoice INTEGER ,"                               // komal // service invoice in sales table
      "$orginvno TEXT, $orginvdate TEXT, $dncnreason TEXT, $dncnreasonno TEXT, "    // komal // new fields are added
      "$costcentre TEXT, "    // komal // cose centre in sales header table
      "$col2 TEXT, $col3 TEXT, $col4 INTEGER, $col5 INTEGER)";

// For Sales Item Table
  static const String salesitemidpk = "ID";
  static const String salesidfk = "Sales_ID";
  static const String itemidfk = "Item_ID";
  static const String quantity = "Quantity";
  static const String discount = "DISCOUNT";
  static const String rate = "Rate";
  static const String rateinclusivetax = "Rate_Inclusive_Tax";
  static const String itemdescsales = "SALES_ITEM_DESC";    // komal // item desc in sales stock item table
  static const String value = "VALUE";    // komal // value in sales stock item table
  static const String godown = "GODOWN";    // komal // godown in sales stock item table
  static const String batch = "BATCH";    // komal // batch in sales stock item
  static const String ledgercode = "POSTING_LEDGER_CODE";   // komal // posting ledger code in sales stock item table
  static const String increaseQty = "IncreaseQty";    // komal // receipt entry added
  static const String salesQty = 'SalesQty';    // komal // receipt entry added
  static const String alternateQty = 'Alternate_Qty';   // komal // alternate unit in transaction item table
  static const String perunit = 'Per';    // komal // alternate unit per in transaction item table

  // komal // id must be manually entered in sales stock item table

  // static final String createSalesItemTable = "Create table if not EXISTS "
  //     "$salesItemTableName($salesitemidpk INTEGER PRIMARY KEY autoincrement, "
  //     "$salesidfk INTEGER, $itemidfk INTEGER,$quantity DOUBLE, "
  //     "$discount DOUBLE, $rate DOUBLE, $rateinclusivetax INTEGER, "
  //     "$isactive INTEGER, $status TEXT, "
  //     "$createdOn DATETIME,$createdBy TEXT, "
  //     "$modifiedOn DATETIME, $modifiedBy TEXT, "
  //     "$col1 TEXT, $col2 TEXT, $col3 TEXT, $col4 INTEGER, $col5 INTEGER)";

  static const String createSalesItemTable = "Create table if not EXISTS "
      "$salesItemTableName($salesitemidpk INTEGER PRIMARY KEY , "
      "$companyid TEXT, "
      "$salesidfk INTEGER, $itemidfk TEXT,$quantity DOUBLE, "
      "$alternateQty DOUBLE, $perunit TEXT, "    // komal // alternate unit fields added
      "$discount DOUBLE, $rate DOUBLE, $rateinclusivetax INTEGER, "
      "$stkitemsyncflag TEXT, "   // komal // itemsyncflag as per tallysyncflag in item table
      "$isactive INTEGER, "
      "$col1 INTEGER, $itemdescsales TEXT, $value DOUBLE, $taxRate INTEGER, $cess INTEGER,"   // komal // item master column should be in entry table
      "$godown TEXT, $batch TEXT, $ledgercode TEXT,$partysyncflag TEXT, "    // komal // godown and batch in sale item table
      "$col2 TEXT, $col3 TEXT, $col4 INTEGER, $col5 INTEGER)";

  // For Sales Ledger Table
  static const String salesledgeridpk = "ID";
  //static final String salesidfk = "Sales_ID";
  static const String ledgeridfk = "Ledger_ID";
  static const String ledgeramount = "Ledger_Amount";
  static const String totalledgeramount = "Total_Ledger_Amount";

  // komal // id must be manually entered in sales ledger table

  // static final String createSalesLedgerTable = "Create table if not EXISTS "
  //     "$salesLedgerTableName($salesledgeridpk INTEGER PRIMARY KEY autoincrement, "
  //     "$salesidfk INTEGER, $ledgeridfk INTEGER,$ledgeramount DOUBLE,$totalledgeramount DOUBLE,  "
  //     "$isactive INTEGER, $status TEXT, "
  //     "$createdOn DATETIME, $createdBy TEXT, "
  //     "$modifiedOn DATETIME, $modifiedBy TEXT, "
  //     "$col1 TEXT, $col2 TEXT, $col3 TEXT, $col4 INTEGER, $col5 INTEGER)";

  static const String createSalesLedgerTable = "Create table if not EXISTS "
      "$salesLedgerTableName($salesledgeridpk INTEGER PRIMARY KEY , "
      "$companyid TEXT, "   // komal // set company id
      "$salesidfk INTEGER, $ledgeridfk TEXT,$ledgeramount DOUBLE,$totalledgeramount DOUBLE,$partysyncflag TEXT, "
      "$isactive INTEGER,"
      "$col1 INTEGER, $col2 TEXT, $col3 TEXT, $col4 INTEGER, $col5 INTEGER)";

  // For Sales Billed To Table
  static const String salesbilledidpk = "ID";
  //static final String salesidfk = "Sales_ID";
  static const String salesbilledpartyname = "Party_Name";
  static const String salesbilledaddress1 = "Address1";
  static const String salesbilledaddress2 = "Address2";
  static const String salesbilledaddress3 = "Address3";
  static const String salesbilledgstin = "GSTIN";
  static const String salesbilledstate = "State";
  static const String salesbilledewbno = "EWB_Number";
  static const String salesbilledewbdate = "EWB_Date";
  static const String vehicleno = "VEHICLE_NO";   // komal // vehicle no in sales billed to table
  static const String despatchthrough = "DESPATCHED_THROUGH";   // komal // despatch through in sales billed to table
  static const String otherref = "OTHER_REF";   // komal // other ref in sales billed to table

  // komal // id must be manually entered in sales billed to table

  // static final String createsalesBilledToTable = "Create table if not EXISTS "
  //     "$salesBilledToTableName($salesbilledidpk INTEGER PRIMARY KEY autoincrement, "
  //     "$salesidfk INTEGER, $salesbilledpartyname TEXT, "
  //     "$salesbilledaddress1 TEXT, $salesbilledaddress2 TEXT, "
  //     "$salesbilledaddress3 TEXT, $salesbilledgstin TEXT, "
  //     "$salesbilledstate TEXT, $salesbilledewbno INTEGER, "
  //     "$salesbilledewbdate DATETIME, "
  //     "$isactive INTEGER, $status TEXT, "
  //     "$createdOn DATETIME, $createdBy TEXT, "
  //     "$modifiedOn DATETIME, $modifiedBy TEXT, "
  //     "$col1 TEXT, $col2 TEXT, $col3 TEXT, $col4 INTEGER, $col5 INTEGER)";

  static const String createsalesBilledToTable = "Create table if not EXISTS "
      "$salesBilledToTableName($salesbilledidpk INTEGER PRIMARY KEY , "
      "$companyid TEXT, "   // komal // company id added
      "$salesidfk INTEGER, $salesbilledpartyname TEXT, "
      "$salesbilledaddress1 TEXT, $salesbilledaddress2 TEXT, "
      "$salesbilledaddress3 TEXT, $salesbilledgstin TEXT, "
      "$salesbilledstate TEXT, $salesbilledewbno INTEGER, "
      "$salesbilledewbdate DATETIME, "
      "$isactive INTEGER, "
      "$col1 INTEGER, $vehicleno TEXT, $date DATETIME, $despatchthrough TEXT, $otherref TEXT,"   // komal // vehicle no date despatched through and other ref column in sales billed to table
      "$col2 TEXT, $col3 TEXT, $col4 INTEGER, $col5 INTEGER)";

// For Sales Shipped To Table
  static const String salesshippedidpk = "ID";
  //static final String salesidfk = "Sales_ID";
  static const String salesshippedconsigneename = "Consignee_Name";
  static const String salesshippedaddress1 = "Address1";
  static const String salesshippedaddress2 = "Address2";
  static const String salesshippedaddress3 = "Address3";
  static const String salesshippedgstin = "GSTIN";
  static const String salesshippedstate = "State";

  // komal // id must be manually entered in sales shipped to table

  // static final String createsalesShippedToTable = "Create table if not EXISTS "
  //     "$salesShippedToTableName($salesshippedidpk INTEGER PRIMARY KEY autoincrement, "
  //     "$salesidfk INTEGER, $salesshippedconsigneename TEXT, "
  //     "$salesshippedaddress1 TEXT, $salesshippedaddress2 TEXT, "
  //     "$salesshippedaddress3 TEXT, $salesshippedgstin TEXT, "
  //     "$salesshippedstate TEXT, "
  //     "$isactive INTEGER, $status TEXT, "
  //     "$createdOn DATETIME, $createdBy TEXT, "
  //     "$modifiedOn DATETIME, $modifiedBy TEXT, "
  //     "$col1 TEXT, $col2 TEXT, $col3 TEXT, $col4 INTEGER, $col5 INTEGER)";

  static const String createsalesShippedToTable = "Create table if not EXISTS "
      "$salesShippedToTableName($salesshippedidpk INTEGER PRIMARY KEY , "
      "$companyid TEXT, "   // komal // company id added
      "$salesidfk INTEGER, $salesshippedconsigneename TEXT, "
      "$salesshippedaddress1 TEXT, $salesshippedaddress2 TEXT, "
      "$salesshippedaddress3 TEXT, $salesshippedgstin TEXT, "
      "$salesshippedstate TEXT, "
      "$isactive INTEGER, "
      "$col1 INTEGER, $col2 TEXT, $col3 TEXT, $col4 INTEGER, $col5 INTEGER)";

  // komal // sales gst tax ledger table

  static const String salesTaxLedgerid = 'ID';
  static const String salesTaxLedgerAmount = 'TAX_LEDGER_AMOUNT';
  static const String salesTaxLedgerPercentage = 'TAX_PERCENTAGE';

  static const String createSalesTAXLedgerTable = "Create table if not EXISTS "
      "$salesTaxLedgerTableName($salesTaxLedgerid INTEGER PRIMARY KEY , "
      "$companyid TEXT, "   // komal // company id added
      "$salesidfk INTEGER, $ledgerName TEXT,$salesTaxLedgerAmount DOUBLE,$salesTaxLedgerPercentage INTEGER, "
      "$col1 INTEGER, $col2 TEXT, $col3 TEXT, $col4 INTEGER, $col5 INTEGER)";
  

  // For Sales Payment Table
  static const String salespaymentidpk = "ID";
  //static final String salesidfk = "Sales_ID";
  static const String transactiontype = "Transaction_Type";
  static const String referencenumber = "Reference_Number";
  static const String paymentamount = "Amount";
  // komal // receipt entry add
  static const String instrumentDt = 'Instrument_Date';
  static const String receiptId = 'Receipt_ID';
  static const String receiptNo = 'Receipt_No';
  static const String partyamount = 'Party_Amount';   // komal // party amount added in receipt entry 
  static const String bankledgersyncflag = 'Bank_Ledger_Sync_Flag';   // komal // bank ledgerid tallysyncflag set in receipt

  // komal // payment table changed as receipt entry added
  // static final String createSalesPaymentTable = "Create table if not EXISTS "
  //     "$salesPaymentTableName($salespaymentidpk INTEGER PRIMARY KEY autoincrement, "
  //     "$salesidfk INTEGER, $transactiontype TEXT, "
  //     "$referencenumber TEXT, $paymentamount DOUBLE, "
  //     "$isactive INTEGER, $status TEXT, "
  //     "$createdOn DATETIME, $createdBy TEXT, "
  //     "$modifiedOn DATETIME, $modifiedBy TEXT, "
  //     "$col1 TEXT, $col2 TEXT, $col3 TEXT, $col4 INTEGER, $col5 INTEGER)";

  // komal // sales payment table new for receipt and payment
  // static final String createSalesPaymentTable = "Create table if not EXISTS "
  //     "$salesPaymentTableName($salespaymentidpk INTEGER PRIMARY KEY autoincrement, "
  //     "$companyid TEXT,"
  //     "$salesidfk INTEGER, "
  //     "$receiptId INTEGER, $partyId TEXT, $ledgerId TEXT, $voucherid TEXT, $receiptNo TEXT,"
  //     "$transactiontype TEXT, $referencenumber TEXT, $paymentamount DOUBLE, "
  //     "$instrumentDt DATE, $bankName TEXT, $vchParent TEXT,"
  //     "$isactive INTEGER, $status TEXT, "
  //     "$createdOn DATETIME, $createdBy TEXT, "
  //     "$modifiedOn DATETIME, $modifiedBy TEXT, "
  //     "$col1 TEXT, $col2 TEXT, $col3 TEXT, $col4 INTEGER, $col5 INTEGER ,"
  //     "FOREIGN KEY($companyid) REFERENCES $companytablename($id))";

  static const String createSalesPaymentTable = "Create table if not EXISTS "
      "$salesPaymentTableName($salespaymentidpk INTEGER PRIMARY KEY , "
      "$companyid TEXT, $partyId TEXT, $ledgerId TEXT, $voucherid TEXT, $receiptNo TEXT,"
      "$vchinvprefixname TEXT, $vchinvlastno INTEGER, "   // komal // to get last invoice no 
      "$receiptDate TEXT,"
      "$transactiontype TEXT, $referencenumber TEXT, $paymentamount DOUBLE, "
      "$partyamount DOUBLE, "
      "$instrumentDt DATE, $bankName TEXT,$vchParent TEXT,"
      "$modeOfTransfer TEXT, $narration TEXT, $eSignPath TEXT, $eSignPathChkFlag TEXT,"
      "$isactive INTEGER, $status TEXT, "
      "$partysyncflag TEXT, "   // komal // partysyncflag set as per tallysyncflag in party table
      "$bankledgersyncflag TEXT, "    // komal // partysyncflag set as per tallysyncflag of ledgerid in party table
      "$mobilesyncflag TEXT, "   // komal // mobsyncflag is use to set yes if its synced
      "$createdOn DATETIME, $createdBy TEXT, "
      "$modifiedOn DATETIME, $modifiedBy TEXT, "
      "$col1 INTEGER, $col2 TEXT, $col3 TEXT, $col4 INTEGER, $col5 INTEGER ,"
      "FOREIGN KEY($companyid) REFERENCES $companytablename($id))";

  //Voucher Table
  // komal // voucher type name should be in caps to map JSON in API
  // static final String vchTypeCode = 'VchTypeCode';
  // static final String vchTypeName = 'VchTypeName';
  // static final String vchParent = 'Parent';
  // static final String vchNumPfx = 'Voucher_Num_Pfx';
  // static final String vchStartPosition = 'Start_Position';
  // static final String addBankDetails = 'Add_Bank_Details';
  // static final String bankName = 'Bank_Name';
  // static final String accountNo = 'Account_Number';
  // static final String ifsc = 'IFSC';
  // static final String branch = 'Branch';

  static const String vchTypeCode = 'VCHTYPE_CODE';
  static const String vchTypeName = 'VCHTYPE_NAME';
  static const String vchParent = 'PARENT';
  static const String vchNumPfx = 'VCH_PREFIX';
  static const String vchStartPosition = 'VCH_START_POSITION';
  static const String addBankDetails = 'Add_Bank_Details';
  static const String bankName = 'Bank_Name';
  static const String accountNo = 'Account_Number';
  static const String ifsc = 'IFSC';
  static const String branch = 'Branch';
  static const String defaultVchSet = 'Default_Vch';    // komal // 26-3-2022 // default vch set in transaction

  // komal // id must be manually entered in voucher table

  // static final String createVoucherTable = "Create table if not EXISTS "
  //     "$voucherTableName($id INTEGER PRIMARY KEY autoincrement, "
  //     "$vchTypeCode TEXT, $companyid INTEGER, $vchTypeName TEXT, "
  //     "$vchParent TEXT, $vchNumPfx TEXT, $vchStartPosition INTEGER, "
  //     "$ledgerId INTEGER, $addBankDetails INTEGER, "
  //     "$bankName TEXT, $accountNo INTEGER, $ifsc TEXT, $branch TEXT, "
  //     "$isUsed INTEGER, "
  //     "$createdOn DATETIME, $createdBy TEXT, $modifiedOn DATETIME, "
  //     "$modifiedBy TEXT, $col1 TEXT, $col2 TEXT, $col3 TEXT, "
  //     "$col4 INTEGER, $col5 INTEGER, $status TEXT, "
  //     "FOREIGN KEY($companyid) REFERENCES $companytablename($id))";

  static const String createVoucherTable = "Create table if not EXISTS "
      "$voucherTableName($id TEXT Not Null , "
      "$vchTypeCode TEXT, $companyid TEXT Not Null, $vchTypeName TEXT, "
      "$vchParent TEXT, $vchNumPfx TEXT, $vchStartPosition INTEGER, "
      "$ledgerId TEXT, $addBankDetails INTEGER, "
      "$bankName TEXT, $accountNo INTEGER, $ifsc TEXT, $branch TEXT, "
      "$isUsed INTEGER, "
      "$partysyncflag TEXT, "   // komal // partysyncflag to set as per tallysyncflag in ledger party table
      "$createdOn DATETIME, $createdBy TEXT, $modifiedOn DATETIME, "
      "$modifiedBy TEXT, $col1 INTEGER,"
      "$serviceinvoice INTEGER, "   // komal // service invoice in voucher type table
      "$col2 TEXT Not Null, $col3 TEXT, "
      "$col4 INTEGER, $col5 INTEGER, $status TEXT, "
      "$defaultVchSet TEXT, "   // komal // 26-3-2022 // default vch to set in transaction
      "FOREIGN KEY($companyid) REFERENCES $companytablename($id),"
      "PRIMARY KEY($id,$companyid,$col2))";    // komal // primary key on id , companyid and partner code

  //todo Receipt Table
  static const String receiptDate = 'Receipt_Date';
  //todo sales invoice no, totalinvoiceamount also added from sa
  static const String billRef = 'Bill_Ref';
  static const String receiptamount = 'ReceiptAmount';
  static const String calculatedamount = 'CalculatedAmount';
  static const String modeOfTransfer = 'Mode_Of_Transfer';
  static const String eSignPath = 'ESignPath';
  static const String eSignPathChkFlag = 'ESignPathCheckFlag';

  static const String salesAmnt = 'Sales_Amount';
  static const String collectionAmnt = 'Collection_Amount';
  static const String closingBal = 'Closing_Bal';
  static const String openingBal = 'Opening_Bal';
  static const String salesdate = 'SalesDate';
  static const String orderByDate = 'OrderByDate';

  // komal // id is string in table // reciept table changes 

  // static final String createReceiptTable = "Create table if not EXISTS "
  //     "$receiptTableName($id INTEGER PRIMARY KEY autoincrement, "
  //     "$salesidfk INTEGER, $companyid INTEGER, $voucherid INTEGER, "
  //     "$receiptNo TEXT, $partyId INTEGER, $ledgerId TEXT, "
  //     "$receiptDate DATE, $billRef TEXT, $receiptamount DOUBLE, "
  //     "$calculatedamount DOUBLE, $totalinvoiceamount DOUBLE, "
  //     "$vchParent Text, $modeOfTransfer TEXT, $narration TEXT, "
  //     "$eSignPath TEXT, $eSignPathChkFlag INTEGER, "
  //     "$createdOn DATETIME, $createdBy TEXT, $modifiedOn DATETIME, "
  //     "$modifiedBy TEXT, $col1 TEXT, $col2 TEXT, $col3 TEXT, "
  //     "$col4 INTEGER, $col5 INTEGER, $status TEXT, $isActive INTEGER, "
  //     "FOREIGN KEY($companyid) REFERENCES $companytablename($id))";

  static const String createReceiptTable = "Create table if not EXISTS "
      "$receiptTableName($id INTEGER PRIMARY KEY , "
      "$receiptId INTEGER, $companyid TEXT, "
      "$receiptNo TEXT, $partyId TEXT, "
      "$receiptDate DATE, $billRef TEXT, $receiptamount DOUBLE, "
      "$calculatedamount DOUBLE, $totalinvoiceamount DOUBLE, "
      "$createdOn DATETIME, $createdBy TEXT, $modifiedOn DATETIME, "
      "$modifiedBy TEXT, $col1 INTEGER, $col2 TEXT, $col3 TEXT, "
      "$col4 INTEGER, $col5 INTEGER, $status TEXT, $isActive INTEGER, "
      "FOREIGN KEY($companyid) REFERENCES $companytablename($id))";

  // komal // outstanding receivable table
  static const String billdate = 'BILL_DATE';


    //Leena--14-12-2020 -- add Journal entry screen
    // static final String createJournalTable = "Create table if not EXISTS "
    //   "$journalTableName($id INTEGER PRIMARY KEY autoincrement, "
    //   "$jvId INTEGER, $companyid TEXT, $voucherid TEXT, "
    //   "$jvNo TEXT, $jvDate DATE ,$vchParent TEXT , $jvamount DOUBLE , $narration TEXT "      
    //   "$createdOn DATETIME, $createdBy TEXT, $modifiedOn DATETIME, "
    //   "$modifiedBy TEXT, $col1 TEXT, $col2 TEXT, $col3 TEXT, "
    //   "$col4 INTEGER, $col5 INTEGER, $status TEXT, $isActive INTEGER, "
    //   "FOREIGN KEY($companyid) REFERENCES $companytablename($id))";

    // komal // jvid is removed and mobile sync flag column is added
    static const String createJournalTable = "Create table if not EXISTS "
      "$journalTableName($id INTEGER PRIMARY KEY , "
      "$companyid TEXT, $voucherid TEXT, "
      "$jvNo TEXT, $jvDate DATE ,$vchParent TEXT , $jvamount DOUBLE , $narration TEXT, "
      "$vchinvprefixname TEXT, $vchinvlastno INTEGER, "   // komal // to get last invoice no 
      "$createdOn DATETIME, $createdBy TEXT, $modifiedOn DATETIME, "
      "$modifiedBy TEXT, "
      "$mobilesyncflag TEXT, $col1 INTEGER, $col2 TEXT, $col3 TEXT, "
      "$col4 INTEGER, $col5 INTEGER, $status TEXT, $isActive INTEGER, "
      "FOREIGN KEY($companyid) REFERENCES $companytablename($id))";

      static const String jvId = 'JV_ID';
      static const String jvNo = 'JV_NO';
      static const String jvDate = 'JV_DATE';
      static const String jvdramount = 'JV_DR';
      static const String jvcramount = 'JV_CR';
      static const String jvamount = 'JV_AMT';      
      static const String journalledgeridpk = 'ID';
      static const String jvLedType = 'TYPE';
      static const String jvLedgerPartyType = 'JV_LED_PARTY_TYPE';    // komal // jv ledger and party type
      
    static const String createJournalledgerTable = "Create Table if not EXISTS "
      "$journalledgerTableName($journalledgeridpk INTEGER PRIMARY KEY, "
      "$companyid TEXT, "   // komal // company id added bcze to update party id as per company selected in import
      "$jvId INTEGER , $jvNo TEXT, $ledgeridfk TEXT, $jvdramount DOUBLE , $jvcramount DOUBLE , $jvLedType TEXT , "
      "$partysyncflag TEXT, $jvLedgerPartyType TEXT, "   // komal // to set yes or no as per tally sync flag in party // and ledger party type to set it is ledger or party
      "$isactive INTEGER,$col2 TEXT)";
///-----------------------------------------------------------------//



  static const String createOutstandingReceivableTable = "Create Table if not EXISTS "
      "$outstandingReceivableTableName($id INTEGER, $companyid TEXT,"
      "$partyId TEXT, $invoicenumber TEXT, $billdate TEXT, $duedate TEXT,"
      "$totalinvoiceamount DOUBLE,$col2 TEXT, $createdOn DATETIME, "
      "FOREIGN KEY($companyid) REFERENCES $companytablename($id))";

  // komal // outstanding payable table
  static const String createOutstandingPayableTable = "Create Table if not EXISTS "
      "$outstandingPayableTableName($id INTEGER, $companyid TEXT,"
      "$partyId TEXT, $invoicenumber TEXT, $billdate TEXT, $duedate TEXT,"
      "$totalinvoiceamount DOUBLE,$col2 TEXT, $createdOn DATETIME, "
      "FOREIGN KEY($companyid) REFERENCES $companytablename($id))";
  
  // komal // receipt ledger table
  static const String receiptledgeridpk = 'ID';
  static const String createreceiptledgerTable = "Create Table if not EXISTS "
      "$receiptledgerTableName($receiptledgeridpk INTEGER PRIMARY KEY, "
      "$companyid TEXT, "   // komal // set company id to update ledger id 
      "$receiptId INTEGER, $ledgeridfk  TEXT, $ledgeramount DOUBLE, "
      "$partysyncflag TEXT, "   // komal // partysyncflag of ledgerid as per tallysyncflag
      "$isactive INTEGER, $col2 TEXT)";

  // komal // 18-02-2022 // bank details of company added
  static const String cmpBankLedgerId = 'LEDGER_ID';
  static const String cmpBankLedgerName = 'LEDGER_NAME';
  static const String cmpBankName = 'BANK_NAME';
  static const String cmpBranch = 'BRANCH';
  static const String cmpIFSC = 'IFSC_CODE';
  static const String cmpAccountNo = 'ACCOUNT_NUMBER';
  static const String cmpUpiCode = 'UPI_CODE';

  static const String createCompanyBankTable = "Create Table if not EXISTS "
      "$companyBankTableName($companyid TEXT,$col2 TEXT,$cmpBankLedgerId TEXT,"
      "$cmpBankLedgerName TEXT,$cmpBankName TEXT,$cmpBranch TEXT,$cmpIFSC TEXT,"
      "$cmpAccountNo TEXT,$cmpUpiCode TEXT,  "
      "PRIMARY KEY($companyid,$col2,$cmpBankLedgerId))";
}   