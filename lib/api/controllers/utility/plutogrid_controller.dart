import 'package:get/get.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

class PlutoGridController extends GetxController {
  var rowsPerPage = 16.obs;  
  var selectedRows = <PlutoRow>[].obs; 

  void setRowsPerPage(int newRowsPerPage) {
    rowsPerPage.value = newRowsPerPage;
  }

  void setSelectedRows(List<PlutoRow> newSelectedRows) {
    selectedRows.value = newSelectedRows;
  }
}
