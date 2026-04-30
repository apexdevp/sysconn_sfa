import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';

//pratiksha p add
class AutoCompleteFieldView<T extends Object> extends StatelessWidget {
  final bool isCompulsory;
  final bool enabled;
  final String title;
  final AutocompleteOptionsBuilder<T> optionsBuilder;
  // final String Function(dynamic) displayStringForOption;
  final AutocompleteOptionToString<T> displayStringForOption;
  final Function() closeControllerFun;
  final String controllerValue;
  // final Function(String)? onSelectedFun;
  final AutocompleteOnSelected<T> onSelected;
  final Function(String)? onTextChanged;
  final double? fontSize; //pratiksha p 18-02-2026 add
  final bool? countertext;

  const AutoCompleteFieldView({
    super.key,
    this.isCompulsory = false,
    this.enabled = true,
    required this.title,
    required this.optionsBuilder,
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    required this.controllerValue,
    required this.closeControllerFun,
    required this.onSelected,
    this.onTextChanged,
    this.fontSize,
    this.countertext = false, //pratiksha p 18-02-2026 add
  }); // required this.optionList

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.all(4.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //pratiksha p 18-02-2026 add
            RichText(
              text: TextSpan(
                text: title,
                style: kTxtStl12N,
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
                    : [],
              ),
            ),
            const SizedBox(height: 8),
            Autocomplete<T>(
              // optionsBuilder: (TextEditingValue value){
              //   return optionList.where((String optionSelected) => optionSelected.toLowerCase().contains(value.text.toLowerCase())).toList();
              // },
              optionsBuilder: optionsBuilder,
              // displayStringForOption: (String displayStringForOption){
              //   return displayStringForOption;
              // },
              displayStringForOption: displayStringForOption,
              fieldViewBuilder:
                  (
                    context,
                    TextEditingController cntrl,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted,
                  ) {
                    // if(controllerValue != ''){
                    // cntrl.text = controllerValue;
                    // //   debugPrint('01 cntrl.text ${cntrl.text}');
                    // // }
                    // Utility().cursorPosition(cntrl, cntrl.text);
                    //Manisha C 31-03-2026 added
                    if (cntrl.text != controllerValue) {
                      cntrl.text = controllerValue;

                      cntrl.selection = TextSelection.fromPosition(
                        TextPosition(offset: cntrl.text.length),
                      );
                    }
                    return TextField(
                      controller: cntrl,
                      enabled: enabled,
                      focusNode: focusNode,
                      style: enabled ? kTxtStl12N : kTxtStl12GreyN,
                      decoration: InputDecoration(
                        hintText: title,
                        hintStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            Utility.borderCornerRadious,
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: kcGray),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        isDense: true,
                        counterText: countertext! ? "" : null,
                        suffixIcon: focusNode.hasFocus
                            ? IconButton(
                                onPressed: closeControllerFun,
                                icon: const Icon(Icons.close, size: 14),
                              )
                            : null,
                      ),
                      onChanged: onTextChanged,
                    );
                  },
              onSelected: onSelected,
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 160), //200
                      // height: 200,
                      child: Container(
                        color: Colors.white,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: options.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final T option = options.elementAt(index);
                            return InkWell(
                              child: Builder(
                                builder: (context) {
                                  final bool highlight =
                                      AutocompleteHighlightedOption.of(
                                        context,
                                      ) ==
                                      index;
                                  if (highlight) {
                                    SchedulerBinding.instance
                                        .addPostFrameCallback((timeStamp) {
                                          Scrollable.ensureVisible(
                                            context,
                                            alignment: 0.5,
                                          );
                                        });
                                  }
                                  return Container(
                                    color: highlight
                                        ? Theme.of(context).focusColor
                                        : null,
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      displayStringForOption(option),
                                      style: kTxtStl12N,
                                    ),
                                  );
                                },
                              ),
                              onTap: () {
                                onSelected(option);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
