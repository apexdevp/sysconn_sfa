import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/image_list.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/buddy/buddy_view.dart';
import 'package:sysconn_sfa/screens/buddy/sales/sales_report.dart';
import 'package:sysconn_sfa/screens/expenses/views/expenses_menuview.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Card menuCard(Size size, String imageName, String menu, Function function) {
    Size size = MediaQuery.of(context).size;
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(
            color: kGreyColor,
            width: 2,
          )),
      shadowColor: kAppColor,
      elevation: 5,
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imageName,
              color: kAppIconColor,
              height: size.height <= 640? size.height * 0.035: size.height * 0.055,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(menu,style: kTxtStl14B,textAlign: TextAlign.center,),
            ),
          ],
        ),
        onTap: () {
          // if (Utility.companyId == '') {
          //   scaffoldMessageBar( 'Please select company first!!');
          // }
          // else{
            function();
          // }   
        },
      ),
    );
   }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Container(
                width: size.width,
                height: size.height * 0.12,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(238, 242, 251, 1),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(MediaQuery.of(context).size.width, 100.0)),
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.12,
            ),
            Expanded(
              child: Row(
              children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: menuCard(size, 'assets/images/Sales.png', 'Sales Management', () {
                    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => 
                    // SalesBillsDashDetails(salessummarytype: 'Party',type: 'Sales',dashboardNavTo: 'Report',id: '',)));
                  }),
                )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: menuCard(size, 'assets/images/MyCustomer.png', 'Order Management', () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BuddyView(type: 'Sales',)));
                    }),
                  )),
              ],
            )),
            Expanded(
              child: Row(
              children: [
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: menuCard(size, 'assets/images/Payment.png','Vehicle Management', () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BuddyView(type: 'Pos',)));
                                       }),
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: menuCard(size, ImageList.serviceImage, 'Expense Management', () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExpensesMenuView()));//Snehal
                    //const BuddyView(type: 'Expense',)));
                                    }),
                  ))
              ],
            )),
          ],
        ),
        Positioned(
          left: 102,
          top: 65,
          child: SizedBox(
            width: size.width * 0.42,
            child: Utility.companyLogo != ''
                ? Image.file(
                  File(Utility.companyLogo,),
                  )
                : Column(
                    children: [
                      Icon(
                        Icons.image_not_supported_outlined,
                        size: size.height * 0.14,
                      ),
                      Text(
                        'No company logo added!',
                        style: kTxtStl13N,
                      )
                    ],
                  ),
          ),
        )
      ],
    );
  }
}
