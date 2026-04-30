
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/floating_point_action_button.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/business_opportunity/opportunities_deals_rep_entity.dart';
import 'package:sysconn_sfa/screens/bizOpportunities/controller/opportunities_deals_create_controller.dart';
import 'package:sysconn_sfa/screens/bizOpportunities/controller/opportunities_deals_rep_controller.dart';
import 'package:sysconn_sfa/screens/bizOpportunities/view/opportunities_deals_create_dialog.dart';
import 'package:sysconn_sfa/screens/bizOpportunities/view/opportunities_deals_view.dart';
import 'package:sysconn_sfa/widgets/calendarsingleview.dart';
import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
import 'package:sysconn_sfa/widgetscustome/entry_button.dart';

//Shweta 20-04-2026
class OpportunitiesDealsReport extends StatelessWidget {
  OpportunitiesDealsReport({super.key});

  final OpportunitiesDealsRepController controller =
      Get.put(OpportunitiesDealsRepController());

  final List<String> labels = const [
    'New',
    'InDiscussion',
    'InNegotiation',
    'Hold',
    'Completed',
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: SfaCustomAppbar(
      //   title: 'Opportunities & Deals',
      //   // dateChangeFunction: () {
      //   //   controller.getOpportunitiesDealsReportAPI();
      //   // },
      // ),

//       appBar: AppBar(
//   title: Obx(() {
//     if (controller.isSearch.value) {
//       return TextField(
//         controller: controller.searchController,
//         autofocus: true,
//         decoration: const InputDecoration(
//           hintText: 'Search customer, product...',
//           border: InputBorder.none,
//           hintStyle: TextStyle(color: Colors.white54),
//         ),
//         style: const TextStyle(color: Colors.white, fontSize: 16),
//         onChanged: (text) {
//           controller.searchChange.value = text.isNotEmpty;
//           controller.onSearchChanged(text);
//         },
//       );
//     }
//     return const Text('Opportunities & Deals'); // ← always returns Text
//   }),
//   actions: [
//     Obx(() {
//       if (controller.isSearch.value) {
//         return IconButton(
//           icon: const Icon(Icons.clear),
//           onPressed: () => controller.clearSearch(),
//         );
//       }
//       return IconButton(
//         icon: const Icon(Icons.search),
//         onPressed: () => controller.isSearch.value = true,
//       );
//     }),
//   ],
//   bottom: PreferredSize(
//     preferredSize: const Size.fromHeight(48.0),     //(60.0),
//     // child: Column(
//     //   children: [
//     //     Row(
//     //       mainAxisAlignment: MainAxisAlignment.end,
//     //       children: [
//     child: Padding(
//     padding: const EdgeInsets.only(bottom: 8.0),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//             Obx(
//               () => CalendarSingleView(
//                 fromDate: controller.fromDate.value,
//                 toDate: controller.toDate.value,
//                 function: () async {
//                   await selectDateRange(
//                     controller.fromDate.value,
//                     controller.toDate.value,
//                   ).then((range) {
//                     controller.fromDate.value = range.start;
//                     controller.toDate.value = range.end;
//                   });
//                   controller.getOpportunitiesDealsReportAPI();
//                 },
//               ),
//             ),
//           ],
//         ),
//         // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
//       // ],
//     ),
//   ),
// ),

        appBar: SfaCustomAppbar(
          title: 'Opportunities & Deals',
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Obx(
                      () => CalendarSingleView(
                        fromDate: controller.fromDate.value,
                        toDate: controller.toDate.value,
                        function: () async {
                          await selectDateRange(
                            controller.fromDate.value,
                            controller.toDate.value,
                          ).then((dateTimeRange) {
                            controller.fromDate.value = dateTimeRange.start;
                            controller.toDate.value = dateTimeRange.end;
                          });
                          controller.getOpportunitiesDealsReportAPI(); // reload
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingButton(
          isExtended: false,

          icon: Icon(Icons.add),
          function: () 
          async {
            // await Get.to(() => CollectionCreate(vchType: type));
            final controller = Get.put(OpportunitiesDealsEditController());

            controller.clearFields(); // IMPORTANT

            await Get.dialog(
              OpportunitiesDealsCreateDialog(), // create this below
              barrierDismissible: false,
            );
          },
        ),
      

      // body: Column(
      body: Container(
        padding: const EdgeInsets.fromLTRB(4, 4, 4, 9),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: Colors.grey[50],
        ),
        child: Column(
          children: [
            
            /// STAGE FILTER
            SizedBox(
            // Obx(() => SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: labels.length,
                itemBuilder: (_, index) {
                  return _summaryCard(
                    index,
                    controller.stageCounts[index].toString(),
                    labels[index],
                  );
                },
              ),
              ),
            // ),
            const SizedBox(height: 6),

            /// LIST
            Expanded(
              child: Obx(() {
                if (controller.isDataLoad.value == 0) {
                  return Center(child: Utility.processLoadingWidget());
                }

                if (controller.isDataLoad.value == 2) {
                  return const Center(child: const NoDataFound());
                }

                return ListView.builder(
                  itemCount: controller.filteredList.length,
                  itemBuilder: (_, index) {
                    // final row = controller.filteredList[index].cells;
                    final data = controller.filteredList[index];

                    // final data = OpportunitiesDealsRepEntity()
                    //   ..businessOpportunityId =
                    //       row['businessopportunityid']?.value.toString()
                    //   ..retailerName =
                    //       row['retailer_name']?.value.toString()
                    //   ..title = row['title']?.value.toString()
                    //   ..description = row['description']?.value.toString()
                    //   ..productDesc =
                    //       row['product_desc']?.value.toString()
                    //   ..qty = parseInt(row['qty']?.value)
                    //   ..rate = parseDouble(row['rate']?.value)
                    //   ..total = parseDouble(row['total']?.value)
                    //   ..stage = parseInt(row['stage']?.value)
                    //   ..status = parseInt(row['status']?.value)
                    //   ..createdAt = row['createdat']?.value.toString();

                    return _card(context, data, size);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ================= CARD =================
  
  Widget _card(
    BuildContext context,
    OpportunitiesDealsRepEntity data,
    Size size,
  ) {

    Color _getStageColor(int? stage) {
      switch (stage) {
        case 0: // New
          return Colors.blue;
        case 1: // InDiscussion
          return Colors.orange;
        case 2: // InNegotiation
          return Colors.deepPurple;
        case 3: // Hold
          return Colors.grey;
        case 4: // Completed
          return Colors.green;
        default:
          return Colors.black;
      }
    }

    final controller = Get.find<OpportunitiesDealsRepController>();

    return Column(
      children: [
        GestureDetector(
        onTap: () {
          Get.to(
            () => OpportunitiesDealsView(),
            arguments: {
              'businessopportunityid': data.businessOpportunityId ?? '',
              'title': data.title ?? '',
              'createdat': data.createdAt ?? '',
              'retailer_name': data.retailerName ?? '',
              'retailer_code': data.retailerCode ?? '',
              'description': data.description ?? '',
              'product_desc': data.productDesc ?? '',
              'product_code': data.productCode ?? '',
              'rate': data.rate ?? 0,
              'qty': data.qty ?? 0,
              'total': data.total ?? 0.0,
              'source': data.source ?? '',
              'status': data.status ?? 0,
              'stage': data.stage ?? 0,
              'updatedat': data.updatedat ?? '',
              'rating': data.rating ?? '',
              'productpricelistid': data.productPriceListId ?? '',
              'priority': data.priority ?? '',
            },
          );
        },
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

          /// TITLE
          // title: Text(
          //   data.title ?? '',
          //   style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          //   overflow: TextOverflow.ellipsis,
          // ),
          title: Row(
            children: [
              /// TITLE
              Expanded(
                child: Text(
                  data.title ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),

              /// STAGE BADGE
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _getStageColor(data.stage).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  controller.getStageLabel(data.stage),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _getStageColor(data.stage),
                  ),
                ),
              ),
            ],
          ),

          /// SUBTITLE (LIKE SALES SCREEN)
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),

              _row("Customer", data.retailerName, size),
              _row("Product", data.productDesc, size),

              _row("Qty", data.qty?.toString(), size),
              _row("Rate", data.rate?.toString(), size),
              _row("Total", data.total?.toString(), size),

              // _row("Stage", controller.getStageLabel(data.stage), size),

              Row(
                children: [
                  SizedBox(
                    width: size.width * 0.30,
                    child: const Text("Status",
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ),
                  const Text(": "),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: data.status == 0
                          ? const Color(0xFFE8F5E9)
                          : const Color(0xFFFDECEA),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      controller.getStatusLabel(data.status),
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ],
          ),

          /// RIGHT SIDE MENU
          // trailing: PopupMenuButton<String>(
          //   onSelected: (value) async {
          //     if (value == 'delete') {
          //       Utility.showAlertYesNo(
          //         title: "Delete Opportunity",
          //         msg: "Are you sure?",
          //         yesBtnFun: () async {
          //           await controller.deleteOpportunitiesApi(
          //             businessOpportunityId:
          //                 data.businessOpportunityId ?? '',
          //           );
          //         },
          //         noBtnFun: () => Get.back(),
          //       );
          //     }
          //   },
          //   itemBuilder: (_) => [
          //     const PopupMenuItem(value: 'view', child: Text('View')),
          //     const PopupMenuItem(value: 'edit', child: Text('Edit')),
          //     if (_isToday(data.createdAt))
          //       const PopupMenuItem(
          //           value: 'delete', child: Text('Delete')),
          //   ],
          // ),
        ),
        ),

        const Divider(height: 1),
      ],
    );
    
  }


  Widget _row(String label, String? value, Size size) {
    return Row(
      children: [
        SizedBox(
          width: size.width * 0.30,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        const Text(": "),
        Expanded(
          child: Text(
            value ?? '',
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  // ================= SUMMARY CARD =================
  
  Widget _summaryCard(int index, String count, String label) {
    final controller = Get.find<OpportunitiesDealsRepController>();

    const double width = 120;

    return Obx(() {
      final count = controller.stageCounts[index].toString();

      return InkWell(
        onTap: () => controller.filterByStage(index), // SAME LOGIC

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: width,

          decoration: BoxDecoration(
            color: controller.selectStage.value == index.toString()
                ? Colors.black.withOpacity(0.1)
                : Colors.white,

            borderRadius: BorderRadius.circular(4),

            border: Border.all(
              color: controller.selectStage.value == index.toString()
                  ? Colors.black
                  : Colors.grey.shade300,
            ),
          ),

          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// COUNT
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  count,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 2),

              /// LABEL + ICON
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.grid_view_rounded,
                    size: 12,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 3),

                  Flexible(
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  // ================= DATE CHECK =================
  bool _isToday(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) return false;

    try {
      final format = DateFormat('dd-MM-yyyy HH:mm:ss');
      final created = format.parse(createdAt);
      final now = DateTime.now();

      return created.year == now.year &&
          created.month == now.month &&
          created.day == now.day;
    } catch (e) {
      return false;
    }
  }

  // inside OpportunitiesDealsReport class

  Widget _buildSearchField() {
    return TextField(
      controller: controller.searchController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search customer, product, title...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (text) {
        controller.searchChange.value = text.isNotEmpty;
        controller.onSearchChanged(text);
      },
    );
  }

  List<Widget> _buildActions() {
    // isSearch.value is read here — Obx above will re-run this on change
    if (controller.isSearch.value) {
      return [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => controller.clearSearch(),
        ),
      ];
    }
    return [
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () => controller.isSearch.value = true,
      ),
    ];
  }
}