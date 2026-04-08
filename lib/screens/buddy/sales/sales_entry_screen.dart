import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textFormField.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/buddy/sales/sales_header_entity.dart';
import 'package:sysconn_sfa/api/entity/company/partyentity.dart';
import 'package:sysconn_sfa/api/entity/company/voucherentity.dart';
import 'package:sysconn_sfa/api/entity/sales/sales_ledger_entity.dart';
import 'package:sysconn_sfa/screens/buddy/sales/additional_details.dart';
import 'package:sysconn_sfa/screens/buddy/sales/inventory_details.dart';
import 'package:sysconn_sfa/widgets/customautocompletefield.dart';
import 'package:sysconn_sfa/widgets/custom_appbar.dart';
import 'package:sysconn_sfa/widgets/responsive_button.dart';

class CreateSales extends StatefulWidget {
  final String? vchType;
  final String? hedId;
  final String? partyid;
  final String? partyname;

  const CreateSales(
      {super.key,
      this.vchType,
      this.hedId,
      this.partyid,
      this.partyname});

  @override
  State<CreateSales> createState() => _CreateSalesState();
}

class _CreateSalesState extends State<CreateSales> {
  TextEditingController dateController = TextEditingController(text: DateFormat("yyyy-MM-dd").format(DateTime.now()));
  String partySelectedName = '';
  String partySelectedId = '';
  List<VoucherEntity> vchEntityList = [];
  List<PartyEntity> partyEntityList = [];
  DateTime selectedDate = DateTime.now();
  TextEditingController remarkController = TextEditingController();
  String partyMobileNo = '';
  String vchSelectedName = '';
  String vchSelectedId = '';
  String invoiceNo = '';
  String priceList = '';
  bool isGstAutoCalEnable = true;
  bool isCGSTApplicable = false;
  SalesHeaderEntity? salesHeaderEntity;
  List<SalesLedgerEntity> salesLedgerList = [];
  List<PlutoRow> plutoRows = [];
  num paymentTotal = 0;
  double itemTotalNetAmount = 0.0;
  double ledgerTotalAmount = 0.0;
  double itemGstTotalAmount = 0.0;
  double cessTotalValue = 0.0;
  num totalAmount = 0;
  bool isInvGridRefresh = false;
  String salesUniqueId = '';
  int isDataLoad = 0;
  TextEditingController paymentTermsController = TextEditingController();
  TextEditingController orgInvNoController = TextEditingController();
  TextEditingController orgInvDateController = TextEditingController();
  TextEditingController cashController = TextEditingController();
  TextEditingController bankInstNoController = TextEditingController();
  TextEditingController bankAmtController = TextEditingController();
  TextEditingController cardInstNoController = TextEditingController();
  TextEditingController cardAmtController = TextEditingController();
  TextEditingController giftReferenceController = TextEditingController();
  TextEditingController giftAmtController = TextEditingController();
  TextEditingController ledgerDiscController = TextEditingController();
  TextEditingController ledgerAmtController = TextEditingController();
  String creditNoteReasonSelected = '';
  var isSaleSaved = false;
  num cgstLedgerAmt = 0.0;
  num sgstLedgerAmt = 0.0;
  num igstLedgerAmt = 0.0;
  bool isTallyEntry = false;
  String posPaymentEnable = 'No';
  int? mySalesId;

  @override
  void initState() {
    super.initState();
    callInitFun();
  }

  void callInitFun() async {
    if (widget.partyid != null) {
      await ApiCall.getPartyDetCMPApi(partyType: '', partyId: widget.partyid!).then((partyEntity) async {
        partyEntityList = partyEntity;
        await vchTypeDataAPI().then((value) async {
          if (widget.hedId == null) {
            isDataLoad = 1;
          } else {
            salesUniqueId = widget.hedId!;
            await getSalesDataAPI().then((value) {
              isDataLoad = 1;
            });
          }
          if (mounted) {
            setState(() {});
          }
          // });
        });
      });
    } else if(widget.partyid==''){
      await ApiCall.getPartyDetCMPApi(partyType: 'Customer').then((partyEntity) async {
      partyEntityList = partyEntity;
      await vchTypeDataAPI().then((value) async {
      await getSalesDataAPI().then((value) {
        isDataLoad = 1;
      });
      });
    });
    }
    else{
     salesUniqueId = widget.hedId!;
      isSaleSaved = true;
      await getSalesDataAPI().then((value) {
        isDataLoad = 1;
      });   
    }
  }

  Padding hederTitleCon(Size size, {required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          SizedBox(
            width: size.width * 0.24,
            child: Text(title,style: kTxtStl12B,)
          ),
          Text(': ',style: kTxtStl12B,),
          Flexible(
            child: Column(
              children: [
                Text(value,style: kTxtStl12N,),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: customAppbar(
        context: context,
        title: (widget.hedId != null  && widget.hedId!='')?  'Update ${widget.vchType}' :'Create ${widget.vchType}',
      ),
      body: isDataLoad == 0?
      Center(
        child: isDataLoad == 0?
        const CircularProgressIndicator()
        : const Text('No Data'),
      )
      :Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.add_business_sharp),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('Create ${widget.vchType}',style: kTxtStlB,),
                    ],
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Row(
                          children: [
                            CustomTextFormFieldView(
                              controller: dateController,
                              keyboardType: TextInputType.datetime,
                              title: 'Date',
                              onTap: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                selectDateSingle(dateSelected: selectedDate,firstDate: selectedDate
                                .subtract(const Duration(days: 12)),
                                lastDate: DateTime(selectedDate.year + 1)).then((date) {
                                  selectedDate = date;
                                  dateController.text = DateFormat('yyyy-MM-dd').format(date);
                                });
                              },
                            ),
                            SizedBox(
                              width: size.width * 0.03,
                            ),
                            SizedBox(
                              width: size.width * 0.6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  hederTitleCon(size,title: 'Pricelist',value: priceList),
                                  hederTitleCon(size,title: 'Mobile Number',value: partyMobileNo),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
                          children: [
                            CustomAutoCompleteFieldView(
                              title: 'Voucher Name',
                              enabled: salesHeaderEntity == null?true:false,
                              isCompulsory: true,
                              optionsBuilder: (TextEditingValue value) {
                                return vchEntityList.where((element) => element.vchTypeName!.toLowerCase()
                                .contains(value.text.toLowerCase())).toList();
                              },
                              controllerValue: vchSelectedName,
                              closeControllerFun: () {
                                setState(() {
                                  vchSelectedName = '';
                                  vchSelectedId = '';
                                  invoiceNo = '';
                                });
                              },
                              displayStringForOption: (VoucherEntity vchEntity) {
                                return vchEntity.vchTypeName!;
                              },
                              onSelected: (VoucherEntity vchDataSelected) {
                                setState(() {
                                  vchSelectedName = vchDataSelected.vchTypeName!;
                                  vchSelectedId = vchDataSelected.vchTypeCode!;
                                  invoiceNo = vchDataSelected.nyDate == ''? ''
                                  : DateFormat('yyyy-MM-dd').parse(dateController.text)
                                  .isAfter(DateFormat('yyyy-MM-dd').parse(vchDataSelected.nyDate!))
                                  ? vchDataSelected.nyPfx!: vchDataSelected.cyPfx!;
                                  posPaymentEnable = vchEntityList[0].posPaymentEnable!;
                                });
                              }
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
                          children: [
                            CustomAutoCompleteFieldView(
                              title: 'Party Name',
                              isCompulsory: true,
                              enabled: salesHeaderEntity == null?true:false,
                              optionsBuilder: (TextEditingValue value) {
                                return partyEntityList.where((element) => element.partyName!.toLowerCase()
                                .contains(value.text.toLowerCase())).toList();
                              },
                              controllerValue: partySelectedName,
                              closeControllerFun: () {
                                setState(() {
                                  partySelectedName = '';
                                });
                              },
                              displayStringForOption: (PartyEntity partyEntity) {
                                return partyEntity.partyName!;
                              },
                              onSelected: (PartyEntity partyDataSelected) {
                                setState(() {
                                  partySelectedName = partyDataSelected.partyName!;
                                  partySelectedId = partyDataSelected.partyId!;
                                  partyMobileNo = partyDataSelected.partyMobNo!;
                                  priceList = partyDataSelected.pricelist!;
                                  isCGSTApplicable = Utility.companyMasterEntity.companystate!.toUpperCase() == 
                                  partyDataSelected.state!.toUpperCase();
                                });
                              }
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
                          children: [
                            CustomTextFormFieldView(
                              controller: paymentTermsController,
                              keyboardType: TextInputType.text,
                              title: 'Payment Terms',
                            ),
                            SizedBox(
                              width: size.width * 0.05,
                            ),
                            Row(
                              children: [
                                Text('Enable Auto Gst Calculation :',style: kTxtStl11B,),
                                const SizedBox(
                                  width: 1,
                                ),
                                Checkbox(
                                  value: isGstAutoCalEnable,
                                  onChanged: (gstValue) {
                                    if (mounted && salesUniqueId == '') {
                                      setState(() {
                                        isGstAutoCalEnable = gstValue!;
                                      });
                                    }
                                  }
                                )
                              ]
                            )
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        Row(
                          children: [
                            CustomTextFormFieldView(
                              controller: remarkController,
                              title: 'Remark',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                (salesHeaderEntity == null && !isSaleSaved)?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width * 0.7,
                      // child: ResponsiveButton(
                      //   title: 'Next - - >',
                      //   function: () async {
                      //     Utility.showCircularLoadingWid(context);
                      //     await salesHeaderPostApi();
                      //   }
                      // ),
                    ),
                  ],
                )
                : Container(),
                isSaleSaved?
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.all(8.0),
                      ),
                      onPressed: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context) => Additionaldetails(salesHeaderEntity:salesHeaderEntity)));
                      },
                      child: Row(
                        children: [
                          Icon(Icons.add_business,color: Theme.of(context).colorScheme.secondary,),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text('Additional Details',style: kTxtStl13B,),
                        ],
                      ),
                    )
                  ],
                )
                : Container(),
                isSaleSaved?
                Column(
                  children: [
                    Container(
                      width: size.width,
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(FontAwesomeIcons.boxOpen,),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text('Inventory',style: kTxtStlB,),
                        ],
                      )
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              color: Colors.grey.shade200,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                                    child: Text('Add Items',style: kTxtStl13B),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline,color: Colors.red,),
                                    onPressed: () {
                                      setState(() {
                                        _navigateItemScreen('Add Inventory Details',0);
                                        getSalesDataAPI();
                                      });
                                    },
                                  ),
                                ]
                              ),
                            ),
                            salesHeaderEntity == null?
                            Container()
                            : salesHeaderEntity!.items!.isEmpty?
                            const Padding(
                              padding:EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text('No Item Added.',)
                            )
                            : ListView.builder(
                              itemCount: salesHeaderEntity!.items!.length, // + 1,
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(salesHeaderEntity!.items![index].itemName!,style: kTxtStl13N),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text('Qty : ${salesHeaderEntity!.items![index].qty}' 
                                                      '| Rate : ₹ ${salesHeaderEntity!.items![index].rate} ',
                                                      style: kTxtStl12GreyN,),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text('TAX : ${salesHeaderEntity!.items![index].taxRate == '' ?'0' :
                                                    salesHeaderEntity!.items![index].taxRate}% | HSN/SAC : ${salesHeaderEntity!.items![index].hsnCode}',style: kTxtStl12GreyN,),
                                                  ),
                                                ]
                                              ),
                                            ],
                                          )
                                        ),
                                        SizedBox(
                                          width: size.width * 0.2,
                                          child: Text(indianRupeeFormat(double.parse(salesHeaderEntity!.items![index].value!)),
                                          style: kTxtStl13B,textAlign: TextAlign.right,),
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    // print('$index Item Selected');
                                    _navigateItemScreen('Update Inventory Details',index);
                                  },
                                );
                              }
                            ),
                            const Divider(),
                            Row(
                              children: [
                                const Expanded(
                                  child: Text('Net Amount')),
                                SizedBox(
                                  width: size.width * 0.2,
                                  child: Text(indianRupeeFormat(itemTotalNetAmount),style: kTxtStl13B,textAlign: TextAlign.right,),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
                : Container(),
                isSaleSaved?
                Column(
                  children: [
                    Container(
                      width: size.width,
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.leaderboard,),
                          const SizedBox(
                              width: 10.0,
                          ),
                          Text('Ledger',style: kTxtStlB,),
                        ],
                      )
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              color: Colors.grey.shade200,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                                    child: Text('Add Ledger',style: kTxtStl13B),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline,color: Colors.red,),
                                    onPressed: () {
                                      _navigateLedgerScreen('Add Ledgers', 0);
                                    },
                                  ),
                                ]
                              ),
                            ),
                            salesHeaderEntity == null?
                            Container()
                            : salesHeaderEntity!.ledger!.isEmpty?
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text('No Ledger Added.',)
                            )
                            : ListView.builder(
                              itemCount: salesHeaderEntity!.ledger!.length,
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('${salesHeaderEntity!.ledger![index].ledgerName}')
                                            ],
                                          )
                                        ),
                                        SizedBox(
                                          width: size.width * 0.2,
                                          child: Text(indianRupeeFormat(double.parse(salesHeaderEntity!.ledger![index].amount!)),
                                          style: kTxtStl13B,textAlign: TextAlign.right,),
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    _navigateLedgerScreen('Update Ledgers',index);
                                  },
                                );
                              }
                            ),
                            const Divider(),
                            Row(
                              children: [
                                const Expanded(
                                  child: Text('Net Amount')
                                ),
                                SizedBox(
                                  width: size.width * 0.2,
                                  child: Text(indianRupeeFormat(ledgerTotalAmount),style: kTxtStl13B,textAlign: TextAlign.right,),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ): Container(),
                isSaleSaved?
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Text('Sub Total',style: kTxtStl12N)
                              ),
                              Text(indianRupeeFormat(double.parse(totalAmount.toString())),style: kTxtStl12B),
                            ]
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Tax(GST) Amount",style: kTxtStl12GreyN),
                            Text(indianRupeeFormat(itemGstTotalAmount),style: kTxtStl12GreyN,), //myTotalCESSAmount
                          ]
                        ),
                        Divider(color: Colors.grey.shade200,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total Invoice Amount",style: kTxtStl16B),
                            Text(indianRupeeFormat(totalAmount.ceilToDouble()),
                            style: TextStyle(fontSize: 19,fontWeight: FontWeight.w600,color: kAppColor),), // totalInvoiceAmount.floorToDouble()   // komal // 11-4-2024 // decimal error in calculation of roundoff
                          ]
                        ),
                      ],
                    ),
                  ),
                ): Container(),
              ],
            ),
          ),
          salesHeaderEntity == null?Container()
          : salesHeaderEntity!.items!.isEmpty?
          Container():Container(
            width: size.width * 0.4,
            padding: const EdgeInsets.all(8),
            child: ResponsiveButton(
              title: 'Save',
              function: () async {
                Utility.showCircularLoadingWid(context);
                await salesSavePostApi();
              }
            ),
          ),
        ],
      )
    );
  }

  Future vchTypeDataAPI() async {
    setState(() {
      vchEntityList = [];
    });
    await ApiCall.getVoucherTypeMasterAPI().then((vchTypeEntity) {
      if (vchTypeEntity.isNotEmpty) {
        for (int i = 0; i < vchTypeEntity.length; i++) {
          if (vchTypeEntity[i].parent == widget.vchType) {
            // vchEntityList.add(vchTypeEntity[i]);
            // vchSelectedName = vchEntityList[0].vchTypeName!;
            // vchSelectedId = vchEntityList[0].vchTypeCode!;
            // invoiceNo = DateFormat('yyyy-MM-dd').parse(dateController.text).isAfter(DateFormat('yyyy-MM-dd').parse(vchEntityList[0].nyDate!))? vchEntityList[0].nyPfx!: vchEntityList[0].cyPfx!;
            //pooja // 29-11-2024
             vchEntityList.add(vchTypeEntity[i]);
            vchSelectedName = vchEntityList[0].vchTypeName!;
            vchSelectedId = vchEntityList[0].vchTypeCode!;
            invoiceNo = vchEntityList[0].nyDate == ''?vchEntityList[0].cyPfx!:DateFormat('yyyy-MM-dd').parse(dateController.text).isAfter(DateFormat('yyyy-MM-dd').parse(vchEntityList[0].nyDate!))?
            vchEntityList[0].nyPfx!: vchEntityList[0].cyPfx!;
            posPaymentEnable = vchEntityList[0].posPaymentEnable!;
          }
        }
      }
    });
  }

  Future<void> getSalesDataAPI({bool isInvClicked = false}) async {
    num itemTotalAmount = 0.0;
    if (mounted) {
      setState(() {
        itemTotalNetAmount = 0.0;
        ledgerTotalAmount = 0.0;
        itemGstTotalAmount = 0.0;
        itemTotalAmount = 0.0;
        plutoRows = [];
        isInvGridRefresh = false;
        salesLedgerList = [];
      });
    }
    await ApiCall.getSalesMasterDataAPI(uniqueId: salesUniqueId).then((salesDet) {
      if (salesDet != null) {
        salesHeaderEntity = salesDet;
        isInvGridRefresh = true;
        vchSelectedName = salesDet.voucherTypeName!;
        vchSelectedId = salesDet.voucherType!;
        posPaymentEnable = salesDet.posPayment!;
        partySelectedName = salesDet.partyName!;
        partySelectedId = salesDet.partyId!;
        partyMobileNo = salesDet.partyMobileNo!;
        priceList = salesDet.pricelist!;
        dateController.text = salesDet.date! != ''
            ? DateFormat('yyyy-MM-dd').format(DateTime.parse(salesDet.date!))
            : '';
        paymentTermsController.text = salesDet.paymentTerms!;
        orgInvNoController.text = salesDet.originalInvoiceNo!;
        orgInvDateController.text = salesDet.originalInvoiceDate!;
        creditNoteReasonSelected = salesDet.cnReason!;
        remarkController.text = salesDet.narration!;
        cashController.text = salesDet.cashAmount!;
        bankInstNoController.text = salesDet.bankInstNo!;
        bankAmtController.text = salesDet.bankAmount!;
        cardInstNoController.text = salesDet.cardInstNo!;
        cardAmtController.text = salesDet.cardAmount!;
        giftReferenceController.text = salesDet.giftReferenceNo!;
        giftAmtController.text = salesDet.giftAmount!;
        isGstAutoCalEnable = salesDet.isGstAutoCal == 'Yes' ? true : false;
        isTallyEntry = salesDet.isTalyEntry == 'Yes' ? true : false;
        isCGSTApplicable = Utility.companyMasterEntity.companystate!.toUpperCase() == salesDet.state!.toUpperCase();
        for (int i = 0; i < salesDet.items!.length; i++) {
          itemTotalNetAmount += num.parse(salesDet.items![i].netValue.toString());
          itemTotalAmount += num.parse(salesDet.items![i].value.toString());
          if (isGstAutoCalEnable) {
            itemGstTotalAmount +=
                num.parse(salesDet.items![i].gstvalue.toString());
            cgstLedgerAmt = isCGSTApplicable ? itemGstTotalAmount / 2 : 0;
            sgstLedgerAmt = isCGSTApplicable ? itemGstTotalAmount / 2 : 0;
            igstLedgerAmt = isCGSTApplicable ? 0 : itemGstTotalAmount;
          }
          // cessTotalValue += num.parse(salesDet.items![i].cessvalue.toString());
          plutoRows.addAll([
            PlutoRow(
              cells: {
                'config': PlutoCell(
                  value: Container(),
                ),
                'inv_id': PlutoCell(value: salesDet.items![i].invId),
                'item_code': PlutoCell(value: salesDet.items![i].itemId),
                'item_name': PlutoCell(value: salesDet.items![i].itemName),
                'unit': PlutoCell(value: salesDet.items![i].unit),
                'tax': PlutoCell(value: salesDet.items![i].gstrate),
                'qty': PlutoCell(value: salesDet.items![i].qty),
                'rate': PlutoCell(value: salesDet.items![i].rate),
                'disc': PlutoCell(value: salesDet.items![i].discount),
                'value': PlutoCell(value: salesDet.items![i].netValue),
              },
            )
          ]);
        }
        for (int i = 0; i < salesDet.ledger!.length; i++) {
          salesLedgerList.add(salesDet.ledger![i]);
          ledgerTotalAmount += num.parse(salesLedgerList[i].amount.toString());
        }
      }
      calGrandTotal();
      totalAmount = itemTotalAmount +
          ledgerTotalAmount; // num.parse(salesDet.totalAmount!);
    });
    if (mounted) {
      setState(() {});
    }
  }

  void calGrandTotal() {
    setState(() {
      num cash = cashController.text == '' ? 0 : int.parse(cashController.text);
      num bank =
          bankAmtController.text == '' ? 0 : int.parse(bankAmtController.text);
      num card =
          cardAmtController.text == '' ? 0 : int.parse(cardAmtController.text);
      num giftvch =
          giftAmtController.text == '' ? 0 : int.parse(giftAmtController.text);
      paymentTotal = (cash + bank + card + giftvch);
    });
  }

  Future checkHedValidBool() async {
    if (vchSelectedId == '') {
      // scaffoldMessageBar( Get.context!,'Please enter voucher name');
      return false;
    } else if (partySelectedId == '') {
      // scaffoldMessageBar( 'Please enter party name');
      return false;
    } else {
      return true;
    }
  }

  Future<bool> salesHeaderPostApi() async {
    bool isValid = false;
    await checkHedValidBool().then((value) {
      isValid = value;
    });
    if (isValid) {
      SalesHeaderEntity salesHedEntity = SalesHeaderEntity();
      salesHedEntity.companyId = Utility.companyId;
      salesHedEntity.mobileno = Utility.cmpmobileno;
      salesHedEntity.invoiceNo = invoiceNo;
      salesHedEntity.voucherType = vchSelectedId;
      salesHedEntity.partyId = partySelectedId;
      salesHedEntity.date = dateController.text;
      salesHedEntity.paymentTerms = paymentTermsController.text;
      salesHedEntity.partyMobileNo = partyMobileNo;
      salesHedEntity.narration = remarkController.text;
      salesHedEntity.type = widget.vchType;
     // salesHedEntity.recPartyAmt = '';
      salesHedEntity.originalInvoiceNo = orgInvNoController.text;
      salesHedEntity.originalInvoiceDate =orgInvDateController.text == '' ? '' : orgInvDateController.text;
      salesHedEntity.cnReason = creditNoteReasonSelected;
      salesHedEntity.isGstAutoCal = isGstAutoCalEnable?'Yes':'No';

      await ApiCall.salesHedPostApi(salesHedEntity).then((responseBody) async {
        if(mounted){
          Navigator.of(context).pop();
          // print('object ${responseBody['message']}');
          if (responseBody['message'] == 'Data Inserted Successfully') {
            setState(() {
              salesUniqueId = responseBody['unique_id'];
              isSaleSaved = true;
            });
            await getSalesDataAPI();
          } else {
            await Utility.showAlert(icons:  Icons.error_outline_outlined,iconcolor:  Colors.redAccent,title:  'Alert',msg:  "Oops there is an Error!.");
          }
        }
      });
    }
    return true;
  }

  Future taxLedgerPostApi() async {
    List<Map<String, dynamic>> ledgerListMap = [];
    List taxLedgerNameList = ['CGST', 'SGST', 'IGST'];
    List<num> taxLedgerAmountList = [
      cgstLedgerAmt,
      sgstLedgerAmt,
      igstLedgerAmt
    ];
    for (int i = 0; i < taxLedgerNameList.length; i++) {
      SalesLedgerEntity ledgertity = SalesLedgerEntity();
      ledgertity.companyid = Utility.companyId;
      ledgertity.mobileno = Utility.cmpmobileno;
      ledgertity.hedUniqueId = salesUniqueId;
      ledgertity.ledgerId = taxLedgerNameList[i];
      ledgertity.amount = taxLedgerAmountList[i].toStringAsFixed(2);
      ledgerListMap.add(ledgertity.toMap());
    }
    await ApiCall.taxLedgerDetPostApi(ledgerListMap).then((response) async {
      // Navigator.of(context).pop();
      // if (response == 'Data Inserted Successfully') {
      // await Utility.showAlert(context, Icons.check, Colors.green, 'Status','Data Inserted Succesfully').then((value) {
      //   Navigator.of(context).pop();
      //   getSalesDataAPI();
      // });
      // } else {
      //   await Utility.showAlert(context, Icons.close, Colors.red, 'Error','Oops there is an error!');
      // }
    });
  }

  void _navigateLedgerScreen(String title, int index) async {
    // await Navigator.push(context,MaterialPageRoute(builder: (context) => 
    // // AddLedgers(salesId: salesUniqueId,title: title,vchType: widget.vchType,ledgerlist: title == 'Add Ledgers'? null: salesHeaderEntity!.ledger![index],)));
    // getSalesDataAPI();
  }

  //Add Inventory Details
  void _navigateItemScreen(String title, int index) async {
    // print('navigate_inventory:$index');
    await Navigator.push(context,MaterialPageRoute(builder: (context) => 
    InventoryDetails(uniqueId: salesUniqueId,title: title,vchType: widget.vchType,
    itemlist: title == 'Add Inventory Details'? null: salesHeaderEntity!.items![index],)));
    getSalesDataAPI();
  }

  Future salesSavePostApi() async {
    if (isGstAutoCalEnable) {
      await taxLedgerPostApi();
    }
    await salesPostApi().then((value) {
      Navigator.of(context).pop();
    });
  }

  Future salesPostApi() async {
    SalesHeaderEntity salesHedEntity = SalesHeaderEntity();
    salesHedEntity.companyId = Utility.companyId;
    salesHedEntity.uniqueId = salesUniqueId;
    salesHedEntity.totalAmount = totalAmount.toStringAsFixed(2);
    salesHedEntity.cashAmount = cashController.text;
    salesHedEntity.bankInstNo = bankInstNoController.text;
    salesHedEntity.bankAmount = bankAmtController.text;
    salesHedEntity.cardInstNo = cardInstNoController.text;
    salesHedEntity.cardAmount = cardAmtController.text;
    salesHedEntity.giftReferenceNo = ''; //cardinstNoController.text;
    salesHedEntity.giftAmount = giftAmtController.text;
    salesHedEntity.paymentTerms = paymentTermsController.text;
    salesHedEntity.narration = remarkController.text;

    await ApiCall.salesSavePostApi([salesHedEntity.toMap()])
        .then((response) async {
      if (response == 'Data Inserted Successfully') {
        await Utility.showAlert(icons:  Icons.check,iconcolor:  Colors.green,title:  'Status',
                msg: 'Data Inserted Succesfully')
            .then((value) {
          Navigator.of(context).pop(true);
        });
      } else {
        await Utility.showAlert(icons:  Icons.close,iconcolor:  Colors.red,title:  'Error',
          msg:   'Oops there is an error!');
      }
    });
  }
}
