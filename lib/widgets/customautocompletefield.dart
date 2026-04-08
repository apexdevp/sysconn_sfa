import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';

class CustomAutoCompleteFieldView<T extends Object> extends StatelessWidget {
  final bool isCompulsory;
  final bool enabled;
  // final List<String> optionList;
  final AutocompleteOptionsBuilder<T> optionsBuilder;
  final AutocompleteOptionToString<T> displayStringForOption;
  final String title;
  final Function() closeControllerFun;
  final String controllerValue;
  // final Function(String)? onSelectedFun;
  final AutocompleteOnSelected<T>? onSelected;
  final Function(String)? onTextChanged;

  // const CustomAutoCompleteFieldView({super.key, this.isCompulsory = false,this.enabled = true,required this.optionList,required this.title,required this.controllerValue,required this.closeControllerFun,required this.onSelectedFun});
  const CustomAutoCompleteFieldView({
    super.key,
    this.isCompulsory = false,
    this.enabled = true,
    required this.optionsBuilder,
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    required this.title,
    required this.controllerValue,
    required this.closeControllerFun,
    required this.onSelected,
    this.onTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Autocomplete<T>(
        optionsBuilder: optionsBuilder,
        // (TextEditingValue value){
        //   return optionList.where((String optionSelected) => optionSelected.toLowerCase().contains(value.text.toLowerCase())).toList();
        // },
        displayStringForOption: displayStringForOption,
        // (String displayStringForOption){
        //   return displayStringForOption;
        // },
        fieldViewBuilder:
            (
              context,
              TextEditingController cntrl,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted,
            ) {
              // if(controllerValue != ''){
              cntrl.text = controllerValue;
              //   print('01 cntrl.text ${cntrl.text}');
              // }
              const Utility().cursorPosition(cntrl, cntrl.text);
              return TextField(
                controller: cntrl,
                onChanged: onTextChanged,
                enabled: enabled,
                focusNode: focusNode,
                decoration: InputDecoration(
                  labelText: title,
                  hintText: title,
                  hintStyle: kTxtStl13N,
                  labelStyle: kTxtStl13N,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      Utility.borderCornerRadious,
                    ),
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(14, 14, 0, 0),
                  fillColor: enabled
                      ? Colors.grey.shade50
                      : const Color.fromARGB(255, 243, 242, 242),
                  filled: true,
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      focusNode.hasFocus
                          ? IconButton(
                              onPressed: closeControllerFun,
                              icon: const Icon(Icons.close, size: 14),
                            )
                          : Container(),
                      isCompulsory
                          ? const Icon(
                              FontAwesomeIcons.asterisk,
                              color: Colors.red,
                              size: 9,
                            )
                          : Container(),
                    ],
                  ),
                ),
                style: enabled ? kTxtStl13N : kTxtStl13GreyN,
              );
            },

        onSelected: onSelected,
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4.0,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
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
                                AutocompleteHighlightedOption.of(context) ==
                                index;
                            if (highlight) {
                              SchedulerBinding.instance.addPostFrameCallback((
                                timeStamp,
                              ) {
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
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                displayStringForOption!(option),
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
    );
  }
}
