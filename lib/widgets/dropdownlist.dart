import 'package:flutter/material.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';

class DropdownCustomList<T> extends StatelessWidget {
  final String title;
  final bool isEnabled;
  final List<DropdownMenuItem<T>>? items;
  final String? hint;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final bool isCompulsory;

  const DropdownCustomList({
    super.key,
    required this.title,
    required this.items,
    this.hint,
    this.value,
    required this.onChanged,
    this.isEnabled = true,
    this.isCompulsory = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: kTxtStl13B),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.0),
              border: Border.all(width: 0.8),
              color: Colors.grey.shade50,
            ),
            child: DropdownButton(
              isExpanded: true,
              underline: Container(),
              items: items,
              hint: Text(hint == null ? '' : hint!, style: kTxtStl13N),
              onChanged: onChanged,
              // icon: isCompulsory?const Icon(FontAwesomeIcons.asterisk,color: Colors.red,size: 8,):null,
              // isDense: true,
              value: value,
              style: isEnabled ? kTxtStl13N : kTxtStl13GreyN,
              dropdownColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
