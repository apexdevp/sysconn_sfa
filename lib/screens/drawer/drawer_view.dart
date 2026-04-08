import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sysconn_sfa/Utility/image_list.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/drawer/select_company/select_company_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerForAll extends StatefulWidget {
  const DrawerForAll({super.key});

  @override
  DrawerForAllState createState() => DrawerForAllState();
}

class DrawerForAllState extends State<DrawerForAll> {
  String version = '';
  String username = '';
  String email = '';
  String expirydate = '';
  String? profileimage;

  Future getImage() async {
    try {
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String pathString = image!.path;
      await prefs.setString('profile_image', pathString);
      profileimage = prefs.getString('profile_image');
      setState(() {});
    } catch (ex) {
      // print(ex.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> drawerOptions() {
    Size size = MediaQuery.of(context).size;
    return <Widget>[
      Padding(
        padding: const EdgeInsets.fromLTRB(18, 15, 18, 15),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(231, 126, 109, 1),
                Color.fromRGBO(134, 36, 35, 1),
                Color.fromRGBO(143, 46, 42, 1),
                Color.fromRGBO(226, 121, 105, 1),
                Color.fromRGBO(134, 36, 35, 1),
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(0.5, 0.0),
            ),
            borderRadius: BorderRadius.circular(17.0),
          ),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Utility.companyName, style: kTxtStlWB),
                const SizedBox(height: 8.0),
                Text('Change Company', style: kTxtStl13WN),
              ],
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
            ),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SelectCompanyView(),
                ),
              );
              setState(() {});
            },
          ),
        ),
      ),
      // Utility.cmpusertype.toUpperCase() == 'ADMIN' ||
      //         Utility.cmpusertype.toUpperCase() == 'HR'
      //     ? Padding(
      //         padding: const EdgeInsets.only(left: 10),
      //         child: ListTile(
      //           leading: Icon(Icons.device_unknown, size: size.height * 0.03),
      //           title: const Text("Device Changed Request"),
      //           onTap: () {},
      //         ),
      //       )
      //     : Container(),
      Platform.isAndroid
          ? Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ListTile(
                leading: Image.asset(
                  ImageList.share,
                  height: size.height * 0.03,
                ),
                title: const Text("Share App"),
                // onTap: () {
                //   Share.share(
                //       'https://play.google.com/store/apps/details?id=com.apex.maxretailer',
                //       subject: 'Retailer App');
                // },
              ),
            )
          : Container(),
      //snehal 28-11-2024 add for about systemxs menu
      // Padding(
      //   padding: const EdgeInsets.only(left: 10),
      //   child: ListTile(
      //     leading: Icon(Icons.description_outlined, size: size.height * 0.03),
      //     title: const Text("About SystemXs"),
      //     onTap: () {
      //       Navigator.pop(context);
      //       showModalBottomSheet(
      //         context: context,
      //         builder: (context) {
      //           return Column(
      //             mainAxisSize: MainAxisSize.min,
      //             children: <Widget>[
      //               SizedBox(height: 10.0),
      //               Image.asset(
      //                 'assets/images/SystemxsLogoWS.png',
      //                 fit: BoxFit.fill,
      //                 height: 80.0,
      //               ),
      //               ListTile(
      //                 leading: Icon(
      //                   Icons.phone_outlined,
      //                   color: Color.fromRGBO(14, 117, 145, 1.0),
      //                 ),
      //                 title: Text('+91 86577 80635'),
      //                 onTap: () {
      //                   _launchURL('tel:+91-86577-80635');
      //                 },
      //               ),
      //               ListTile(
      //                 leading: Icon(
      //                   Icons.location_on_outlined,
      //                   color: Color.fromRGBO(14, 117, 145, 1.0),
      //                 ),
      //                 title: Text(
      //                   '8th Floor, Balaji Infotech Park, Plot No. A-278, Wagle Industrial Estate, Road No. 16 A, Lane Next to Wagle Police Station, Thane - 400604',
      //                 ),
      //               ),
      //               Platform.isAndroid
      //                   ? ListTile(
      //                       leading: Icon(
      //                         Icons.public,
      //                         color: Color.fromRGBO(14, 117, 145, 1.0),
      //                       ),
      //                       title: Text('www.systemxs.ai'),
      //                       onTap: () {
      //                         _launchURL('https://systemxs.ai/');
      //                         // 'https://www.max2tally.com/'
      //                       },
      //                     )
      //                   : Container(),
      //               ListTile(
      //                 leading: Icon(
      //                   Icons.markunread_outlined,
      //                   color: Color.fromRGBO(14, 117, 145, 1.0),
      //                 ),
      //                 title: Text('maxhelp@apexactsoft.com'),
      //                 onTap: () {
      //                   _launchURL('mailto:maxhelp@apexactsoft.com');
      //                 },
      //               ),
      //               SizedBox(height: 10.0),
      //             ],
      //           );
      //         },
      //       );
      //     },
      //   ),
      // ),

      Padding(
        padding: const EdgeInsets.only(left: 10),
        child: ListTile(
          leading: Image.asset(ImageList.logout, height: size.height * 0.03),
          title: const Text("Logout"),
          onTap: () {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/', (route) => false);
          },
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(60),
            bottomRight: Radius.circular(60),
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.35,
                  child: DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(238, 242, 251, 10),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(70),
                        bottomLeft: Radius.circular(77),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(22, 12, 8, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                ImageList.profile,
                                height: size.height * 0.04,
                              ),
                              SizedBox(width: size.width * 0.05),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(username, style: kTxtStl17B),
                                  Text(email, style: kTxtStl13B),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.09),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(children: drawerOptions()),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 80,
              top: 176,
              child: SizedBox(
                width:
                    size.width *
                    0.42, //pooja // 20-08-2024 // change hardcoded to value
                child: Utility.companyLogo != ''
                    ? Image.file(File(Utility.companyLogo))
                    : Column(
                        children: [
                          Icon(
                            Icons.image_not_supported_outlined,
                            size: size.height * 0.14,
                          ),
                          Text('No company logo added!', style: kTxtStl13N),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      print('ahscbauibcajcbakcna');
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  void _getUserDetails() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    SharedPreferences shaprefs = await SharedPreferences.getInstance();
    setState(() {
      username = (shaprefs.getString('UserName')) ?? '';
      email = (shaprefs.getString('Email_Id')) ?? '';
      expirydate = (shaprefs.getString('ExpiryDate')) ?? '';
      version = packageInfo.version;
      profileimage = shaprefs.getString('profile_image');
    });
  }

  //snehal 28-11-2024 add for whats app
  Future<void> _openWhatsApp(String number) async {
    var whatsapp = number;
    Uri whatsappurlandroid = Uri.parse(
      "whatsapp://send?phone=$whatsapp&text=hello",
    );
    Uri whatappurlios = Uri.parse(
      "https://wa.me/$whatsapp?text=${Uri.parse("hello")}",
    );
    if (Platform.isIOS) {
      if (await canLaunchUrl(whatappurlios)) {
        await launchUrl(whatappurlios);
      } else {
        scaffoldMessageBar( 'whatsApp not installed');
      }
    } else {
      // android , web
      if (await canLaunchUrl(whatsappurlandroid)) {
        await launchUrl(whatsappurlandroid);
      } else {
        scaffoldMessageBar( 'whatsApp no installed');
      }
    }
  }
}
