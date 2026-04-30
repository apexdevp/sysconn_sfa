import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/api/entity/company/party_notes_response_entity.dart';
import 'package:sysconn_sfa/api/entity/taskboard/audit_log_model.dart';
import 'package:sysconn_sfa/screens/bizOpportunities/controller/opportunities_deals_activity_controller.dart';
import 'package:sysconn_sfa/screens/bizOpportunities/controller/opportunities_deals_notes_controller.dart';
import 'package:sysconn_sfa/screens/bizOpportunities/controller/opportunities_deals_view_controller.dart';
import 'package:sysconn_sfa/screens/bizOpportunities/view/activity_add_view.dart';
import 'package:sysconn_sfa/screens/bizOpportunities/view/notes_add_view.dart';

class OpportunitiesDealsActivityView extends StatelessWidget {
  const OpportunitiesDealsActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewController = Get.find<OpportunitiesDealsViewController>();
    final activityController = Get.put(OpportunitiesActivityController());
    final notesController = Get.put(OpportunitiesDealsNotesController());

    /// Initialize after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final entity = viewController.selectedOpportunity.value;
      activityController.initialize(entity);
      notesController.initialize(entity);
      activityController.loadActivitiesFromApi();
    });

    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ── TAB HEADER ──────────────────────────────────────────
            Obx(
              () => Row(
                children: [
                  _tabButton('Activities', 0, activityController,
                      notesController, viewController),
                  const SizedBox(width: 8),
                  _tabButton('Notes', 1, activityController,
                      notesController, viewController),
                  const SizedBox(width: 8),
                  _tabButton('Audit Logs', 2, activityController,
                      notesController, viewController),

                  const Spacer(),

                  /// ADD BUTTON (hidden on Audit Logs tab)
                  if (activityController.selectedActivityTab.value != 2)
                    GestureDetector(
                      onTap: () async {
                        if (activityController.selectedActivityTab.value == 0) {
                          /// Navigate to activity add screen
                          activityController.clearForm();
                          final result = await Get.to(
                            () => ActivityAddScreen(),
                          );
                          if (result == true) {
                            activityController.loadActivitiesFromApi();
                          }
                        } else {
                          /// Navigate to notes add screen
                          notesController.clearAllFields();
                          final result = await Get.to(
                            () => NotesAddScreen(),
                          );
                          if (result == true) {
                            notesController.fetchNotesCategory();
                          }
                        }
                      },
                      child: const CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.black,
                        child: Icon(Icons.add, size: 16, color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),

            const Divider(height: 16),

            /// ── TAB CONTENT ─────────────────────────────────────────
            Obx(() {
              final tab = activityController.selectedActivityTab.value;
              if (tab == 0) return _buildActivitiesTab(activityController);
              if (tab == 1) return _buildNotesTab(notesController);
              return _buildAuditLogsTab(activityController);
            }),
          ],
        ),
      ),
    );
  }

  // ─── TAB BUTTON ───────────────────────────────────────────────────────────

  Widget _tabButton(
    String label,
    int index,
    OpportunitiesActivityController activityController,
    OpportunitiesDealsNotesController notesController,
    OpportunitiesDealsViewController viewController,
  ) {
    return Obx(() {
      final isActive = activityController.selectedActivityTab.value == index;

      return GestureDetector(
        onTap: () {
          activityController.selectedActivityTab.value = index;
          final entity = viewController.selectedOpportunity.value;

          if (index == 0) {
            activityController.initialize(entity);
            activityController.loadActivitiesFromApi();
          } else if (index == 1) {
            notesController.initialize(entity);
            notesController.fetchNotesCategory();
          } else {
            activityController.getAuditLogs(
              model: 'Business_Opportunity',
              modelId: entity.businessOpportunityId ?? '',
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? Colors.black : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : Colors.black54,
            ),
          ),
        ),
      );
    });
  }

  // ─── ACTIVITIES TAB ───────────────────────────────────────────────────────

  Widget _buildActivitiesTab(OpportunitiesActivityController controller) {
    return Obx(() {
      final activities = controller.activityList;

      if (activities.isEmpty) {
        return const _EmptyState(message: 'No Activities Found');
      }

      final grouped = _groupByDate(
        activities.map((e) => e['createdAt']?.toString() ?? '').toList(),
        activities,
      );
      final dates = grouped.keys.toList()
        ..sort((a, b) => _parseDate(b).compareTo(_parseDate(a)));

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: dates.map((date) {
          final items = grouped[date]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _dateHeader(_formatDateHeader(date)),
              const SizedBox(height: 8),
              ...items.asMap().entries.map((entry) {
                final item = entry.value;
                final isLast = entry.key == items.length - 1;
                return _timelineItem(
                  isLast: isLast,
                  child: _activityCard(item, controller),
                );
              }),
            ],
          );
        }).toList(),
      );
    });
  }

  Widget _activityCard(
      Map<String, dynamic> item, OpportunitiesActivityController c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Sales Task | ${item['event']}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: c
                      .getStatusColor(item['status'])
                      .withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  c.getStatusText(item['status']),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: c.getStatusColor(item['status']),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(item['title'] ?? '',
              style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            'Todo: ${item['todoDate']}  |  Due: ${item['dueDate']}',
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
          Text(
            'Assigned: ${item['assigned']}',
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // ─── NOTES TAB ────────────────────────────────────────────────────────────

  Widget _buildNotesTab(OpportunitiesDealsNotesController controller) {
    return Obx(() {
      final notes = controller.notesListData;

      if (notes.isEmpty) {
        return const _EmptyState(message: 'No Notes Found');
      }

      final grouped = _groupNotesByDate(notes);
      final dates = grouped.keys.toList()
        ..sort((a, b) =>
            (_tryParseDateTime(b)).compareTo(_tryParseDateTime(a)));

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: dates.map((date) {
          final noteList = grouped[date]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _dateHeader(_formatDateHeader(date)),
              const SizedBox(height: 8),
              ...noteList.asMap().entries.map((entry) {
                final note = entry.value;
                final isLast = entry.key == noteList.length - 1;
                return _timelineItem(
                  isLast: isLast,
                  child: _noteCard(note),
                );
              }),
            ],
          );
        }).toList(),
      );
    });
  }

  Widget _noteCard(PartyNotesDetailsEntity note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  note.categoryName ?? '',
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ),
              Text(
                note.createdat?.split(' ').last ?? '',
                style:
                    const TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(note.title ?? '',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 4),
          Text(note.description ?? '',
              style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // ─── AUDIT LOGS TAB ───────────────────────────────────────────────────────

  Widget _buildAuditLogsTab(OpportunitiesActivityController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      final logs = controller.auditLogsList;

      if (logs.isEmpty) {
        return const _EmptyState(message: 'No Audit Logs Found');
      }

      final grouped = _groupLogsByDate(logs);
      final dates = grouped.keys.toList()
        ..sort((a, b) => _parseDate(b).compareTo(_parseDate(a)));

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: dates.map((date) {
          final logList = grouped[date]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _dateHeader(_formatDateHeader(date)),
              const SizedBox(height: 8),
              ...logList.asMap().entries.map((entry) {
                final log = entry.value;
                final isLast = entry.key == logList.length - 1;
                return _timelineItem(
                  isLast: isLast,
                  child: _auditCard(log),
                );
              }),
            ],
          );
        }).toList(),
      );
    });
  }

  Widget _auditCard(Log log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _activityColor(log.activity).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  log.activity,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: _activityColor(log.activity),
                  ),
                ),
              ),
              Text(log.createdTime,
                  style: const TextStyle(
                      fontSize: 11, color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 6),
          Text(log.description,
              style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // ─── SHARED TIMELINE HELPERS ──────────────────────────────────────────────

  Widget _timelineItem({required bool isLast, required Widget child}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: Colors.grey.shade300),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _dateHeader(String label) {
    return Row(
      children: [
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Divider(color: Colors.grey.shade300)),
      ],
    );
  }

  // ─── DATE HELPERS ─────────────────────────────────────────────────────────

  DateTime _parseDate(String raw) {
    try {
      final d = raw.split(' ')[0].trim().split('-');
      if (d.length == 3) {
        return DateTime(int.parse(d[2]), int.parse(d[1]), int.parse(d[0]));
      }
    } catch (_) {}
    return DateTime.now();
  }

  DateTime _tryParseDateTime(String raw) {
    return DateTime.tryParse(raw.split(' ')[0]) ?? DateTime.now();
  }

  String _formatDateHeader(String raw) {
    try {
      return DateFormat('dd MMM yyyy').format(_parseDate(raw));
    } catch (_) {
      return raw;
    }
  }

  Map<String, List<Map<String, dynamic>>> _groupByDate(
      List<String> dates, List<Map<String, dynamic>> items) {
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (int i = 0; i < items.length; i++) {
      final key = dates[i].split(' ')[0];
      grouped.putIfAbsent(key, () => []).add(items[i]);
    }
    return grouped;
  }

  Map<String, List<PartyNotesDetailsEntity>> _groupNotesByDate(
      List<PartyNotesDetailsEntity> notes) {
    final grouped = <String, List<PartyNotesDetailsEntity>>{};
    for (final note in notes) {
      final key = note.createdat?.split(' ').first ?? '';
      grouped.putIfAbsent(key, () => []).add(note);
    }
    return grouped;
  }

  Map<String, List<Log>> _groupLogsByDate(List<Log> logs) {
    final grouped = <String, List<Log>>{};
    for (final log in logs) {
      final key = log.createdDate.split(' ')[0].trim();
      grouped.putIfAbsent(key, () => []).add(log);
    }
    return grouped;
  }

  Color _activityColor(String activity) {
    final a = activity.toLowerCase();
    if (a.contains('created')) return Colors.green;
    if (a.contains('updated') || a.contains('status')) return Colors.blue;
    if (a.contains('deleted') || a.contains('cancel')) return Colors.red;
    if (a.contains('hold')) return Colors.orange;
    if (a.contains('completed')) return Colors.teal;
    return Colors.grey;
  }
}

// ─── EMPTY STATE ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(message,
            style: const TextStyle(color: Colors.black45, fontSize: 13)),
      ),
    );
  }
}