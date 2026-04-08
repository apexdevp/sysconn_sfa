import 'package:flutter/material.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/buddy/sales/sales_menu.dart';
import 'package:sysconn_sfa/widgets/custom_appbar.dart';

//pratiksha p 20-02-2025 add this
class BuddyView extends StatefulWidget {
  final String? type; //snehal 12-11-2024 add for expenses
  const BuddyView({super.key, this.type});

  @override
  State<BuddyView> createState() => _BuddyViewState();
}

class _BuddyViewState extends State<BuddyView> with TickerProviderStateMixin {
  int menuIndexSelected = 0;
  List<String> buddyMenuTitleList =
      Utility.cmpusertype.toUpperCase() == 'ADMIN' ||
          Utility.cmpusertype.toUpperCase() == 'OWNER'
      ? ['Sales Management']
      : ['Sales Management'];
  List<String> buddyMenuImageList =
      Utility.cmpusertype.toUpperCase() == 'ADMIN' ||
          Utility.cmpusertype.toUpperCase() == 'OWNER'
      ? ['assets/images/Buddy_Sales.jpg']
      : ['assets/images/Buddy_Sales.jpg'];

  TabController? _buddySalesSubMenuTabController;

  List salesTabList = Utility.cmpusertype.toUpperCase() == 'TEAM LEADER'
      ? ['My \nActivity', 'Team Leader']
      : ['My \nActivity', 'Team Leader'];

  List salesTabIconList =
      Utility.cmpusertype.toUpperCase() == 'ADMIN' ||
          Utility.cmpusertype.toUpperCase() == 'OWNER'
      ? [Icons.add_business, Icons.people]
      : Utility.cmpusertype.toUpperCase() == 'TEAM LEADER'
      ? [Icons.add_business, Icons.people, Icons.bar_chart]
      : [Icons.add_business, Icons.people];

  //snehal 12-11-2024 add for expenses Module
  List expTabList =
      Utility.cmpusertype.toUpperCase() == 'ADMIN' ||
          Utility.cmpusertype.toUpperCase() == 'OWNER'
      ? ['My \nActivity', 'Team Leader']
      : Utility.cmpusertype.toUpperCase() == 'TEAM LEADER'
      ? ['My \nActivity', 'Team Leader']
      : ['My \nActivity'];

  List expTabIconList =
      Utility.cmpusertype.toUpperCase() == 'ADMIN' ||
          Utility.cmpusertype.toUpperCase() == 'OWNER'
      ? [Icons.add_business, Icons.people]
      : Utility.cmpusertype.toUpperCase() == 'TEAM LEADER'
      ? [Icons.add_business, Icons.people]
      : [Icons.add_business];

  @override
  void initState() {
    super.initState();
    _buddySalesSubMenuTabController = TabController(
      length: salesTabList.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _buddySalesSubMenuTabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: customAppbar(
        context: context,
        title: '${widget.type} Menu', //snehal 12-11-2024 add for expenses
      ),
      body: _buddyMenuView(size),
    );
  }

  Widget _buddyMenuView(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 3),
          child: Text(
            'Buddy',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: kAppIconColor,
            ),
          ),
        ),

        const SizedBox(height: 10),
        Expanded(child: salesMenuTab(size)),
      ],
    );
  }

  Row tabBarRow(Size size, IconData iconData, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(1.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            gradient: kButtonColor,
            //color: Colors.pink.shade200,
          ),
          child: Icon(iconData, color: Colors.white, size: size.width * 0.05),
        ),
        SizedBox(width: size.width * 0.02),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(title, style: kTxtStl14B)],
          ),
        ),
      ],
    );
  }

  Widget salesMenuTab(Size size) {
    List<Widget> salesTabWidget =
        Utility.cmpusertype.toUpperCase() == 'TEAM LEADER'
        ? [BuddyMyActivityMenuView(), BuddySalesTLMenuView()]
        : [BuddyMyActivityMenuView(), BuddySalesTLMenuView()];
    //snehal 18-01-2025 add for expenses
    // List<Widget> expTabWidget =
    //     Utility.cmpusertype.toUpperCase() == 'TEAM LEADER'
    //     ? [BuddyExpMyActivityMenuView(), BuddyExpTLMenuView()]
    //     : [BuddyExpMyActivityMenuView(), BuddyExpTLMenuView()];
    //pratiksha p 26-02-2025 add pos management
    // List<Widget> posTabWidget =
    //     Utility.cmpusertype.toUpperCase() == 'TEAM LEADER'
    //     ? [BuddyPosMyActivityMenuView(), BuddyPosTLMenuView()]
    //     : [BuddyPosMyActivityMenuView(), BuddyPosTLMenuView()];

    return Column(
      children: [
        DefaultTabController(
          length: salesTabList.length,
          child: TabBar(
            indicatorSize: TabBarIndicatorSize
                .tab, //pratiksha p 29-11-2023 add because in flutter new release space from the sides of the indicator changed
            padding: const EdgeInsets.fromLTRB(6, 4, 6, 0),
            controller: _buddySalesSubMenuTabController,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(9.0),
              border: Border.all(
                width: 2.0,
                color: Theme.of(context).colorScheme.secondary,
              ),
              color: Colors.white,
            ),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: List.generate(salesTabList.length, (index) {
              return Tab(
                child: tabBarRow(
                  size,
                  salesTabIconList[index],
                  salesTabList[index],
                ),
              );
            }),
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(9, 0, 4, 0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(40.0),
              ),
              color: Colors.white,
              border: Border.all(color: Colors.cyan.shade100),
            ),
            child: TabBarView(
              controller: _buddySalesSubMenuTabController,
              children: widget.type == 'Sales'
                  ? salesTabWidget : salesTabWidget
                  // : widget.type == 'Expense'
                  // ? expTabWidget
                  // : posTabWidget, 
            ),
          ),
        ),
      ],
    );
  }
}
