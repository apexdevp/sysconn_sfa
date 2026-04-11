import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';

//pratiksha p add
class PopupMenuItemModel {
  final String value;
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  PopupMenuItemModel({
    required this.value,
    required this.icon,
    required this.title,
    required this.onTap,
  });
}

class CustomPopupMenuButton extends StatelessWidget {
  final List<PopupMenuItemModel> menuItems;
  final Size screenSize;
  final String headertitle;
  final Color? color;
  final TextStyle? style;

  const CustomPopupMenuButton({
    super.key,
    required this.menuItems,
    required this.screenSize,
    this.headertitle='Action',
    this.style,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        final RenderBox overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;

        showMenu<String>(
          color: Colors.white,
          context: context,
          position: RelativeRect.fromLTRB(
            details.globalPosition.dx,
            details.globalPosition.dy,
            overlay.size.width - details.globalPosition.dx,
            overlay.size.height - details.globalPosition.dy,
          ),
          items: menuItems.map((item) {
            return PopupMenuItem<String>(
              height: 15,
              value: item.value,
              onTap: item.onTap,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Icon(
                      item.icon,
                      size: 14,
                      color: Colors.black,
                    ), //pooja // 19-09-2025//size: 13
                    SizedBox(width: screenSize.width * 0.01),
                    Text(
                      item.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight
                            .w600, //pooja // 19-09-2025//w400,fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ).then((selectedValue) {
          if (selectedValue != null) {
            if (kDebugMode) {}
          }
        });
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color??Colors.grey.shade300, //pratiksha p 13-09-2025
          borderRadius: BorderRadius.circular(5), //pratiksha p 13-09-2025
          // gradient: buttonGradient,
        ),
    //     child:
    //      Padding(
    //       padding: headertitle != 'Action'
    // ? const EdgeInsets.all(6.0)
    // :  const EdgeInsets.only(left: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(headertitle != 'Action')
              SizedBox(width: 5,),
              Text(
                headertitle,
                style:style?? kTxtStl12B,
              ),
            if(headertitle != 'Action')
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Icon(Icons.arrow_drop_down,color: Colors.white,),
            )
            ],
          // ),
        ), //pratiksha p 13-09-2025// //kTxtStl10WB
      ),
    );
  }
}
