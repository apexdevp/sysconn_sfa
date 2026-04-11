import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';

//pratiksha p  add
class CustomTextFormFieldView extends StatelessWidget {
  final bool isCompulsory;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final String title;
  final String? optionaltitle;
  final String? hinttext;
  final String? error;
  final Function(String)? onChanged;
  final int? maxLength;
  final Function()? onTap;
  final int? maxLines;
  final bool countertext; //pratiksha p 06-05-2025 add
  final double? fontSize;
  final String? Function(String?)? validator; //Sakshi
  final Widget? suffixIcon;
  final bool readOnly; //Shweta 09-03-26
  final Color? fillColor; //Shweta 09-03-26

  const CustomTextFormFieldView({
    super.key,
    this.isCompulsory = false,
    this.enabled = true,
    // this.keyboardType = TextInputType.url,
    this.keyboardType,
    required this.controller,
    required this.title,
    this.optionaltitle,
    this.hinttext,
    this.error,
    this.onChanged,
    this.maxLength,
    this.onTap,
    this.maxLines,
    this.fontSize,
    // this.inputFormatters,
    this.countertext = false, //pratiksha p 06-05-2025 add
    this.validator,
    this.suffixIcon,
    this.readOnly = false, //shweta 09-03-26
    this.fillColor, //shweta 09-03-26
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.all(4.0),
        // height:maxLines == null? 50: maxLines! > 1 ? null: 50,
        //pratiksha p 18-02-2026 add
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: title,
                style: kTxtStl13N, //kTxtStl12N, // Manoj 25-02-2026
                children: isCompulsory
                    ? [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]
                    : optionaltitle != null
                    ? [
                        TextSpan(
                          text: optionaltitle,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]
                    : [],
              ),
            ),
            const SizedBox(height: 8), // 4 Manoj 25-02-2026
            TextFormField(
              enabled: enabled,
              readOnly: readOnly, //shweta 09-03-26
              keyboardType: keyboardType,
              autofocus: false,
              controller: controller,
              style: enabled ? kTxtStl12N : kTxtStl12GreyN,
              decoration: InputDecoration(
                hintText: hinttext == ''
                    ? title.replaceAll('*', '')
                    : hinttext, //title.replaceAll('*', ''),

                // hintText: title,
                // labelText: title,
                // labelStyle: enabled
                //     ? controller.text == ''
                //           ? kTxtStl12N
                //           : kTxtStl14N
                //     : kTxtStl12GreyN,
                // hintStyle: enabled
                //     ? controller.text == ''
                //           ? kTxtStl11GreyN
                //           : kTxtStl13GreyN
                //     : kTxtStl12GreyN,
                // hintStyle: TextStyle(
                //   fontSize: 12, //13, // Manoj 25-02-2026
                //   fontWeight: FontWeight.normal,
                //   color: Colors.black, //Colors.grey, // Manoj 25-02-2026
                // ),


                hintStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis, //  Akshay add due to height goes bigger when text is big
                ),
                hintMaxLines: 1,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ), // kcGray // Manoj 25-02-2026
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: kAppIconColor),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ), //pratiksha p 19-02-2026 add
                isDense: true, //pratiksha p 19-02-2026 add
                errorText: error,
                errorStyle: kTxtStl10N,
                // suffixIcon: isCompulsory
                //     ? const Icon(
                //         FontAwesomeIcons.asterisk,
                //         color: Colors.red,
                //         size: 9,
                //       )
                //     : null,
                // counterText: countertext
                //     ? ' '
                //     : null, //pratiksha p 06-05-2025 add to reserve height at time of maxlength
                counterText: countertext
                    ? ""
                    : null, // Manoj 22-02-2026 Add to for adjust maxlengh and hide counter text properly
                suffixIcon: suffixIcon,
                filled: fillColor != null, //shweta 09-03-26
                fillColor: fillColor, //shweta 09-03-26
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: validator,
              maxLength: maxLength,
              onChanged: onChanged,
              onTap: onTap,
              maxLines: maxLines,
              inputFormatters: keyboardType == null
                  ? null
                  : <TextInputFormatter>[
                      keyboardType == TextInputType.emailAddress
                          ? FilteringTextInputFormatter.allow(
                              RegExp('[a-zA-Z0-9.@]'),
                            )
                          : keyboardType == TextInputType.number
                          ? FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                          // :keyboardType == const TextInputType.numberWithOptions(decimal: true,signed: true)?
                          // FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+.?[0-9]*'))
                          : keyboardType == TextInputType.name
                          ? FilteringTextInputFormatter.allow(
                              RegExp('[a-zA-Z ]'),
                            )
                          : keyboardType == TextInputType.url
                          ? FilteringTextInputFormatter.allow(
                              RegExp('[-a-zA-Z0-9@:%._\\+~#?&//=]'),
                            )
                          : keyboardType == TextInputType.text
                          ? FilteringTextInputFormatter.allow(
                              RegExp('[a-zA-Z0-9 ]'),
                            ) // text
                          : FilteringTextInputFormatter.allow(
                              RegExp('[-a-zA-Z0-9@:%._\\+~#?&//=]'),
                            ),
                    ],
            ),
          ],
        ),
      ),
    );
  }
}
