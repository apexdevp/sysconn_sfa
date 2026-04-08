import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/company/companyentity.dart';
import 'package:sysconn_sfa/widgets/custom_appbar.dart';
import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';

class SelectCompanyView extends StatefulWidget {
  const SelectCompanyView({super.key});

  @override
  State<SelectCompanyView> createState() => _SelectCompanyViewState();
}

class _SelectCompanyViewState extends State<SelectCompanyView> {
  bool isDataLoad = false;
  List<CompanyEntity> allCompanyDataList = [];

  @override
  void initState() {
    super.initState();
    Utility.checkInternetIsConnected(
      onCallFun: () async {
        ApiCall.getAllCompanyDetApi().then((value) {
          // print(value);
          if (mounted) {
            setState(() {
              allCompanyDataList = value;
              isDataLoad = true;
            });
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: 'Select Company'),
      body: !isDataLoad
          ? Center(child: Utility.processLoadingWidget())
          : allCompanyDataList.isEmpty
          ? const NoDataFound()
          : ListView.builder(
              itemCount: allCompanyDataList.length,
              itemBuilder: (context, i) {
                return InkWell(
                  child: Container(
                    padding: const EdgeInsets.all(14.0),
                    margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.0),
                      color:
                          Utility.companyId == allCompanyDataList[i].companyid
                          ? Colors.grey.shade300
                          : Colors.white,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: kAppColor,
                          radius: 32,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 30,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: allCompanyDataList[i].companylogo == ''
                                  ? const Icon(Icons.image_not_supported)
                                  : Image.network(
                                      allCompanyDataList[i].companylogo!,
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Flexible(
                          child: Column(
                            children: [
                              Text(
                                allCompanyDataList[i].companyname!,
                                style: kTxtStl16N,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Utility.showCircularLoadingWid(context);
                    saveSelectedCompanyData(allCompanyDataList[i]);
                  },
                );
              },
            ),
    );
  }

  Future saveSelectedCompanyData(CompanyEntity selectedCompanyEntity) async {
    await _downloadAndSavePhoto(selectedCompanyEntity.companylogo).then((
      selectedCompanyLogo,
    ) async {
      await Utility.saveCompanyDetails(
        selectedCompanyEntity.companyid!,
        selectedCompanyEntity.companyname!,
        // selectedCompanyEntity.partnercode!,
        selectedCompanyEntity.mailingname!,
        selectedCompanyEntity.companyusertype!,
        selectedCompanyLogo, selectedCompanyEntity.groupId!
      ).then((value) async {
        // selectedCompanyEntity.tallysyncdate!
        await ApiCall.getCompanyDataAPI().then((value) async {
          await ApiCall.getPartyDetCMPApi().then((value) {
            Utility.companyMasterEntity = selectedCompanyEntity;
            // print('Utility.companyLogo ${Utility.companyLogo}');
            // print(' Utility.companyMasterEntity ${ Utility.companyMasterEntity.toMap()}');
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            if (mounted) {
              setState(() {});
            }
          });
        });
      });
    });
  }

  // save company logo
  Future<String> _downloadAndSavePhoto(String? cmpLogo) async {
    String companyLogo = '';
    if (cmpLogo == '') {
      companyLogo = '';
    } else {
      imageCache.clear();
      var response = await http.get(Uri.parse(cmpLogo!)); //%%%
      // documentDirectory is the unique device path to the area you'll be saving in
      var documentDirectory = await getApplicationDocumentsDirectory();
      var firstPath = "${documentDirectory.path}/images"; //%%%
      String extension = cmpLogo.substring(cmpLogo.lastIndexOf('.') + 1);
      //You'll have to manually create subdirectories
      await Directory(firstPath).create(recursive: true); //%%%
      // Name the file, create the file, and save in byte form.
      var filePathAndName = '${documentDirectory.path}/images/pic.$extension';
      File file2 = File(filePathAndName); //%%%
      file2.writeAsBytesSync(response.bodyBytes); //%%%

      // When the data is available, display it
      companyLogo = filePathAndName;
    }
    return companyLogo;
  }
}
