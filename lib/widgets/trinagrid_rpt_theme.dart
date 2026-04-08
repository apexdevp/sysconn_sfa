import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:trina_grid/trina_grid.dart';

//pratiksha p add
Theme trinaCustomTheme({
  Key? key,
  required BuildContext? context,
  int? rowsPerPage,
  int frozenColumnsCount = 0,
  bool showCheckboxColumn = false,
  Function(TrinaGridOnChangedEvent)? onChanged,
  Function(TrinaGridOnLoadedEvent)? onLoaded,
  Function(TrinaGridOnRowCheckedEvent)? onRowChecked,
  List<TrinaColumnGroup>? columnGroups,
  // required List<TrinaColumn> columns,
  required RxList<TrinaColumn> columns,
  double? rowHeight,
  double? columnHeight,
  required RxList<TrinaRow> rows,
  bool iscolumnsize = false,
  // CreateFooterCallBack? createFooter,
  TrinaGridConfiguration? configuration,
  CreateHeaderCallBack? createHeader,
  TrinaSelectDateCallBack? selectDateCallback, //pratiksha p 22-08-2025
  Function(TrinaGridOnSelectedEvent)? onselected,
  TrinaGridMode? select,
  TextStyle? cellTextStyle = const TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w600,
    color: Colors.blue,
  ),
  bool isPagination = true,
}) {
  return Theme(
    data: Theme.of(context!).copyWith(
      popupMenuTheme: const PopupMenuThemeData(
        textStyle: TextStyle(color: Colors.black),
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStateProperty.all<Color>(Colors.black),
        side: BorderSide(color: Colors.black, width: 2),
      ),
    ),
    child: TrinaGrid(
      columns: columns,
      rows: rows,
      columnGroups: columnGroups,
      onChanged: onChanged,
      selectDateCallback: selectDateCallback, //pratiksha p 22-08-2025
      // onLoaded: onLoaded,
      onLoaded: (event) {
        event.stateManager.setShowColumnFilter(true);
        if (!isPagination) {
          event.stateManager.setPageSize(rows.length, notify: true);
        }

        if (onLoaded != null) onLoaded(event);
      },
      onRowChecked: onRowChecked,
      onSelected: onselected,
      mode: select == null ? TrinaGridMode.readOnly : TrinaGridMode.select,
      // configuration: TrinaGridConfiguration(columnSize: iscolumnsize == false
      // ? const TrinaGridColumnSizeConfig(autoSizeMode: TrinaAutoSizeMode.scale,)
      // : const TrinaGridColumnSizeConfig(resizeMode: TrinaResizeMode.normal,),
      configuration: TrinaGridConfiguration(
        columnSize: iscolumnsize == false
            ? const TrinaGridColumnSizeConfig(
                autoSizeMode: TrinaAutoSizeMode.scale,
              )
            : const TrinaGridColumnSizeConfig(
                resizeMode: TrinaResizeMode.normal,
              ),
        localeText: const TrinaGridLocaleText(
          filterContains: 'Search...',
          filterStartsWith: 'Starts with...',
          filterEndsWith: 'Ends with...',
        ),

        style: TrinaGridStyleConfig(
          columnTextStyle: MediaQuery.of(context).size.width < 400
              ? kTxtStl11B
              : kTxtStl13B,
          cellTextStyle: kTxtStl13N,
          activatedColor: Colors.orange.shade50,
          activatedBorderColor: Colors.orange.shade600,
          cellActiveColor: Colors.grey.shade100,
          filterPopupHeaderColor: Colors.white,
          filterHeaderIconColor: Colors.grey,
          cellCheckedColor: kAppColor,
          rowHeight: rowHeight ?? 30,
          columnHeight: columnHeight ?? 60,
          columnFilterHeight: 40,
        ),

        scrollbar: const TrinaGridScrollbarConfig(
          isDraggable: true,
          isAlwaysShown: true,
        ),
      ),
      createFooter: isPagination
          ? (stateManager) {
              stateManager.setPageSize(rowsPerPage ?? 16, notify: true);
              return TrinaPagination(stateManager);
            }
          : null,
      createHeader: createHeader,
      //  Te:cellTextStyle
    ),
  );
}

TrinaColumn gridColumnRpt({
  required String field,
  required String title,
  bool isFilter = true,
  bool isSorting = true,
  bool gridLine = true,
  bool isfooter = false,
  TrinaColumnType? type,
  bool issuppressedAutosize = false,
  bool enableRowChecked = false,
  Widget Function(TrinaColumnRendererContext)? renderer,
  bool istext = true,
  bool istime = false,
  bool istextalignright = false,
  bool iscenter = false,
  TrinaAggregateColumnType coltype = TrinaAggregateColumnType.sum,
  bool hide = false,
  bool isstartcolumn = false,
  TrinaAggregateColumnGroupedRowType total =
      TrinaAggregateColumnGroupedRowType.expandedRows,
  double width = 190,
  // double minWidth = 140,
  bool isdecimal = false,
  bool iscurrency = false,
  int? maxLines,
}) {
  // ---------- FORMAT TITLE ----------
  final formattedTitle = title
      .split(' ')
      .map(
        (word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : '',
      )
      .join(' ');

  return TrinaColumn(
    field: field,

    //  REQUIRED PARAMETER
    title: formattedTitle,

    // MULTI-LINE HEADER
    titleSpan: TextSpan(
      children: [
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Text(
            formattedTitle,
            softWrap: true,
            maxLines: maxLines ?? 2,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.start,
            style: kTxtStl13B,
          ),
        ),
      ],
    ),

    // Force wrapping instead of autosize shrinking
    suppressedAutoSize: false,

    enableRowChecked: enableRowChecked,
    titleTextAlign: TrinaColumnTextAlign.start,

    // ---------- COLUMN TYPE ----------
    // type: istext
    //     ? TrinaColumnType.text()
    //     : istime
    //         ? TrinaColumnType.time()
    //         :iscurrency?
    //          TrinaColumnType.currency(format: '₹#,##0.00')
    //         : isdecimal
    //             ? TrinaColumnType.number(format: '####0.00')
    //             : TrinaColumnType.number(format: '####.##'),
    type: istext == true
        ? TrinaColumnType.text()
        : TrinaColumnType.number(format: '#,##,##0'),
    // ---------- FOOTER ----------
    footerRenderer: isfooter
        ? (rendererContext) {
            if (istime) {
              int totalMinutes = 0;
              final rows =
                  rendererContext.stateManager.refRows.filterOrOriginalList;

              for (final row in rows) {
                final val = row.cells[field]?.value;
                if (val is String && val.contains(':')) {
                  final parts = val.split(':');
                  if (parts.length == 2) {
                    final h = int.tryParse(parts[0]) ?? 0;
                    final m = int.tryParse(parts[1]) ?? 0;
                    totalMinutes += (h * 60) + m;
                  }
                }
              }

              final hStr = (totalMinutes ~/ 60).toString().padLeft(2, '0');
              final mStr = (totalMinutes % 60).toString().padLeft(2, '0');

              return _footerText('$hStr:$mStr', alignRight: true);
            }

            final aggregateWidget = TrinaAggregateColumnFooter(
              rendererContext: rendererContext,
              type: coltype,
              iterateRowType: TrinaAggregateColumnIterateRowType.filtered,
              format: isdecimal
                  ? '####0.00'
                  : iscurrency
                  ? '₹#,##0.00'
                  : '#,###',
              alignment: Alignment.centerRight,
              groupedRowType: total,
            );

            if (isstartcolumn) {
              return Row(
                children: [
                  _footerText('Total :'),
                  const Spacer(),
                  aggregateWidget,
                ],
              );
            }

            return aggregateWidget;
          }
        : null,

    // renderer: renderer,
    renderer:
        renderer ??
        (type is TrinaColumnTypeDate
            ? (context) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    context.cell.value?.toString() ?? '',
                    style: const TextStyle(
                      fontFamily: 'Courier', //  Monospace font
                      fontSize: 13,
                    ),
                  ),
                );
              }
            : null),

    textAlign: (istext && !istextalignright)
        ? TrinaColumnTextAlign.start
        : iscenter
        ? TrinaColumnTextAlign.center
        : TrinaColumnTextAlign.end,

    width: width,
    // minWidth: minWidth,
    hide: hide,
  );
}

Widget _footerText(String text, {bool alignRight = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Text(
      text,
      style: kTxtStl13B, // uses your existing theme
      textAlign: alignRight ? TextAlign.right : TextAlign.left,
    ),
  );
}
