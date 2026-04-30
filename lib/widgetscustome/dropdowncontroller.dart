import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';

// ignore: must_be_immutable
class DropdownCustomList<T> extends StatefulWidget {
  final String title;
  final List<DropdownMenuItem<T>> items;
  final Rx<T?> selectedValue;
  String? value;
  final String? hint;
  final bool isEnabled;
  final bool isCompulsory;
  final ValueChanged<T?>? onChanged;
  final String Function(T?)? displayLabel;
  final String? Function(T?)? validator;
  final Future<List<DropdownMenuItem<T>>> Function(String query)? onSearchApi;
  final VoidCallback? onClear;

  DropdownCustomList({
    super.key,
    required this.title,
    required this.items,
    required this.selectedValue,
    this.hint,
    this.isEnabled = true,
    this.isCompulsory = false,
    this.onChanged,
    this.displayLabel,
    this.validator,
    this.onSearchApi,
    this.onClear,
  });

  @override
  State<DropdownCustomList<T>> createState() => _DropdownCustomListState<T>();
}

class _DropdownCustomListState<T> extends State<DropdownCustomList<T>> {
  final TextEditingController searchController = TextEditingController();
  OverlayEntry? _dropdownOverlayEntry;
  String? errorText;
  Timer? _debounce;
  final isLoading = false.obs;
  final LayerLink _layerLink = LayerLink(); // ✅ LayerLink instead of GlobalKey
  late final RxList<DropdownMenuItem<T>> filteredItems;

  @override
  void initState() {
    super.initState();
    filteredItems = <DropdownMenuItem<T>>[].obs;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _removeDropdown();
    searchController.dispose();
    super.dispose();
  }

  void _removeDropdown() {
    if (_dropdownOverlayEntry != null) {
      _dropdownOverlayEntry!.remove();
      _dropdownOverlayEntry = null;
    }
  }

  void _openDropdown(BuildContext context) {
    final overlay = Overlay.of(context, rootOverlay: true);
    final renderBox = context.findRenderObject() as RenderBox;
    final fieldSize = renderBox.size;
    FocusScope.of(context).unfocus();

    filteredItems.value = widget.items;
    searchController.clear();

    _dropdownOverlayEntry = OverlayEntry(
      builder: (_) {
        return Stack(
          children: [
            // Close on outside tap
            Positioned.fill(
              child: GestureDetector(
                onTap: _removeDropdown,
                behavior: HitTestBehavior.translucent,
              ),
            ),
            // ✅ Follows the field automatically — no coordinate math needed
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              // offset: Offset(0, fieldSize.height),
              offset: Offset(0, fieldSize.height - 20), // tweak: -2, -4, etc.//pratiksha p add 30-04-2026

              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: fieldSize.width,
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Search field
                        Padding(
                          // padding: const EdgeInsets.all(4),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          child: TextField(
                            controller: searchController,
                            autofocus: true,
                            style: const TextStyle(fontSize: 13),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search, size: 18),
                              hintText: 'Search...',
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (query) {
                              if (widget.onSearchApi != null) {
                                if (_debounce?.isActive ?? false)
                                  _debounce!.cancel();
                                _debounce = Timer(
                                  const Duration(milliseconds: 400),
                                  () async {
                                    if (!mounted) return;
                                    isLoading.value = true;
                                    try {
                                      final result =
                                          await widget.onSearchApi!(query);
                                      if (!mounted) return;
                                      filteredItems.value = result;
                                    } catch (e) {
                                      filteredItems.value = [];
                                    }
                                    isLoading.value = false;
                                  },
                                );
                              } else {
                                filteredItems.value =
                                    widget.items.where((item) {
                                  final label =
                                      (item.child as Text).data ?? '';
                                  return label.toLowerCase().contains(
                                    query.toLowerCase(),
                                  );
                                }).toList();
                              }
                            },
                          ),
                        ),
                        const Divider(height: 0),
                        // Reactive list
                        Obx(() {
                          if (filteredItems.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "No items found",
                                style: TextStyle(fontSize: 12),
                              ),
                            );
                          }
                          return Flexible(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredItems.length,
                              itemBuilder: (_, i) {
                                final item = filteredItems[i];
                                return ListTile(
                                  dense: true,
                                  title: DefaultTextStyle(
                                    style: kTxtStl12N,
                                    child: item.child,
                                  ),
                                  onTap: () {
                                    widget.selectedValue.value = item.value;
                                    widget.onChanged?.call(item.value);
                                    if (widget.validator != null) {
                                      setState(() {
                                        errorText =
                                            widget.validator!(item.value);
                                      });
                                    }
                                    _removeDropdown();
                                  },
                                );
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(_dropdownOverlayEntry!);
  }

  String _getSelectedLabel(T? value) {
    if (value == null) return '';
    if (widget.displayLabel != null) {
      return widget.displayLabel!(value);
    }
    final matchFiltered = filteredItems.firstWhereOrNull(
      (item) => item.value == value,
    );
    if (matchFiltered != null) {
      return (matchFiltered.child as Text?)?.data ?? '';
    }
    final matchItems = widget.items.firstWhereOrNull(
      (item) => item.value == value,
    );
    if (matchItems != null) {
      return (matchItems.child as Text?)?.data ?? '';
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: widget.title,
              style: kTxtStl13N,
              children: widget.isCompulsory
                  ? [
                      TextSpan(
                        text: ' *',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]
                  : [],
            ),
          ),
          const SizedBox(height: 8),

          // ✅ CompositedTransformTarget wraps the field
          CompositedTransformTarget(
            link: _layerLink,
            child: Obx(() {
              final label = _getSelectedLabel(widget.selectedValue.value);
              return GestureDetector(
                onTap: widget.isEnabled ? () => _openDropdown(context) : null,
                child: InputDecorator(
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: const TextStyle(
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    ),
                    hintMaxLines: 1,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 11,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    enabled: widget.isEnabled,
                    errorText: errorText,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          label.isEmpty ? (widget.hint ?? '') : label,
                          style: TextStyle(
                            fontSize: 12,
                            color: widget.isEnabled
                                ? Colors.black
                                : Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
