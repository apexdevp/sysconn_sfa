import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sysconn_sfa/Utility/image_list.dart';
import 'package:sysconn_sfa/Utility/utility.dart';

// class SfaCustomAppbar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final PreferredSizeWidget? bottom;
//   const SfaCustomAppbar({super.key, required this.title, this.bottom});

//   // @override
//   // Size get preferredSize => const Size.fromHeight(kToolbarHeight);
//  @override
//   Size get preferredSize =>
//       Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       bottom: bottom,
//       flexibleSpace: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(ImageList.appbarImage),
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//       title: Text(title),
//       actions: [
//         GestureDetector(
//           onTap: () {},
//           child: const Badge(
//             label: Text('1', style: TextStyle(color: Colors.white)),
//             child: Icon(Icons.notifications_outlined, color: Colors.white),
//           ),
//         ),
//         const SizedBox(width: 10),
//         CircleAvatar(
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.black,
//           child: ClipOval(
//             child: Utility.companyLogo == ''
//                 ? const Icon(Icons.image_not_supported_outlined, size: 20)
//                 : Image.file(
//                     File(Utility.companyLogo),
//                     width: 30,
//                     height: 20,
//                     // fit: BoxFit.cover,
//                   ),
//           ),
//         ),
//         const SizedBox(width: 10),
//       ],
//     );
//   }
// }


class SfaCustomAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final PreferredSizeWidget? bottom;

  // ✅ NEW
  final List<Widget>? actions;
  final bool showDefaultActions;

  const SfaCustomAppbar({
    super.key,
    required this.title,
    this.bottom,
    this.actions,
    this.showDefaultActions = true, // default behavior same as now
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: bottom,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageList.appbarImage),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(title),

      // ✅ LOGIC HERE
      actions: actions ??
          (showDefaultActions
              ? [
                  GestureDetector(
                    onTap: () {},
                    child: const Badge(
                      label: Text('1',
                          style: TextStyle(color: Colors.white)),
                      child: Icon(Icons.notifications_outlined,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    child: ClipOval(
                      child: Utility.companyLogo == ''
                          ? const Icon(
                              Icons.image_not_supported_outlined,
                              size: 20)
                          : Image.file(
                              File(Utility.companyLogo),
                              width: 30,
                              height: 20,
                            ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ]
              : []),
    );
  }
}