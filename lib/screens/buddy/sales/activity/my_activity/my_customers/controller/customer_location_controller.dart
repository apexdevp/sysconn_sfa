import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetCurrentLocationController extends GetxController {
  final String latitude;
  final String longitude;
  final String? partyname;
  final String? custclassfication;

  GetCurrentLocationController({
    required this.latitude,
    required this.longitude,
    this.partyname,
    this.custclassfication,
  });

  Rxn<Position> position = Rxn<Position>();

  late LatLng initialLatLng;

  @override
  void onInit() {
    super.onInit();

    initialLatLng = LatLng(
      double.tryParse(latitude) ?? 0.0,
      double.tryParse(longitude) ?? 0.0,
    );

    getCurrentLocation();
  }

  /// SAME METHOD NAME
  void getCurrentLocation() async {
    Position res = await Geolocator.getCurrentPosition();
    position.value = res;
  }

  Set<Marker> createMarker() {
    return {
      Marker(
        markerId: const MarkerId('Home'),
        position: initialLatLng,
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
          title: partyname,
          snippet: custclassfication,
        ),
      ),
    };
  }
}