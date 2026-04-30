import 'package:get/get.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/sales/sales_register_rep_entity.dart';

class CollectionReportController extends GetxController {
  final String type;
  CollectionReportController(this.type);
  RxDouble totalAmount = 0.0.obs;
  RxInt isDataLoad = 0.obs;
  RxList<SalesRegisterReportEntity> collectionDetailsList =
      <SalesRegisterReportEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    getCollectionDataApi();
  }

  Future getCollectionDataApi() async {
    isDataLoad.value = 0;
    collectionDetailsList.clear();
    totalAmount.value = 0.0;
    await ApiCall.getCollectionReportAPI(type: type).then((collectionvalue) {
      if (collectionvalue.isNotEmpty) {
        collectionDetailsList.value = collectionvalue;
        // ✅ Calculate total
        for (var item in collectionvalue) {
          totalAmount.value +=
              double.tryParse(item.totalammount.toString()) ?? 0.0;
        }

        isDataLoad.value = 1;
      } else {
        isDataLoad.value = 2;
      }
    });
  }
}
