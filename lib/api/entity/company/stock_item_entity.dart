class StockItemEntity {
  String? companyId;
  // String? partnerCode;
  String? itemId;
  String? itemName;
  String? priceListRate;
  String? priceListDiscount;
  String? imagePath;
  // String? itemDescription;
  // String? groupName;
  // String? categoryName;
  String? unitName;
  // String? gstApplicable;
  String? taxRate;
  String? cess;
  String? hsnCode;
  String? productCategoryCode;
  String? productCategoryName;
  // String? mrpValue;
  String? brandCode;
  String? brandName;
  String? additionalUnitApplicable;
  String? additionalUnit;
  String? conversion;
  String? denominator;
  String? cashDiscount;
  String? schemeDiscount;

  String? stockgroupname;//snehal 3-12-2024 add
   String? prosubcatcode;//snehal 3-12-2024 add
  String? prosubcatname;//snehal 3-12-2024 add
  String? divisioncode;//snehal 3-12-2024 add
  String? divisionname;//snehal 3-12-2024 add
  String? hsndesc;//snehal 3-12-2024 add
  String? gsteffdate; //snehal 3-12-2024 add
  String? activestatus; //snehal 3-12-2024 add
  String? prdcreatedate; //snehal 3-12-2024 add
  String? wef; //snehal 3-12-2024 add
  String? dlp; //snehal 3-12-2024 add
  String? mt; //snehal 3-12-2024 add
  String? bag; //snehal 3-12-2024 add
  String? kg; //snehal 3-12-2024 add
  String? stockgroupid;//snehal 3-12-2024 add
  // Manisha 13-12-2024 add column
  String? tallystatus;
    String? classification; // Sakshi 10/02/2025
  String? description; // Sakshi 10/02/2025
  String? category; // // Sakshi 12/02/2025
  String? subcategory; // Sakshi 12/02/2025
  String? groupname; // Sakshi 12/02/2025
  String? existingid; //Shweta 09-03-26
  String? groupid;
  String? productSubCatCode;

  StockItemEntity();

  StockItemEntity.fromMap(Map<String, dynamic> json) {
    companyId = json['company_id'];
    // partnerCode = json['partner_code'];
    itemId = json['item_id'];
    itemName = json['item_name'];
    priceListRate = json['price_list_rate'] == '' || json['price_list_rate'] == null?'':num.parse(json['price_list_rate']).toStringAsFixed(2);
    priceListDiscount = json['price_list_discount'] == '' || json['price_list_discount'] == null?'':num.parse(json['price_list_discount']).toStringAsFixed(2);
    imagePath = json['image_path'];
    // itemDescription = json['item_description'];
    // groupName = json['group_name'];
    // categoryName = json['category_name'];
    unitName = json['unit_name'];
    // gstApplicable = json['gst_applicable'];
    taxRate = json['tax_rate'];
    cess = json['cess_rate'];
    hsnCode = json['hsn_code'];
    productCategoryCode = json['product_category_main_code'];
    productCategoryName = json['product_category_name'];
    brandCode = json['brand_code'];
    brandName = json['brand_name'];
    additionalUnitApplicable = json['additional_units_applicable'];
    additionalUnit = json['additional_unit'];
    conversion = json['conversion'];
    denominator = json['denominator'];
    cashDiscount = json['cash_discount'];
    schemeDiscount = json['scheme_discount'];
     stockgroupname=json['stock_group_name'];//snehal  3-12-2024 add
     tallystatus = json['tally_status']; // Manisha 13-12-2024 add column
     classification = json['classification']; // Sakshi 10/02/2025
    description = json['description']; // Sakshi 10/02/2025
    category = json['category_name']; // Sakshi 12/02/2025
    subcategory = json['subcategory_name']; // Sakshi 12/02/2025
    groupname = json['group_name']; // Sakshi 12/02/2025
    existingid = json['existing_id']; //Shweta 09-03-26
    groupid = json['stk_group_id'];
    productSubCatCode = json['product_sub_category_code'];
    activestatus = json['active_status'];  // Sakshi 13/03/2026
  }

  StockItemEntity.brandMap(Map<String,dynamic> map){
    brandCode = map['brand_code'];
    brandName = map['brand_name'];
  }

  // Map<String, dynamic> toMap() {
  //   var map = Map<String, dynamic>();
  //   if (companyId != null) {
  //     map['company_id'] = companyId;
  //   }
  //   if (partnerCode != null) {
  //     map['Partner_Code'] = partnerCode;
  //   }
  //   if (itemId != null) {
  //     map['Mobile_No'] = itemId;
  //   }
  //   if (itemName != null) {
  //     map['itemName'] = itemName;
  //   }
  //   if (priceListRate != null) {
  //     map['Party_Id'] = priceListRate;
  //   }
  //   if (priceListDiscount != null) {
  //     map['discount'] = priceListDiscount;
  //   }
  //   if (imagePath != null) {
  //     map['Due_Date'] = imagePath;
  //   }
  //   if (itemDescription != null) {
  //     map['item_description'] = itemDescription;
  //   }
  //   if (groupName != null) {
  //     map['item_description'] = groupName;
  //   }
  //   if (categoryName != null) {
  //     map['item_description'] = categoryName;
  //   }
  //   if (unitName != null) {
  //     map['item_description'] = unitName;
  //   }
  //   if (gstApplicable != null) {
  //     map['item_description'] = gstApplicable;
  //   }
  //   if (taxRate != null) {
  //     map['item_description'] = taxRate;
  //   }
  //   if (cess != null) {
  //     map['item_description'] = cess;
  //   }
  //   if (hsnCode != null) {
  //     map['item_description'] = hsnCode;
  //   }
  //   if (mrpValue != null) {
  //     map['item_description'] = mrpValue;
  //   }
  //   return map;
  // }
   Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};                      
{
  if (companyId != null) {
      map['company_id'] = companyId;
    }
   
    
    if (itemId != null) {
      map['product_code'] = itemId;
    }
    if ( itemName!= null) {
      map['product_desc'] = itemName;
    }
    if (productCategoryCode != null) {
      map['product_category_main_code'] = productCategoryCode; 
    }
    if (productCategoryName != null) {
      map['product_category_name'] = productCategoryName;
    }
    if (prosubcatcode != null) {
      map['product_sub_category_code'] = prosubcatcode;
    }
    if (prosubcatname != null) {
      map['product_sub_category_name'] = prosubcatname;
    }
    if (brandCode != null) {
      map['brand_code'] = brandCode;
    }
    if (brandName != null) {
      map['brand_name'] = brandName;
    }
    if (divisioncode != null) {
      map['division_code'] = divisioncode;
    }
    if ( divisionname!= null) {
      map['division_name'] = divisionname;
    }
    if (unitName != null) {
      map['uom'] = unitName;
    }
    if (
      hsnCode != null) {
      map['hsn_cd'] = 
      hsnCode;
    }
    if (
      hsndesc != null) {
      map['hsn_desc'] = hsndesc;
    }
    if (gsteffdate != null) {
      map['gst_eff_date'] = 
      gsteffdate;
    }
    if (taxRate != null) {
      map['tax_rate'] = 
      taxRate;
    }
    if (cess != null) {
      map['cess_rate'] = cess;
    }
    if (activestatus != null) {
      map['active_status'] = activestatus;
    }
    if (prdcreatedate != null) {
      map['prd_create_dt'] = 
      prdcreatedate;
    }
    if (
      wef != null) {
      map['wef'] = wef;
    }
    if (dlp != null) {
      map['dlp'] = dlp;
    }
    if (mt != null) {
      map['mt'] = mt;
    }
    if (bag != null) {
      map['bag'] = bag;
    }
    if (kg != null) {
      map['kg'] = kg;
    }
    if (additionalUnitApplicable != null) {
      map['additional_units_applicable'] = additionalUnitApplicable;
    }
    if (additionalUnit != null) {
      map['additional_units'] = additionalUnit;
    }
    if (conversion != null) {
      map['conversion'] = conversion;
    }
    if (denominator != null) {
      map['denominator'] = denominator;
    }
      if (stockgroupid != null) {
      map['stk_group_id'] = stockgroupid;
    }
     if (classification != null) {
        map['CLASSIFICATION'] = classification; // Sakshi 10/02/2025
      }
      if (description != null) {
        map['DESCRIPTION'] = description; // Sakshi 10/02/2025
      }
       if (category != null) {
        map['category_name'] = category; // Sakshi 12/02/2025
      }
      if (subcategory != null) {
        map['subcategory_name'] = subcategory; // Sakshi 12/02/2025
      }
       if (groupname != null) {
        map['group_name'] = groupname; // Sakshi 12/02/2025
      }
        if (existingid != null) {
        map['existing_id'] = existingid; //shweta 09-03-26
      }
         if (groupid != null) {
        map['stk_group_id'] = groupid; // Sakshi 12/02/2025
      }
        if (productSubCatCode != null) {
        map['PRODUCT_SUB_CATEGORY_CODE'] = productSubCatCode;
      }



    return map;
  }
}


}
