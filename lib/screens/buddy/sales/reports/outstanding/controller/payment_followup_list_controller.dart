import 'package:get/get.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/buddy/outstanding/paymentfollowupentity.dart';
import 'package:sysconn_sfa/api/entity/company/partyentity.dart';

class PaymentFollowupController extends GetxController {
  final String? partyId;
  PaymentFollowupController(this.partyId);

  RxList<PaymentFollowupEntity> paymentFollowupDataList =
      <PaymentFollowupEntity>[].obs;

  Rxn<PartyEntity> partyEntityvalue = Rxn<PartyEntity>();

  var isDataLoad = 0.obs;

  var customerName = ''.obs;
  var contactno = ''.obs;
  var contactPerson = ''.obs;
  var customerClassification = ''.obs;
  var paymentTerm = ''.obs;
  var creditLimit = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initLoad();
  }

  Future<void> initLoad() async {
    await getPartyDetailsApi();
    await getPaymentFollowupStatusDataAPI();
  }


  Future<int> getPartyDetailsApi() async {
    try {
      PartyEntity? partyEntity = await ApiCall.getPartyDetailsApi(
        partyid: partyId!,
      );

      if (partyEntity != null) {
        partyEntityvalue.value = partyEntity;

        customerName.value = partyEntity.mailingname ?? '';
        contactno.value = partyEntity.contactNo ?? '';
        contactPerson.value = partyEntity.contactPerson ?? '';
        customerClassification.value = partyEntity.customerClassification ?? '';
        paymentTerm.value = partyEntity.creditdays?.toString() ?? '';
        creditLimit.value = partyEntity.creditlimit?.toString() ?? '';
      }
    } catch (ex) {
      print("Party API Error : $ex");
    }

    return 1;
  }

  Future getPaymentFollowupStatusDataAPI() async {
    isDataLoad.value = 0;
    paymentFollowupDataList.clear();

    await ApiCall.getPaymentFollowupStatusAPI(partyid: partyId!).then((
      followupvalue,
    ) {
      if (followupvalue.isNotEmpty) {
        paymentFollowupDataList.value = followupvalue;
        isDataLoad.value = 1;
      } else {
        isDataLoad.value = 2;
      }
    });
  }
}
