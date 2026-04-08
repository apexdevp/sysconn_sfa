import 'package:flutter/material.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';

class SearchTextfield extends StatefulWidget {
  final void Function(String?) onChanged;
  final Function() closeFunction;
  const SearchTextfield({super.key,required this.onChanged,required this.closeFunction});

  @override
  State<SearchTextfield> createState() => _SearchTextfieldState();
}

class _SearchTextfieldState extends State<SearchTextfield> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search',
          labelText: 'Search',
          hintStyle: kTxtStl13N,
          labelStyle: kTxtStl13N,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: kIconColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: kAppColor,),
          ),
          suffix: SizedBox(
            // color: kAppColor,
            height: 16,
            width: 30,
            child: IconButton(
              padding: EdgeInsets.all(0),
              iconSize: 14,
              onPressed: (){
                if(mounted){
                  setState(() {
                    searchController.text = '';
                  });
                  widget.closeFunction();
                }
              },
              icon: Icon(Icons.close_rounded,color: Colors.red,),
            ),
          ),
          contentPadding: EdgeInsets.all(8),
          suffixIcon: Icon(Icons.search,size: 19,color: kIconColor,),
        ),
        style: kTxtStl13N,
        onChanged: widget.onChanged,
      ),
    );
  }
}