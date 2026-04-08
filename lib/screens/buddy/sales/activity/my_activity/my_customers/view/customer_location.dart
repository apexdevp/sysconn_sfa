import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/controller/customer_location_controller.dart';


class GetCurrentLocation extends StatelessWidget {

  final String latitude;
  final String longitude;
  final String? partyname;
  final String? custclassfication;

  const GetCurrentLocation({super.key, 
    required this.latitude,
    required this.longitude,
    this.partyname,
    this.custclassfication,
  });

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(
      GetCurrentLocationController(
        latitude: latitude,
        longitude: longitude,
        partyname: partyname,
        custclassfication: custclassfication,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Location'),
      ),
      body:
      //  Obx(() {
      //   return 
        GoogleMap(
          mapType: MapType.normal,
          markers: controller.createMarker(),
          initialCameraPosition: CameraPosition(
            target: controller.initialLatLng,
            zoom: 12,
          ),
          compassEnabled: true,
          myLocationEnabled: true,
          onMapCreated: (GoogleMapController mapController) {},
        )
      // }),
    );
  }
}