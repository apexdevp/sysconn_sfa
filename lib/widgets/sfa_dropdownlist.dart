import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';

class DropdownList<T> extends StatelessWidget {
  final String title;
  final bool isEnabled;
  final List<DropdownMenuItem<T>>? items;
  final String? hint;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final bool isCompulsory;
  // final bool isAllValueAllow;

  const DropdownList({
    super.key,
    required this.title,
    required this.items,
    this.hint,
    this.value,
    required this.onChanged,
    this.isEnabled = true,
    this.isCompulsory = false,
    // this.isAllValueAllow = false
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AbsorbPointer(
        absorbing: !isEnabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title, style: kTxtStl14B),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.0),
                border: Border.all(width: 0.8, color: Colors.grey),
                color: Colors.grey.shade50,
              ),
              child: DropdownButton(
                isExpanded: true,
                underline: Container(),
                items: items,
                icon: Row(
                  children: [
                    isCompulsory
                        ? Icon(
                            CupertinoIcons.asterisk_circle,
                            color: Colors.red,
                            size: 9,
                          )
                        : Container(),
                    Icon(Icons.arrow_drop_down_outlined),
                  ],
                ),
                hint: Text(
                  hint == null ? '' : hint!,
                  style: isEnabled ? kTxtStl13N : kTxtStl13GreyN,
                ),
                onChanged: onChanged,

                value: value,
                style: isEnabled ? kTxtStl13N : kTxtStl13GreyN,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
