import 'package:flutter/material.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';
import 'package:get/get.dart'; 
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/api/controllers/utility/plutogrid_controller.dart';

Theme plutoCustomTheme({
  Key? key,
  int? frozenColumnsCount = 0,
  bool showCheckboxColumn = false,
  Function(PlutoGridOnChangedEvent)? onChanged,
  Function(PlutoGridOnLoadedEvent)? onLoaded,
  Function(PlutoGridOnRowCheckedEvent)? onRowChecked, 
  List<PlutoColumnGroup>? columnGroups,
  required List<PlutoColumn> columns,
  required List<PlutoRow> rows,
  PlutoGridConfiguration? configuration,
  CreateHeaderCallBack? createHeader,
  Function(PlutoGridOnSelectedEvent)? onSelected,
  PlutoGridMode? select,
  TextStyle? cellTextStyle = const TextStyle(
      fontSize: 13.0, fontWeight: FontWeight.w600, color: Colors.red),
}) {
  final PlutoGridController gridController = Get.find<PlutoGridController>();

  return Theme(
    data: ThemeData.from(
      colorScheme: const ColorScheme.dark(),
    ),
    child: PlutoGrid(
      columns: columns,
      rows: rows,
      columnGroups: columnGroups,
      onChanged: onChanged,
      onLoaded: onLoaded,
      onRowChecked: onRowChecked,
      onSelected: onSelected,
      mode: select ?? PlutoGridMode.normal,
      configuration: PlutoGridConfiguration(
        style: PlutoGridStyleConfig(
          columnTextStyle: kTxtStl11B,
          cellTextStyle: kTxtStl11N,
          activatedColor: Colors.grey.shade100,
          activatedBorderColor: kContrastDarkColor,
          cellActiveColor: Colors.grey.shade100,
          filterHeaderIconColor: Colors.grey.shade100,
          cellCheckedColor: kContrastDarkColor,
          rowHeight: 30,
          columnHeight: 30,
        ),
        scrollbar: const PlutoGridScrollbarConfig(
          draggableScrollbar: true,
          isAlwaysShown: true,
          scrollBarColor: Colors.grey,
        ),
      ),
      createFooter: (stateManager) {
        stateManager.setPageSize(gridController.rowsPerPage.value, notify: true);
        return PlutoPagination(stateManager);
      },
      createHeader: createHeader,
    ),
  );
}
