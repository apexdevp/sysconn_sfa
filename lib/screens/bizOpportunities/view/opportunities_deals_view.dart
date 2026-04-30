import 'package:flutter/material.dart';
// import 'package:sysconn_oms/app/models/opportunities&deals/opportunities_deals_rep_entity.dart';
// import 'package:sysconn_oms/app/modules/opportunitiesDeals/controller/opportunities_deals_create_controller.dart';
// import 'package:sysconn_oms/app/modules/opportunitiesDeals/controller/opportunities_deals_rep_controller.dart';
// import 'package:sysconn_oms/app/modules/opportunitiesDeals/controller/opportunities_deals_view_controller.dart';
// import 'package:sysconn_oms/app/modules/opportunitiesDeals/view/opportunities_deals_activity_view.dart';
// import 'package:sysconn_oms/app/modules/opportunitiesDeals/view/opportunities_deals_create_dialog.dart';
// import 'package:sysconn_oms/app/utilities/utility.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/business_opportunity/opportunities_deals_rep_entity.dart';
import 'package:sysconn_sfa/screens/bizOpportunities/controller/opportunities_deals_create_controller.dart';
import 'package:sysconn_sfa/screens/bizOpportunities/controller/opportunities_deals_rep_controller.dart';
import 'package:sysconn_sfa/screens/bizOpportunities/controller/opportunities_deals_view_controller.dart';
import 'package:sysconn_sfa/screens/bizOpportunities/view/opportunities_deals_activity_view.dart';
import 'package:sysconn_sfa/screens/bizOpportunities/view/opportunities_deals_create_dialog.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

class OpportunitiesDealsView extends StatelessWidget {
  final OpportunitiesDealsViewController controller = Get.put(
    OpportunitiesDealsViewController(),
  );

  final data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final entity = OpportunitiesDealsRepEntity.fromJson(
      Map<String, dynamic>.from(data),
    );

    controller.selectedOpportunity.value = entity;

    controller.selectedStatus.value =
        Get.find<OpportunitiesDealsRepController>().getStatusLabel(
          int.tryParse(data['status'].toString()),
        );

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: SfaCustomAppbar(
        title: "Opportunity #${data['businessopportunityid']}",

        // // 🔥 Pass your 3-dot menu here
        // actions: [
        //   PopupMenuButton<String>(
        //     onSelected: (value) async {
        //       await Future.delayed(const Duration(milliseconds: 100));

        //       if (value == "edit") {
        //         final editController = Get.put(
        //           OpportunitiesDealsEditController(),
        //         );

        //         editController.clearFields(isEdit: true);

        //         final entity = OpportunitiesDealsRepEntity.fromJson(
        //           Map<String, dynamic>.from(data),
        //         );

        //         editController.loadOpportunityForEdit(entity);

        //         Get.dialog(
        //           OpportunitiesDealsCreateDialog(),
        //           barrierDismissible: false,
        //         );
        //       }

        //       if (value == "delete") {
        //         final repController =
        //             Get.find<OpportunitiesDealsRepController>();

        //         Utility.showAlertYesNo(
        //           iconData: Icons.warning_amber_rounded,
        //           iconcolor: Colors.red,
        //           title: "Delete Opportunity",
        //           msg: "Are you sure you want to delete this opportunity?",
        //           yesBtnFun: () async {
        //             await repController.deleteOpportunitiesApi(
        //               businessOpportunityId:
        //                   data['businessopportunityid'] ?? '',
        //             );
        //           },
        //           noBtnFun: () => Get.back(),
        //         );
        //       }
        //     },
        //     itemBuilder: (context) => [
        //       const PopupMenuItem(value: "edit", child: Text("Edit")),
        //       const PopupMenuItem(value: "delete", child: Text("Delete")),
        //     ],
        //   ),

        //   const SizedBox(width: 10),
        // ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER CARD
            _buildHeaderCard(context),

            const SizedBox(height: 10),

            /// CUSTOMER + PRODUCT CARD
            _buildCustomerProductCard(),

            const SizedBox(height: 10),

            /// ACTIVITIES
            OpportunitiesDealsActivityView(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ─── HEADER CARD ──────────────────────────────────────────────────────────

  Widget _buildHeaderCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            Text(
              data['title'] ?? "",
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            /// META INFO
            Text(
              "ID: ${data['businessopportunityid']}  |  ${data['createdat']}",
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),

            Text(
              "Assigned: ${data['retailer_name'] ?? ''}",
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),

            const SizedBox(height: 12),

            /// STATUS ROW
            Obx(
              () => Row(
                children: [
                  

                  /// CURRENT STATUS BADGE
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      controller.selectedStatus.value.isEmpty
                          ? "Open"
                          : controller.selectedStatus.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ),

                  const SizedBox(width: 4),

                  /// CHANGE STATUS BUTTON
                  // Expanded(
                  //   child: GestureDetector(
                  //     onTap: () => _showStatusBottomSheet(context),
                  //     child: Container(
                  //       padding: const EdgeInsets.symmetric(
                  //         horizontal: 12,
                  //         vertical: 9,
                  //       ),
                  //       decoration: BoxDecoration(
                  //         border: Border.all(color: Colors.grey.shade400),
                  //         borderRadius: BorderRadius.circular(6),
                  //         color: Colors.white,
                  //       ),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Expanded(
                  //             child: Text(
                  //               controller.selectedStatus.value.isEmpty
                  //                   ? "Select Status"
                  //                   : controller.selectedStatus.value,
                  //               style: const TextStyle(fontSize: 14),
                  //               overflow: TextOverflow.ellipsis,
                  //             ),
                  //           ),
                  //           const Icon(
                  //             Icons.arrow_drop_down,
                  //             color: Colors.black54,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  /// 🔹 SMALL DROPDOWN
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: controller.selectedStatus.value.isEmpty
                            ? null
                            : controller.selectedStatus.value,
                        hint: const Text(
                          "Change",
                          style: TextStyle(fontSize: 12),
                        ),
                        icon: const Icon(Icons.arrow_drop_down, size: 18),
                        style: const TextStyle(color: Colors.black, fontSize: 12),
                        items: ["Open", "Declined", "Fulfilled"]
                            .map((status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedStatus.value = value;
                            controller.updateStatusApi();
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// 🔹 EDIT ICON
                  _iconBox(
                    Icons.edit,
                    tooltip: "Edit",
                    onTap: () {
                      final editController = Get.put(
                        OpportunitiesDealsEditController(),
                      );

                      editController.clearFields(isEdit: true);

                      final entity = OpportunitiesDealsRepEntity.fromJson(
                        Map<String, dynamic>.from(data),
                      );

                      editController.loadOpportunityForEdit(entity);

                      Get.dialog(
                        OpportunitiesDealsCreateDialog(),
                        barrierDismissible: false,
                      );
                    },
                  ),

                  const SizedBox(width: 6),

                  /// 🔹 DELETE ICON
                  if (isToday(data['createdat']?.toString()))
                  _iconBox(
                    Icons.delete,
                    tooltip: "Delete",
                    onTap: () {
                      final repController =
                          Get.find<OpportunitiesDealsRepController>();

                      Utility.showAlertYesNo(
                        iconData: Icons.warning_amber_rounded,
                        iconcolor: Colors.red,
                        title: "Delete Opportunity",
                        msg: "Are you sure you want to delete this opportunity?",
                        yesBtnFun: () async {
                          await repController.deleteOpportunitiesApi(
                            businessOpportunityId:
                                data['businessopportunityid']?.toString() ?? '',
                          );
                        },
                        noBtnFun: () => Get.back(),
                      );
                    },
                  ),

                  

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── CUSTOMER + PRODUCT CARD ───────────────────────────────────────────────

  Widget _buildCustomerProductCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// CUSTOMER DETAILS
            _sectionTitle("Customer Details:"),
            const SizedBox(height: 6),

            /// NAME + RATING
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: data['retailer_name'] ?? "N/A",
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: " ⭐ (${controller.rating})",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 2),

            Text(
              "Customer ID: ${data['retailer_code'] ?? ''}",
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),

            const SizedBox(height: 8),

            /// DESCRIPTION BOX
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(10),
                color: Colors.orange.withOpacity(0.05),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline,
                      color: Colors.grey, size: 15),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      data['description'] ?? "",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// PRODUCT DETAILS
            _sectionTitle("Product Details:"),
            const SizedBox(height: 6),

            _detailRow("Product:", data['product_desc'] ?? ""),
            _detailRow("Rate:", "₹${data['rate'] ?? ''}"),
            _detailRow("Quantity:", "${data['qty'] ?? ''} / Nos"),

            /// TOTAL (highlighted)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const SizedBox(
                    width: 100,
                    child: Text(
                      "Total:",
                      style: TextStyle(
                          color: Colors.black54, fontSize: 13),
                    ),
                  ),
                  Text(
                    "₹${data['total']}",
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            // _detailRow("Source:", data['source'] ?? "N/A"),
            _detailRow("Source:", data['source']?.toString() ?? "N/A"),
            _detailRow("Entry Medium:", "Manual"),

            const Divider(height: 20),

            Text(
              "Last Updated: ${data['updatedat'] ?? ''}",
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // ─── HELPERS ──────────────────────────────────────────────────────────────

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
    );
  }

  Widget _detailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value ?? "",
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // ─── STATUS BOTTOM SHEET ──────────────────────────────────────────────────

  void _showStatusBottomSheet(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    final List<String> allStatus = ["Open", "Declined", "Fulfilled"];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final filtered = allStatus
                .where(
                  (e) => e.toLowerCase().contains(
                        searchController.text.toLowerCase(),
                      ),
                )
                .toList();

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HANDLE
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const Text(
                    "Select Status",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// SEARCH
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search status...",
                      prefixIcon: const Icon(Icons.search),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 8),

                  /// STATUS LIST
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final status = filtered[index];
                      return Obx(
                        () => ListTile(
                          title: Text(status),
                          trailing:
                              controller.selectedStatus.value == status
                                  ? const Icon(Icons.check,
                                      color: Colors.orange)
                                  : null,
                          onTap: () {
                            controller.selectedStatus.value = status;
                            controller.updateStatusApi();
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _iconBox(
    IconData icon, {
    required String tooltip,
    VoidCallback? onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: Colors.black),
        ),
      ),
    );
  }

  bool isToday(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) return false;
    try {
      final d = DateTime.parse(createdAt);
      final now = DateTime.now();
      return d.year == now.year &&
          d.month == now.month &&
          d.day == now.day;
    } catch (_) {
      return false;
    }
  }
}