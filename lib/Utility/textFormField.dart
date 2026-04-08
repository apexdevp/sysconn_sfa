import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart'; // Added for Get.theme etc.

class CustomTextFormFieldView extends StatelessWidget {
  final bool isCompulsory;
  final bool enabled;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String title;
  final String? error;
  final Function(String)? onChanged;
  final int? maxLength;
  final bool countertext;
  final Function()? onTap;
  final int? maxLines;

  const CustomTextFormFieldView({
    super.key,
    this.isCompulsory = false,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    required this.controller,
    required this.title,
    this.error,
    this.onChanged,
    this.maxLength,
    this.onTap,
    this.maxLines,
    this.countertext = false,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: TextFormField(
        enabled: enabled,
        keyboardType: keyboardType,
        controller: controller,
        autofocus: false,
        style: enabled ? kTxtStl13N : kTxtStl13GreyN,
        decoration: InputDecoration(
          hintText: title,
          labelText: title,
          labelStyle: kTxtStl13GreyN,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Utility.borderCornerRadious),
          ),
          contentPadding: const EdgeInsets.fromLTRB(14.0, 14.0, 0, 0),
          errorText: error,
          suffixIcon: isCompulsory
              ? const Icon(
                  FontAwesomeIcons.asterisk,
                  color: Colors.red,
                  size: 9,
                )
              : null,
          counterText: countertext ? "" : null,
        ),
        textCapitalization: TextCapitalization.sentences,
        maxLength: maxLength,
        onChanged: onChanged,
        onTap: onTap,
        maxLines: maxLines,
      ),
    );
  }
}
