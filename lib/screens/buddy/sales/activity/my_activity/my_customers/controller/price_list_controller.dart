import 'package:get/get.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/company/pricelistentity.dart';

class PriceListController extends GetxController {
  RxInt isDataLoad = 0.obs;

  RxList<PriceListEntity> priceLevelList = <PriceListEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    getpricelistDataApi();
  }

  Future getpricelistDataApi() async {
    isDataLoad.value = 0;
    priceLevelList.clear();

    final itemValue = await ApiCall.getpricelistApi();
    if (itemValue.isNotEmpty) {
      priceLevelList.assignAll(itemValue);
      isDataLoad.value = 1;
    } else {
      isDataLoad.value = 2;
    }
  }
}
